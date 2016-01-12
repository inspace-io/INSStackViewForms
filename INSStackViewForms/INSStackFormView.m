//
//  INSStackViewFormViewController.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "INSStackFormView.h"
#import "INSStackFormViewBaseElement_Private.h"
#import "INSStackFormViewUpdateItem.h"

@interface INSStackFormView ()
@property (nonatomic, strong) NSArray <INSStackFormSection *> *sections;
@property (nonatomic, assign) BOOL itemCountsAreValid;
@property (nonatomic, assign, getter=isUpdating) BOOL updating;

@property (nonatomic, strong) NSMutableArray *insertItems;
@property (nonatomic, strong) NSMutableArray *deleteItems;
@property (nonatomic, strong) NSMutableArray *reloadItems;
@property (nonatomic, strong) NSMutableArray *moveItems;
@end

@implementation INSStackFormView

- (NSArray <INSStackFormSection *> *)sections {
    [self validateLayout];
    return _sections;
}
- (NSMutableArray *)arrayForUpdateAction:(INSStackFormViewUpdateAction)updateAction {
    NSMutableArray *updateActions = nil;
    
    switch (updateAction) {
        case INSStackFormViewUpdateActionInsert:
            if (!_insertItems) _insertItems = [NSMutableArray new];
            updateActions = _insertItems;
            break;
        case INSStackFormViewUpdateActionDelete:
            if (!_deleteItems) _deleteItems = [NSMutableArray new];
            updateActions = _deleteItems;
            break;
        case INSStackFormViewUpdateActionMove:
            if (!_moveItems) _moveItems = [NSMutableArray new];
            updateActions = _moveItems;
            break;
        case INSStackFormViewUpdateActionReload:
            if (!_reloadItems) _reloadItems = [NSMutableArray new];
            updateActions = _reloadItems;
            break;
        default: break;
    }
    return updateActions;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureStackView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureStackView];
    }
    return self;
}

#pragma mark - Initial Configuration

- (void)configureStackView {
    _sections = @[];
    
    self.axis = UILayoutConstraintAxisVertical;
    self.distribution = 0;
    self.alignment = 0;
}

- (NSArray <INSStackFormSection *> *)initialCollectionSections {
    return [self.dataSource sectionsForStackFormView:self] ?: @[];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self validateLayout];
}

#pragma mark - Reload

- (void)validateLayout {
    if (!self.itemCountsAreValid) {
        [self loadData];
    }
}

- (void)loadData {
    _sections = [self initialCollectionSections];
    
    [_sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        if (section.headerItem) {
            [self intitializeAndAddItemViewForItem:section.headerItem section:section];
        }
        [section.items enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self intitializeAndAddItemViewForItem:obj section:section];
        }];
        if (section.footerItem) {
            [self intitializeAndAddItemViewForItem:section.footerItem section:section];
        }
    }];
    
    self.itemCountsAreValid = YES;
}

- (void)reloadData {
    self.itemCountsAreValid = NO;
    
    for (UIView *view in [self.arrangedSubviews copy]) {
        [self removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    [self setNeedsLayout];
}

- (void)refreshViews {
    [_sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
        __block NSInteger index = [self startIndexForSection:section];
        
        if (section.headerItem) {
            [self configureItemView:self.arrangedSubviews[index] forItem:section.headerItem section:section];
            index++;
        }
        [section.items enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self configureItemView:self.arrangedSubviews[index] forItem:obj section:section];
            index++;
        }];
        if (section.footerItem) {
            [self configureItemView:self.arrangedSubviews[index] forItem:section.footerItem section:section];
        }
    }];
    
    [self layoutIfNeeded];
}

- (void)refreshViewForItem:(INSStackFormItem *)item {
    for (INSStackFormSection *section in _sections) {
        __block NSInteger index = [self startIndexForSection:section];
        
        if (section.headerItem) {
            if (section.headerItem == item) {
                [self configureItemView:self.arrangedSubviews[index] forItem:section.headerItem section:section];
            }
            index++;
        }
        
        for (INSStackFormItem *sectionItem in section.items) {
            if (sectionItem == item) {
                [self configureItemView:self.arrangedSubviews[index] forItem:sectionItem section:section];
                return;
            }
            index++;
        }
        if (section.footerItem == item) {
            [self configureItemView:self.arrangedSubviews[index] forItem:section.footerItem section:section];
            return;
        }
    }
    
    [self layoutIfNeeded];
}

#pragma mark - Animate Changes

- (void)beginUpdates {
    self.updating = YES;
}
- (void)endUpdates {
    
}

- (void)insertSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionInsert];
}
- (void)deleteSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionDelete];
}
- (void)reloadSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionReload];
}
- (void)moveSection:(nonnull INSStackFormSection *)section toIndex:(NSInteger)newSectionIndex {
    
}

