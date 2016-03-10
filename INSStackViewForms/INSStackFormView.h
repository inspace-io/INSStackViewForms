//
//  INSStackViewFormViewController.h
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


@import UIKit;
#import "INSStackFormSection.h"

@class INSStackFormView;

@protocol INSStackViewFormViewDateSource <NSObject>
- (nullable NSArray <INSStackFormSection *> *)sectionsForStackFormView:(nonnull INSStackFormView *)stackViewFormView;
@end

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0 && __has_include("OAStackView.h") || __has_include(<OAStackView/OAStackView.h>)

#if __has_include(<OAStackView/OAStackView.h>)
    #import <OAStackView/OAStackView.h>
#else
    #import "OAStackView.h"
#endif

@interface INSStackFormView : OAStackView
#else
@interface INSStackFormView : UIStackView
#endif

@property (nonatomic, strong, readonly, nonnull) NSArray <INSStackFormSection *> *sections;

@property (nonatomic, weak) id <INSStackViewFormViewDateSource> dataSource;

/**
 *  Reloads the rows and sections of the stack form view.
 */
- (void)reloadData;

/**
 *  Begins a group of updates for the stack view.
 */
- (void)beginUpdates;
- (void)beginUpdatesWithAnimation:(BOOL)animations;
/**
 *  Ends the group of updates the stack view.
 */
- (void)endUpdates;
- (void)endUpdatesWithCompletion:(nullable void(^)(BOOL finished))completion;

- (void)performBatchUpdates:(nonnull void (^)(void))updates completion:(nullable void (^)(BOOL finished))completion;

- (void)addSections:(nonnull NSArray <INSStackFormSection *> *)sections;
- (void)insertSections:(nonnull NSArray <INSStackFormSection *> *)sections atIndex:(NSInteger)index;
- (void)deleteSections:(nonnull NSArray <INSStackFormSection *> *)sections;
- (void)reloadSections:(nonnull NSArray <INSStackFormSection *> *)sections;
- (void)refreshSections:(nonnull NSArray <INSStackFormSection *> *)sections;
- (void)moveSection:(nonnull INSStackFormSection *)section toIndex:(NSInteger)newSectionIndex;

- (void)addItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)section atIndex:(NSUInteger)index;
- (void)insertItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)section atIndex:(NSUInteger)index;
- (void)deleteItems:(nonnull NSArray <INSStackFormItem *> *)items;
- (void)reloadItems:(nonnull NSArray <INSStackFormItem *> *)items;
- (void)refreshItems:(nonnull NSArray <INSStackFormItem *> *)items;
- (void)moveItems:(nonnull NSArray <INSStackFormItem *> *)items toSection:(nonnull INSStackFormSection *)section atIndex:(NSUInteger)index;

/**
 *  Returns item and section for specified identifier.
 */
- (nullable INSStackFormItem *)firstItemWithIdentifier:(nonnull NSString *)identifier;
- (nullable INSStackFormItem *)itemWithIdentifier:(nonnull NSString *)identifier inSection:(nonnull INSStackFormSection *)section;
- (nullable INSStackFormSection *)sectionWithIdentifier:(nonnull NSString *)identifier;

/**
 *  Returns equivalent views for specified section or item.
 */
- (nullable NSArray <__kindof UIView *> *)viewsForSection:(nonnull INSStackFormSection *)section;
- (nullable __kindof UIView *)viewForItem:(nonnull INSStackFormItem *)item inSection:(nonnull INSStackFormSection *)section;

/**
 *  Call validationBlock on each items for each sections
 */
- (BOOL)validateDataItems:(NSArray <NSString *> * __nullable __autoreleasing * __nullable)errorMessages;
- (BOOL)validateSection:(nonnull INSStackFormSection *)section errorMessages:(NSArray <NSString *> * __nullable __autoreleasing * __nullable)errorMessages;

@end
