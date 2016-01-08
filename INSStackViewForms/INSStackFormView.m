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

@interface INSStackFormView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSArray <INSStackFormSection *> *sections;
@end

@implementation INSStackFormView

+ (Class)scrollViewClass {
    return [UIScrollView class];
}
+ (Class)stackViewClass {
    return [UIStackView class];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!NSClassFromString(@"UIStackView")) {
        NSAssert([[self class] stackViewClass] != NSClassFromString(@"UIStackView"), @"Please use INSOAStackViewFormViewController if you are targeting iOS 8 or earlier.");
    }
    
    [self configureScrollView];
    [self configureStackView];
    
    [self reloadData];
}

#pragma mark - Initial Configuration

- (void)configureScrollView {
    self.scrollView = [[[[self class] scrollViewClass] alloc] initWithFrame:self.view.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
}

- (void)configureStackView {
    self.stackView = [[[[self class] stackViewClass] alloc] initWithFrame:self.scrollView.bounds];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    [self.scrollView addSubview:self.stackView];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stackView(==_scrollView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,_scrollView)]];
}

#pragma mark - Subclass

- (NSMutableArray <INSStackFormSection *> *)initialCollectionSections {
    return [@[] mutableCopy];
}

#pragma mark - Reload

- (void)reloadData {
    self.sections = [[self initialCollectionSections] copy];
    for (UIView *view in [self.stackView.arrangedSubviews copy]) {
        [self.stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    
    [self.sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
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

    [self.stackView layoutIfNeeded];
}

- (void)refreshViews {
    [self.sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
        __block NSInteger index = [self startIndexForSection:section];
        
        if (section.headerItem) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:section.headerItem section:section];
            index++;
        }
        [section.items enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:obj section:section];
            index++;
        }];
        if (section.footerItem) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:section.footerItem section:section];
        }
    }];
    
    [self.stackView layoutIfNeeded];
}

#pragma mark - Private

- (NSUInteger)startIndexForSection:(INSStackFormSection *)searchingSection {
    NSUInteger index = 0;
    for (INSStackFormSection *section in self.sections) {
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

- (INSStackFormItem *)itemWithIdentifier:(NSString *)identifier inSection:(INSStackFormSection *)section {
    for (INSStackFormItem *item in section.items) {
        if ([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    return nil;
}

- (INSStackFormSection *)sectionWithIdentifier:(NSString *)identifier {
    for (INSStackFormSection *section in self.sections) {
        if ([section.identifier isEqualToString:identifier]) {
            return section;
        }
    }
    return nil;
}

- (NSArray <__kindof UIView *> *)viewsForSection:(INSStackFormSection *)section {
    for (INSStackFormSection *object in self.sections) {
        if (object == section) {
            NSInteger startIndex = [self startIndexForSection:section];
            NSInteger itemCount = object.items.count;
            if (object.headerItem) {
                itemCount++;
            }
            if (object.footerItem) {
                itemCount++;
            }
            return [self.stackView.arrangedSubviews objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, itemCount)]];
        }
    }
    return nil;
}

- (__kindof UIView *)viewForItem:(INSStackFormItem *)item inSection:(INSStackFormSection *)section {
    for (INSStackFormSection *object in self.sections) {
        if (object == section) {
            NSInteger startIndex = [self startIndexForSection:section];
            if (object.headerItem) {
                startIndex++;
            }
            for (INSStackFormItem *itemObject in object.items) {
                if (itemObject == item) {
                    return [self.stackView.arrangedSubviews objectAtIndex:startIndex];
                }
                startIndex++;
            }
        }
    }
    return nil;
}

- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    if (animated) {
        UIView *viewForItem = [self viewForItem:item inSection:section];
        [self.stackView sendSubviewToBack:viewForItem];
        
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
    [self.sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger startIndex = [self startIndexForSection:section];
        
        if (item == section.headerItem) {
            section.headerItem = nil;
            UIView *view = self.stackView.arrangedSubviews[startIndex];
            [self.stackView removeArrangedSubview:view];
            [view removeFromSuperview];
            
            *stop = YES;
        } else if (item == section.footerItem) {
            section.footerItem = nil;
            UIView *view = self.stackView.arrangedSubviews[startIndex+section.items.count-1];
            [self.stackView removeArrangedSubview:view];
            [view removeFromSuperview];
            *stop = YES;
        } else {
            [[section.items copy] enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj == item) {
                    [section removeItem:obj];
                    UIView *view = self.stackView.arrangedSubviews[startIndex+idx];
                    [self.stackView removeArrangedSubview:view];
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
    NSUInteger sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSNotFound) {
        NSInteger startIndex = sectionIndex <= 0 ? 0 : [self startIndexForSection:section];
        [section insertItem:item atIndex:index];
        
        UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.stackView.frame.size.width, [item.height doubleValue])];
        [self configureItemView:itemView forItem:item section:section];
        
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex + index];
        [self.stackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_stackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,itemView)]];
        
        return itemView;
    }
    return nil;
}