- (void)updateSections:(NSArray <INSStackFormSection *> *)sections updateAction:(INSStackFormViewUpdateAction)updateAction {
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdates];
    }

    NSMutableArray *updateActions = [self arrayForUpdateAction:updateAction];
    
    NSIndexSet *indexSet = [_sections indexesOfObjectsPassingTest:^BOOL(INSStackFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [sections containsObject:obj];
    }];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        INSStackFormViewUpdateItem *updateItem = [[INSStackFormViewUpdateItem alloc] initWithAction:updateAction forIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:(NSInteger)section]];
        [updateActions addObject:updateItem];
    }];
    
    if (!updating) [self endUpdates];
}

#pragma mark - Private

- (NSUInteger)startIndexForSection:(INSStackFormSection *)searchingSection {
    NSUInteger index = 0;
    for (INSStackFormSection *section in _sections) {
        if (section == searchingSection) {
            return index;
        }
        
        if (section.headerItem || section.footerItem) {
            index++;
        }
        index += section.items.count;
    }
    return NSNotFound;
}

#pragma mark - Public

- (INSStackFormItem *)firstItemWithIdentifier:(NSString *)identifier {
    [self validateLayout];
    
    for (INSStackFormSection *section in _sections) {
        for (INSStackFormItem *item in section.items) {
            if ([item.identifier isEqualToString:identifier]) {
                return item;
            }
        }
    }
    return nil;
}

- (INSStackFormItem *)itemWithIdentifier:(NSString *)identifier inSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    for (INSStackFormItem *item in section.items) {
        if ([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    return nil;
}

- (INSStackFormSection *)sectionWithIdentifier:(NSString *)identifier {
    [self validateLayout];
    
    for (INSStackFormSection *section in _sections) {
        if ([section.identifier isEqualToString:identifier]) {
            return section;
        }
    }
    return nil;
}

- (NSArray <__kindof UIView *> *)viewsForSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    for (INSStackFormSection *object in _sections) {
        if (object == section) {
            NSInteger startIndex = [self startIndexForSection:section];
            NSInteger itemCount = object.items.count;
            if (object.headerItem) {
                itemCount++;
            }
            if (object.footerItem) {
                itemCount++;
            }
            return [self.arrangedSubviews objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, itemCount)]];
        }
    }
    return nil;
}

- (__kindof UIView *)viewForItem:(INSStackFormItem *)item inSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    for (INSStackFormSection *object in _sections) {
        if (object == section) {
            NSInteger startIndex = [self startIndexForSection:section];
            if (object.headerItem) {
                startIndex++;
            }
            for (INSStackFormItem *itemObject in object.items) {
                if (itemObject == item) {
                    return [self.arrangedSubviews objectAtIndex:startIndex];
                }
                startIndex++;
            }
        }
    }
    return nil;
}

- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    [self validateLayout];
    
    if (animated) {
        UIView *viewForItem = [self viewForItem:item inSection:section];
        [self sendSubviewToBack:viewForItem];
        
        [UIView animateWithDuration:0.25 animations:^{
            viewForItem.hidden = YES;
            viewForItem.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeItem:item fromSection:section];
            if (completion) {
                completion();
            }
        }];
    } else {
        [self removeItem:item fromSection:section];
        if (completion) {
            completion();
        }
    }
}

- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    [_sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger startIndex = [self startIndexForSection:section];
        
        if (item == section.headerItem) {
            section.headerItem = nil;
            UIView *view = self.arrangedSubviews[startIndex];
            [self removeArrangedSubview:view];
            [view removeFromSuperview];
            
            *stop = YES;
        } else if (item == section.footerItem) {
            section.footerItem = nil;
            UIView *view = self.arrangedSubviews[startIndex+section.items.count-1];
            [self removeArrangedSubview:view];
            [view removeFromSuperview];
            *stop = YES;
        } else {
            [[section.items copy] enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj == item) {
                    [section removeItem:obj];
                    UIView *view = self.arrangedSubviews[startIndex+idx];
                    [self removeArrangedSubview:view];
                    [view removeFromSuperview];
                    *stop = YES;
                }
            }];
        }
    }];
}

- (__kindof UIView *)addItem:(INSStackFormItem *)item toSection:(INSStackFormSection *)section {
    return [self insertItem:item atIndex:section.items.count toSection:section];
}

- (__kindof UIView *)insertItem:(INSStackFormItem *)item atIndex:(NSUInteger)index toSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    NSAssert([_sections containsObject:section], @"You are trying to insert item to section which don't exist");
    
    NSUInteger sectionIndex = [_sections indexOfObject:section];

    NSInteger startIndex = sectionIndex <= 0 ? 0 : [self startIndexForSection:section];
    [section insertItem:item atIndex:index];
    
    UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [item.height doubleValue])];
    [self configureItemView:itemView forItem:item section:section];
    
    [self insertArrangedSubview:itemView atIndex:startIndex + index];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
    
    return itemView;
}


- (void)removeSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    [self validateLayout];
    
    if (animated) {
        NSArray <UIView *> *subviews = [self viewsForSection:section];
        [[subviews.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sendSubviewToBack:obj];
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in subviews) {
                view.hidden = YES;
                view.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            [self removeSection:section];
            if (completion) {
                completion();
            }
        }];
    } else {
        [self removeSection:section];
        if (completion) {
            completion();
        }
    }
}

