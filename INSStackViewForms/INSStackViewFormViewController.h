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
#import "INSStackViewFormSection.h"

@interface INSStackViewFormViewController : UIViewController
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIStackView *stackView;

@property (nonatomic, assign) BOOL showItemSeparators;
@property (nonatomic, strong, readonly) NSArray <INSStackViewFormSection *> *sections;

- (NSMutableArray <INSStackViewFormSection *> *)initialCollectionSections;
- (void)reloadData;
- (void)reloadViewsOnly;

- (NSArray <__kindof UIView *> *)viewsForSection:(INSStackViewFormSection *)section;
- (__kindof UIView *)viewForItem:(INSStackViewFormItem *)item inSection:(INSStackViewFormSection *)section;

- (void)removeItem:(INSStackViewFormItem *)item fromSection:(INSStackViewFormSection *)section animated:(BOOL)animated completion:(void(^)())completion;
- (void)removeItem:(INSStackViewFormItem *)item fromSection:(INSStackViewFormSection *)section;

- (__kindof UIView *)addItem:(INSStackViewFormItem *)item toSection:(INSStackViewFormSection *)section;
- (__kindof UIView *)insertItem:(INSStackViewFormItem *)item atIndex:(NSUInteger)index toSection:(INSStackViewFormSection *)section;

- (void)removeSection:(INSStackViewFormSection *)section animated:(BOOL)animated completion:(void(^)())completion;
- (void)removeSection:(INSStackViewFormSection *)section;

- (NSArray <__kindof UIView *> *)addSection:(INSStackViewFormSection *)section;
- (NSArray <__kindof UIView *> *)insertSection:(INSStackViewFormSection *)section atIndex:(NSUInteger)index;

@end
