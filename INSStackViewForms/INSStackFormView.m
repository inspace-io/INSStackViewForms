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
@property (nonatomic, assign) BOOL animateUpdating;
@property (nonatomic, assign) NSInteger reloadingSuspendedCount;

@property (nonatomic, strong) NSMutableArray *insertItems;
@property (nonatomic, strong) NSMutableArray *deleteItems;
@property (nonatomic, strong) NSMutableArray *reloadItems;
@property (nonatomic, strong) NSMutableArray *refreshItems;
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
        case INSStackFormViewUpdateActionRefresh:
            if (!_refreshItems) _refreshItems = [NSMutableArray new];
            updateActions = _refreshItems;
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
    return [self.dataSource sectionsForStackFormView:self] ?: _sections;
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
        [section.itemsIncludingSupplementaryItems enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self intitializeAndAddItemViewForItem:obj section:section];
        }];
    }];
    
    self.itemCountsAreValid = YES;
}

- (void)reloadData {
    if (self.reloadingSuspendedCount != 0) {
        return;
    }
    
    self.itemCountsAreValid = NO;
    
    for (UIView *view in [self.arrangedSubviews copy]) {
        [self removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    [self setNeedsLayout];
}

- (void)refreshViewsForItems:(NSArray <INSStackFormItem *> *)items {
    for (INSStackFormSection *section in _sections) {
        __block NSInteger index = [self startIndexForSection:section];
        
        [section.itemsIncludingSupplementaryItems enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([items containsObject:obj]) {
                [self configureItemView:self.arrangedSubviews[index] forItem:section.headerItem section:section];
            }
            index++;
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)refreshViewForItem:(INSStackFormItem *)item {
    [self refreshViewsForItems:@[item]];
}

#pragma mark - Animate Changes

- (void)suspendReloads {
    self.reloadingSuspendedCount++;
}

- (void)resumeReloads {
    if (self.reloadingSuspendedCount > 0) {
        self.reloadingSuspendedCount--;
    }
}

- (void)finishUpdating {
    [self resumeReloads];
    self.insertItems = nil;
    self.deleteItems = nil;
    self.moveItems = nil;
    self.reloadItems = nil;
    self.updating = NO;
}

#pragma mark - Managing Items

- (void)beginUpdates {
    [self beginUpdatesWithAnimation:YES];
}

- (void)beginUpdatesWithAnimation:(BOOL)animations {
    [self validateLayout];
    
    [self suspendReloads];
    self.animateUpdating = animations;
    self.updating = YES;
}

- (void)endUpdates {
    [self endUpdatesWithCompletion:nil];
}

- (void)performBatchUpdates:(nonnull void (^)(void))updates completion:(nullable void (^)(BOOL finished))completion {
    [self beginUpdates];
    updates();
    [self endUpdatesWithCompletion:completion];
}

- (void)endUpdatesWithCompletion:(void(^)(BOOL finished))completion {

    NSMutableArray *sortedMutableRefreshItems = [[self.refreshItems sortedArrayUsingSelector:@selector(compareIndexPaths:)] mutableCopy];
    NSMutableArray *sortedMutableReloadItems = [[self.reloadItems sortedArrayUsingSelector:@selector(compareIndexPaths:)] mutableCopy];
    NSMutableArray *sortedMutableMoveItems = [[self.moveItems sortedArrayUsingSelector:@selector(compareIndexPaths:)] mutableCopy];
    NSMutableArray *sortedDeletedMutableItems = [[self.deleteItems sortedArrayUsingSelector:@selector(inverseCompareIndexPaths:)] mutableCopy];
    NSMutableArray *sortedInsertMutableItems = [[self.insertItems sortedArrayUsingSelector:@selector(compareIndexPaths:)] mutableCopy];
    
    for (INSStackFormViewUpdateItem *updateItem in sortedMutableRefreshItems) {
        if ([updateItem isSectionOperation]) {
            [self refreshViewsForItems:updateItem.section.itemsIncludingSupplementaryItems];
        } else {
            [self refreshViewForItem:updateItem.item];
        }
    }
    
    for (INSStackFormViewUpdateItem *updateItem in sortedMutableReloadItems) {
        if ([updateItem isSectionOperation]) {
            [self removeSection:updateItem.section];
            [self insertSection:updateItem.section atIndex:updateItem.indexPathAfterUpdate.section];
        } else {
            [self removeItem:updateItem.item fromSection:updateItem.section];
            [self insertItem:updateItem.item atIndex:updateItem.indexPathAfterUpdate.item toSection:updateItem.section];
        }
    }
    

    NSMutableArray *layoutUpdateItems = [[NSMutableArray alloc] init];
    
    [layoutUpdateItems addObjectsFromArray:sortedDeletedMutableItems];
    [layoutUpdateItems addObjectsFromArray:sortedMutableMoveItems];
    [layoutUpdateItems addObjectsFromArray:sortedInsertMutableItems];
    
    NSMutableArray *viewsToRemove = [NSMutableArray array];
    NSMutableArray *viewsToShow = [NSMutableArray array];

    for (INSStackFormViewUpdateItem *updateItem in layoutUpdateItems) {
        switch (updateItem.updateAction) {
            case INSStackFormViewUpdateActionDelete: {
                if (updateItem.isSectionOperation) {
                    [viewsToRemove addObjectsFromArray:[self viewsForSection:updateItem.section]];
                }else {
                    [viewsToRemove addObject:[self viewForItem:updateItem.item inSection:updateItem.section]];
                }
            }
            break;
            case INSStackFormViewUpdateActionInsert: {
                if (updateItem.isSectionOperation) {
                    [viewsToShow addObjectsFromArray:[self insertSection:updateItem.section atIndex:(NSUInteger)updateItem.indexPathAfterUpdate.section]];
                }else {
                    [viewsToShow addObject:[self insertItem:updateItem.item atIndex:updateItem.indexPathAfterUpdate.item toSection:updateItem.section]];
                }
            }
            break;
                
            case INSStackFormViewUpdateActionMove: {
                if (updateItem.isSectionOperation) {
                    INSStackFormSection *section = self.sections[(NSUInteger)updateItem.indexPathBeforeUpdate.section];
                    [self moveSection:section atIndex:(NSUInteger)updateItem.indexPathAfterUpdate.section];
                }
                else {
                    INSStackFormSection *section = self.sections[(NSUInteger)updateItem.indexPathBeforeUpdate.section];
                    [self moveItem:updateItem.item inSection:section toSection:updateItem.section atIndex:updateItem.indexPathAfterUpdate.item];
                }
            }
            break;
            default: break;
        }
    }
    
    if (self.animateUpdating) {
        self.userInteractionEnabled = NO;
        
        for (UIView *view in viewsToShow) {
            view.hidden = YES;
            view.alpha = 0.0;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in viewsToShow) {
                view.hidden = NO;
                view.alpha = 1.0;
            }
            
            for (UIView *view in viewsToRemove) {
                view.hidden = YES;
                view.alpha = 0.0;
            }
            
        } completion:^(BOOL finished) {
            for (INSStackFormViewUpdateItem *updateItem in sortedDeletedMutableItems) {
                if (updateItem.isSectionOperation) {
                    [self removeSection:updateItem.section];
                } else {
                    [self removeItem:updateItem.item fromSection:updateItem.section];
                }
            }
            self.userInteractionEnabled = YES;
            [self finishUpdating];
            if (completion) {
                completion(finished);
            }
        }];
 
    } else {
        for (INSStackFormViewUpdateItem *updateItem in sortedDeletedMutableItems) {
            if (updateItem.isSectionOperation) {
                [self removeSection:updateItem.section];
            } else {
                [self removeItem:updateItem.item fromSection:updateItem.section];
            }
        }
        [self finishUpdating];
        if (completion) {
            completion(YES);
        }
    }

}

- (void)addSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self insertSections:sections atIndex:self.sections.count];
}

