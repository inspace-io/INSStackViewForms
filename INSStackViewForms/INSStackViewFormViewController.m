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

#import "INSStackViewFormViewController.h"
#import "INSStackViewFormView_Private.h"

@interface INSStackViewFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSArray <INSStackViewFormSection *> *sections;
@end

@implementation INSStackViewFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureScrollView];
    [self configureStackView];
    
    [self reloadData];
}

- (void)configureScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)configureStackView {
    self.stackView = [[UIStackView alloc] initWithFrame:self.scrollView.bounds];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    [self.scrollView addSubview:self.stackView];
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
    [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
}

- (NSMutableArray <INSStackViewFormSection *> *)initialCollectionSections {
    return [@[] mutableCopy];
}

- (void)reloadData {
    self.sections = [[self initialCollectionSections] copy];
    for (UIView *view in [self.stackView.arrangedSubviews copy]) {
        [self.stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    
    [self.sections enumerateObjectsUsingBlock:^(INSStackViewFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        if (section.headerItem) {
            [self intitializeAndAddItemViewForItem:section.headerItem section:section];
        }
        [section.items enumerateObjectsUsingBlock:^(INSStackViewFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self intitializeAndAddItemViewForItem:obj section:section];
        }];
        if (section.footerItem) {
            [self intitializeAndAddItemViewForItem:section.footerItem section:section];
        }
    }];

    [self.stackView layoutIfNeeded];
}

- (void)refreshViews {
    [self.sections enumerateObjectsUsingBlock:^(INSStackViewFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
        __block NSInteger index = [self startIndexForSection:section];
        
        if (section.headerItem) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:section.headerItem section:section];
            index++;
        }
        [section.items enumerateObjectsUsingBlock:^(INSStackViewFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:obj section:section];
            index++;
        }];
        if (section.footerItem) {
            [self configureItemView:self.stackView.arrangedSubviews[index] forItem:section.footerItem section:section];
        }
    }];
    
    [self.stackView layoutIfNeeded];
}

