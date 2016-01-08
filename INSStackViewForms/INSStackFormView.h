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
- (NSArray <INSStackFormSection *> *)sectionsForStackFormView:(INSStackFormView *)stackViewFormView;
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

@property (nonatomic, strong, readonly) NSArray <INSStackFormSection *> *sections;

@property (nonatomic, weak) id <INSStackViewFormViewDateSource> dataSource;

- (void)reloadData;
- (void)refreshViews;

- (INSStackFormItem *)itemWithIdentifier:(NSString *)identifier inSection:(INSStackFormSection *)section;
- (INSStackFormSection *)sectionWithIdentifier:(NSString *)identifier;

- (NSArray <__kindof UIView *> *)viewsForSection:(INSStackFormSection *)section;
- (__kindof UIView *)viewForItem:(INSStackFormItem *)item inSection:(INSStackFormSection *)section;

- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion;
- (void)removeItem:(INSStackFormItem *)item fromSection:(INSStackFormSection *)section;

- (__kindof UIView *)addItem:(INSStackFormItem *)item toSection:(INSStackFormSection *)section;
- (__kindof UIView *)insertItem:(INSStackFormItem *)item atIndex:(NSUInteger)index toSection:(INSStackFormSection *)section;

- (void)removeSection:(INSStackFormSection *)section animated:(BOOL)animated completion:(void(^)())completion;
- (void)removeSection:(INSStackFormSection *)section;

- (NSArray <__kindof UIView *> *)addSection:(INSStackFormSection *)section;
- (NSArray <__kindof UIView *> *)insertSection:(INSStackFormSection *)section atIndex:(NSUInteger)index;

- (BOOL)validateDataItems:(NSArray <NSString *> * __autoreleasing *)errorMessages;

@end