- (void)insertSections:(nonnull NSArray <INSStackFormSection *> *)sections atIndex:(NSInteger)index {
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }
    
    NSMutableArray *updateActions = [self arrayForUpdateAction:INSStackFormViewUpdateActionInsert];
    
    [[[sections reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        INSStackFormViewUpdateItem *updateItem = [[INSStackFormViewUpdateItem alloc] initWithAction:INSStackFormViewUpdateActionInsert forIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:index] section:obj item:nil];
        [updateActions addObject:updateItem];
    }];

    
    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
}
- (void)deleteSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionDelete];
}
- (void)reloadSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionReload];
}
- (void)refreshSections:(nonnull NSArray <INSStackFormSection *> *)sections {
    [self updateSections:sections updateAction:INSStackFormViewUpdateActionRefresh];
}
- (void)moveSection:(nonnull INSStackFormSection *)section toIndex:(NSInteger)newSectionIndex {
    
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }
    
    NSInteger indexForSection = [self.sections indexOfObject:section];
    
    NSMutableArray *moveUpdateItems = [self arrayForUpdateAction:INSStackFormViewUpdateActionMove];
    [moveUpdateItems addObject:
     [[INSStackFormViewUpdateItem alloc] initWithInitialIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:indexForSection]
                                                    finalIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:newSectionIndex]
                                                      updateAction:INSStackFormViewUpdateActionMove section:section item:nil]];
    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
}