- (void)removeSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    if (animated) {
        NSArray <UIView *> *subviews = [self viewsForSection:section];
        [[subviews.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stackView sendSubviewToBack:obj];
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
    NSMutableArray *mutableSections = [self.sections mutableCopy];
    [self.sections enumerateObjectsUsingBlock:^(INSStackFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == section) {
            NSArray *subviews = [self viewsForSection:section];
            for (UIView *view in subviews) {
                [self.stackView removeArrangedSubview:view];
                [view removeFromSuperview];
            }
            
            [mutableSections removeObject:section];
            *stop = YES;
        }
    }];
    self.sections = [mutableSections copy];
}
- (NSArray <__kindof UIView *> *)addSection:(INSStackFormSection *)section {
    return [self insertSection:section atIndex:self.sections.count];
}
- (NSArray <__kindof UIView *> *)insertSection:(INSStackFormSection *)section atIndex:(NSUInteger)index {
    NSMutableArray *mutableSections = [self.sections mutableCopy];
    [mutableSections insertObject:section atIndex:index];
    self.sections = [mutableSections copy];
    
    __block NSUInteger startIndex = [self startIndexForSection:section];
    
    NSMutableArray *insertedViews = [NSMutableArray array];
    
    if (section.headerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.headerItem section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [self.stackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_stackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,itemView)]];
        
        [insertedViews addObject:itemView];
        startIndex++;
    }
    [section.items enumerateObjectsUsingBlock:^(INSStackFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *itemView = [self intitializeItemViewForItem:obj section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [self.stackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_stackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,itemView)]];
        
        [insertedViews addObject:itemView];
        startIndex++;
    }];
    if (section.footerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.footerItem section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [self.stackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_stackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,itemView)]];
        
        [insertedViews addObject:itemView];
    }
    return [insertedViews copy];
}

#pragma mark - Private item initialization and configuration

- (void)intitializeAndAddItemViewForItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    UIView *itemView = [self intitializeItemViewForItem:item section:section];
    [self.stackView addArrangedSubview:itemView];
    
    [self.stackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView(==_stackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView,itemView)]];
}

- (UIView *)intitializeItemViewForItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.stackView.frame.size.width, [item.height doubleValue])];
    [self configureItemView:itemView forItem:item section:section];
    return itemView;
}

- (void)configureItemView:(UIView *)itemView forItem:(INSStackFormItem *)item section:(INSStackFormSection *)section {
    
    if (item.height) {
        [itemView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[itemView(height)]" options:0 metrics:@{@"height":item.height} views:NSDictionaryOfVariableBindings(itemView)]];
    }
    
    if ([itemView isKindOfClass:[INSStackFormViewBaseElement class]]) {
        INSStackFormViewBaseElement *formView = (INSStackFormViewBaseElement *)itemView;
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
    NSMutableArray *errors = [NSMutableArray array];
    __block BOOL isValid = YES;
    
    [self.sections enumerateObjectsUsingBlock:^(INSStackFormSection *section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section.items enumerateObjectsUsingBlock:^(INSStackFormItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
    }];
    
    *errorMessages = [errors copy];
    return isValid;
}
@end