- (void)removeSection:(INSStackFormSection *)section {
    [self validateLayout];
    
    NSMutableArray *mutableSections = [_sections mutableCopy];
    [_sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == section) {
            NSArray *subviews = [self viewsForSection:section];
            for (UIView *view in subviews) {
                [self removeArrangedSubview:view];
                [view removeFromSuperview];
            }
            
            [mutableSections removeObject:section];
            *stop = YES;
        }
    }];
    _sections = [mutableSections copy];
}
- (NSArray <__kindof UIView *> *)addSection:(INSStackFormSection *)section {
    return [self insertSection:section atIndex:_sections.count];
}
- (NSArray <__kindof UIView *> *)insertSection:(INSStackFormSection *)section atIndex:(NSUInteger)index {
    [self validateLayout];
    
    NSMutableArray *mutableSections = [_sections mutableCopy];
    [mutableSections insertObject:section atIndex:index];
    _sections = [mutableSections copy];
    
    __block NSUInteger startIndex = [self startIndexForSection:section];
    
    NSMutableArray *insertedViews = [NSMutableArray array];
    
    if (section.headerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.headerItem section:section];
        [self insertArrangedSubview:itemView atIndex:startIndex];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
        
        [insertedViews addObject:itemView];
        startIndex++;
    }
    [section.items enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *itemView = [self intitializeItemViewForItem:obj section:section];
        [self insertArrangedSubview:itemView atIndex:startIndex];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
        
        [insertedViews addObject:itemView];
        startIndex++;
    }];
    if (section.footerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.footerItem section:section];
        [self insertArrangedSubview:itemView atIndex:startIndex];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
        
        [insertedViews addObject:itemView];
    }
    return [insertedViews copy];
}

#pragma mark - Private item initialization and configuration

- (void)intitializeAndAddItemViewForItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    UIView *itemView = [self intitializeItemViewForItem:item section:section];
    [self addArrangedSubview:itemView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
}

- (UIView *)intitializeItemViewForItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [item.height doubleValue])];
    [self configureItemView:itemView forItem:item section:section];
    return itemView;
}

- (void)configureItemView:(UIView *)itemView forItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    
    if (item.height) {
        [itemView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[itemView(height)]" options:0 metrics:@{@"height":item.height} views:NSDictionaryOfVariableBindings(itemView)]];
    }
    
    if ([itemView isKindOfClass:[INSStackFormViewBaseElement class]]) {
        INSStackFormViewBaseElement *formView = (INSStackFormViewBaseElement *)itemView;
        formView.stackFormView = self;
        formView.section = section;
        formView.item = item;
        [formView configure];
        [formView hideAllDelimiters];
        
        if (section.showItemSeparators) {
            formView.topDelimiterInset = section.separatorInset;
            NSUInteger index = [section.items indexOfObject:item];
            formView.showTopDelimiter = NO;
            formView.showBottomDelimiter = NO;
            
            if (section.items.count == 1) {
                formView.topDelimiterInset = UIEdgeInsetsZero;
                formView.showTopDelimiter = YES;
                formView.showBottomDelimiter = YES;
            } else if (index == section.items.count - 1) {
                formView.showTopDelimiter = YES;
                formView.showBottomDelimiter = YES;
            } else if (index == 0) {
                formView.showTopDelimiter = YES;
                formView.topDelimiterInset = UIEdgeInsetsZero;
            } else {
                formView.showTopDelimiter = YES;
            }

        }
    }
    
    if (item.configurationBlock) {
        item.configurationBlock(itemView);
    }
}

#pragma mark - Validation

- (BOOL)validateDataItems:(NSArray <NSString *> * __autoreleasing *)errorMessages {
    [self validateLayout];
    
    NSMutableArray *errors = [NSMutableArray array];
    __block BOOL isValid = YES;
    
    [_sections enumerateObjectsUsingBlock:^(INSStackFormSection *section, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *sectionErrors = nil;
        BOOL sectionValid = [self validateSection:section errorMessages:&sectionErrors];
        if (isValid) {
            isValid = sectionValid;
        }
        [errors addObjectsFromArray:sectionErrors];
    }];
    
    *errorMessages = [errors copy];
    return isValid;
}

- (BOOL)validateSection:(INSStackFormSection *)section errorMessages:(NSArray <NSString *> * __autoreleasing *)errorMessages {
    [self validateLayout];
    
    NSMutableArray *errors = [NSMutableArray array];
    __block BOOL isValid = YES;
    
    NSMutableArray *items = [section.items mutableCopy] ?: [@[] mutableCopy];
    if (section.headerItem) {
        [items insertObject:section.headerItem atIndex:0];
    }
    if (section.footerItem) {
        [items addObject:section.footerItem];
    }
    
    [items enumerateObjectsUsingBlock:^(INSStackFormItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.validationBlock) {
            NSString *errorMessage = nil;
            BOOL isItemValid = item.validationBlock([self viewForItem:item inSection:section],item,&errorMessage);
            if (!isItemValid) {
                NSAssert(errorMessage != nil, @"If item is not valid, you must provide error message");
                [errors addObject:errorMessage];
                isValid = NO;
            }
        }
    }];
    *errorMessages = [errors copy];
    return isValid;
}

@end