- (void)updateSections:(NSArray <INSStackFormSection *> *)sections updateAction:(INSStackFormViewUpdateAction)updateAction {
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }

    NSMutableArray *updateActions = [self arrayForUpdateAction:updateAction];
    
    NSIndexSet *indexSet = [_sections indexesOfObjectsPassingTest:^BOOL(INSStackFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [sections containsObject:obj];
    }];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        INSStackFormViewUpdateItem *updateItem = [[INSStackFormViewUpdateItem alloc] initWithAction:updateAction forIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:(NSInteger)section] section:_sections[section] item:nil];
        [updateActions addObject:updateItem];
    }];
    
    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
}

- (void)addItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)section atIndex:(NSUInteger)index {
    [self insertItems:items toSection:section atIndex:section.items.count];
}

- (void)insertItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)section atIndex:(NSUInteger)index {
    NSParameterAssert([_sections containsObject:section]);
    
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }
    
    NSMutableArray *updateActions = [self arrayForUpdateAction:INSStackFormViewUpdateActionInsert];
    
    NSInteger sectionIndexPath = [_sections indexOfObject:section];
    
    [[[items reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        INSStackFormViewUpdateItem *updateItem = [[INSStackFormViewUpdateItem alloc] initWithAction:INSStackFormViewUpdateActionInsert forIndexPath:[NSIndexPath indexPathForItem:index inSection:(NSInteger)sectionIndexPath] section:section item:obj];
        [updateActions addObject:updateItem];
    }];
    
    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
    
}
- (void)deleteItems:(nonnull NSArray <INSStackFormItem *> *)items {
    [self updateItems:items updateAction:INSStackFormViewUpdateActionDelete];
}
- (void)reloadItems:(nonnull NSArray <INSStackFormItem *> *)items {
    [self updateItems:items updateAction:INSStackFormViewUpdateActionReload];
}
- (void)refreshItems:(nonnull NSArray <INSStackFormItem *> *)items {
    [self updateItems:items updateAction:INSStackFormViewUpdateActionRefresh];
}
- (void)moveItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)toSection atIndex:(NSUInteger)index {
    
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }
    
    NSInteger indexForSection = [self.sections indexOfObject:toSection];
    
    NSMutableArray *moveUpdateItems = [self arrayForUpdateAction:INSStackFormViewUpdateActionMove];
    
    NSInteger indexToMove = 0;
    
    for (NSInteger i = 0; i < _sections.count; i++) {
        INSStackFormSection *section = _sections[i];
        for (NSInteger j = 0; j < section.items.count; j++) {
            INSStackFormItem *sectionItem = section.items[j];
            
            if ([items containsObject:sectionItem]) {
                [moveUpdateItems addObject:
                 [[INSStackFormViewUpdateItem alloc] initWithInitialIndexPath:[NSIndexPath indexPathForItem:j inSection:i]
                                                               finalIndexPath:[NSIndexPath indexPathForItem:index + indexToMove inSection:indexForSection]
                                                                 updateAction:INSStackFormViewUpdateActionMove section:toSection item:sectionItem]];
                indexToMove++;
            }
        }
    }
    

    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
}

- (void)updateItems:(nonnull NSArray <INSStackFormItem *> *)items updateAction:(INSStackFormViewUpdateAction)updateAction {
    BOOL updating = self.updating;
    if (!updating) {
        [self beginUpdatesWithAnimation:NO];
    }

    NSMutableArray *updateActions = [self arrayForUpdateAction:updateAction];
    
    for (NSInteger i = 0; i < _sections.count; i++) {
        INSStackFormSection *section = _sections[i];
        for (NSInteger j = 0; j < section.items.count; j++) {
            INSStackFormItem *sectionItem = section.items[j];
            
            if ([items containsObject:sectionItem]) {
                INSStackFormViewUpdateItem *updateItem = [[INSStackFormViewUpdateItem alloc] initWithAction:updateAction forIndexPath:[NSIndexPath indexPathForItem:j inSection:(NSInteger)i] section:section item:sectionItem];
                [updateActions addObject:updateItem];
            }
        }
    }
    
    if (!updating) {
        [self endUpdatesWithCompletion:nil];
    }
}