- (INSStackViewFormItem *)itemWithIdentifier:(NSString *)identifier inSection:(INSStackViewFormSection *)section {
    for (INSStackViewFormItem *item in section.items) {
        if ([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    return nil;
}

- (INSStackViewFormSection *)sectionWithIdentifier:(NSString *)identifier {
    for (INSStackViewFormSection *section in self.sections) {
        if ([section.identifier isEqualToString:identifier]) {
            return section;
        }
    }
    return nil;
}

- (NSUInteger)startIndexForSection:(INSStackViewFormSection *)searchingSection {
    NSUInteger index = 0;
    for (INSStackViewFormSection *section in self.sections) {
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

- (void)removeItem:(INSStackViewFormItem *)item fromSection:(INSStackViewFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    if (animated) {
        UIView *viewForItem = [self viewForItem:item inSection:section];
        [self.stackView sendSubviewToBack:viewForItem];
        
        [UIView animateWithDuration:0.25 animations:^{
            viewForItem.hidden = YES;
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

- (void)removeItem:(INSStackViewFormItem *)item fromSection:(INSStackViewFormSection *)section {
    [self.sections enumerateObjectsUsingBlock:^(INSStackViewFormSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
            [[section.items copy] enumerateObjectsUsingBlock:^(INSStackViewFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (__kindof UIView *)insertItem:(INSStackViewFormItem *)item atIndex:(NSUInteger)index toSection:(INSStackViewFormSection *)section {
    NSUInteger sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSNotFound) {
        NSInteger startIndex = sectionIndex <= 0 ? 0 : [self startIndexForSection:section];
        [section insertItem:item atIndex:index];
        
        UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.stackView.frame.size.width, [item.height doubleValue])];
        [self configureItemView:itemView forItem:item section:section];
        
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex + index];
        [itemView.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
        
        return itemView;
    }
    return nil;
}
- (__kindof UIView *)addItem:(INSStackViewFormItem *)item toSection:(INSStackViewFormSection *)section {
    return [self insertItem:item atIndex:section.items.count toSection:section];
}

- (NSArray <__kindof UIView *> *)viewsForSection:(INSStackViewFormSection *)section {
    for (INSStackViewFormSection *object in self.sections) {
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

- (__kindof UIView *)viewForItem:(INSStackViewFormItem *)item inSection:(INSStackViewFormSection *)section {
    for (INSStackViewFormSection *object in self.sections) {
        if (object == section) {
            NSInteger startIndex = [self startIndexForSection:section];
            if (object.headerItem) {
                startIndex++;
            }
            for (INSStackViewFormItem *itemObject in object.items) {
                if (itemObject == item) {
                    return [self.stackView.arrangedSubviews objectAtIndex:startIndex];
                }
                startIndex++;
            }
        }
    }
    return nil;
}

- (void)removeSection:(INSStackViewFormSection *)section animated:(BOOL)animated completion:(void(^)())completion {
    if (animated) {
        NSArray <UIView *> *subviews = [self viewsForSection:section];
        [[subviews.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stackView sendSubviewToBack:obj];
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in subviews) {
                view.hidden = YES;
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

- (void)removeSection:(INSStackViewFormSection *)section {
    NSMutableArray *mutableSections = [self.sections mutableCopy];
    [self.sections enumerateObjectsUsingBlock:^(INSStackViewFormSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
- (NSArray <__kindof UIView *> *)addSection:(INSStackViewFormSection *)section {
    return [self insertSection:section atIndex:self.sections.count];
}
- (NSArray <__kindof UIView *> *)insertSection:(INSStackViewFormSection *)section atIndex:(NSUInteger)index {
    NSMutableArray *mutableSections = [self.sections mutableCopy];
    [mutableSections insertObject:section atIndex:index];
    self.sections = [mutableSections copy];
    
    __block NSUInteger startIndex = [self startIndexForSection:section];
    
    NSMutableArray *insertedViews = [NSMutableArray array];
    
    if (section.headerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.headerItem section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [itemView.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
        [insertedViews addObject:itemView];
        startIndex++;
    }
    [section.items enumerateObjectsUsingBlock:^(INSStackViewFormItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *itemView = [self intitializeItemViewForItem:obj section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [itemView.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
        [insertedViews addObject:itemView];
        startIndex++;
    }];
    if (section.footerItem) {
        UIView *itemView = [self intitializeItemViewForItem:section.footerItem section:section];
        [self.stackView insertArrangedSubview:itemView atIndex:startIndex];
        [itemView.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
        [insertedViews addObject:itemView];
    }
    return [insertedViews copy];
}

- (void)intitializeAndAddItemViewForItem:(INSStackViewFormItem *)item section:(INSStackViewFormSection *)section {
    UIView *itemView = [self intitializeItemViewForItem:item section:section];
    [self.stackView addArrangedSubview:itemView];
    [itemView.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
}

- (UIView *)intitializeItemViewForItem:(INSStackViewFormItem *)item section:(INSStackViewFormSection *)section {
    UIView *itemView = [[item.itemClass alloc] initWithFrame:CGRectMake(0, 0, self.stackView.frame.size.width, [item.height doubleValue])];
    [self configureItemView:itemView forItem:item section:section];
    return itemView;
}

- (void)configureItemView:(UIView *)itemView forItem:(INSStackViewFormItem *)item section:(INSStackViewFormSection *)section {
    
    if (item.height) {
        [itemView.heightAnchor constraintEqualToConstant:[item.height doubleValue]].active = YES;
    }
    
    if ([itemView isKindOfClass:[INSStackViewFormView class]]) {
        INSStackViewFormView *formView = (INSStackViewFormView *)itemView;
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

- (BOOL)validateDataItems:(NSArray <NSString *> * __autoreleasing *)errorMessages {
    NSMutableArray *errors = [NSMutableArray array];
    __block BOOL isValid = YES;
    
    [self.sections enumerateObjectsUsingBlock:^(INSStackViewFormSection *section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section.items enumerateObjectsUsingBlock:^(INSStackViewFormItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
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