#pragma mark - Managing Items Helpers

- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section {
    
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
            if (section.headerItem) {
                startIndex++;
            }
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


- (__kindof UIView *)insertItem:(INSStackFormItem *)item atIndex:(NSUInteger)index toSection:(INSStackFormSection *)section {
    NSAssert([_sections containsObject:section], @"You are trying to insert item to section which don't exist");
    
    NSUInteger sectionIndex = [_sections indexOfObject:section];
    
    NSInteger startIndex = sectionIndex <= 0 ? 0 : [self startIndexForSection:section];
    if (section.headerItem) {
        startIndex++;
    }

    [section insertItem:item atIndex:index];
    
    UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [item.height doubleValue])];
    [self configureItemView:itemView forItem:item section:section];
    
    [self insertArrangedSubview:itemView atIndex:startIndex + index];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
    
    return itemView;
}


- (void)removeSection:(INSStackFormSection *)section {
    
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

- (NSArray <__kindof UIView *> *)insertSection:(INSStackFormSection *)section atIndex:(NSUInteger)index {
    
    NSMutableArray *mutableSections = [_sections mutableCopy];
    [mutableSections insertObject:section atIndex:index];
    _sections = [mutableSections copy];
    
    __block NSUInteger startIndex = [self startIndexForSection:section];
    
    NSMutableArray *insertedViews = [NSMutableArray array];
    
    [section.itemsIncludingSupplementaryItems enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *itemView = [self intitializeItemViewForItem:obj section:section];
        [self insertArrangedSubview:itemView atIndex:startIndex];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==stackView)]|" options:0 metrics:nil views:@{@"stackView": self, @"itemView": itemView}]];
        
        [insertedViews addObject:itemView];
        startIndex++;
    }];

    return [insertedViews copy];
}

- (NSArray <__kindof UIView *> *)moveSection:(INSStackFormSection *)section atIndex:(NSUInteger)index {
    NSArray *viewsForSection = [self viewsForSection:section];
    
    NSInteger indexOfSection = [_sections indexOfObject:section];
    NSMutableArray *mutableSections = [_sections mutableCopy];
    [mutableSections removeObjectAtIndex:indexOfSection];
    [mutableSections insertObject:section atIndex:index];
    _sections = [mutableSections copy];
    
    NSInteger startIndexForSection = [self startIndexForSection:section];
    if (section.headerItem) {
        startIndexForSection++;
    }
    startIndexForSection += viewsForSection.count - 1;
    
    [viewsForSection enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeArrangedSubview:obj];
        [obj removeFromSuperview];
        [self insertArrangedSubview:obj atIndex:startIndexForSection];
    }];
    
    return viewsForSection;
}

- (UIView *)moveItem:(INSStackFormItem *)item inSection:(INSStackFormSection *)inSection toSection:(INSStackFormSection *)toSection atIndex:(NSUInteger)index {
    UIView *view = [self viewForItem:item inSection:inSection];
    
    [inSection removeItem:item];
    [toSection insertItem:item atIndex:index];
    
    NSInteger startIndexForSection = [self startIndexForSection:toSection];
    if (toSection.headerItem) {
        startIndexForSection++;
    }
    NSInteger position = [toSection.items indexOfObject:item];
    
    [self insertArrangedSubview:view atIndex:startIndexForSection+position];
    
    return view;
}


#pragma mark - Private

- (NSUInteger)startIndexForSection:(INSStackFormSection *)searchingSection {
    NSUInteger index = 0;
    for (INSStackFormSection *section in _sections) {
        if (section == searchingSection) {
            return index;
        }
        index += section.itemsIncludingSupplementaryItems.count;
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
            NSInteger itemCount = object.itemsIncludingSupplementaryItems.count;
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

    [section.itemsIncludingSupplementaryItems enumerateObjectsUsingBlock:^(INSStackFormItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
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
