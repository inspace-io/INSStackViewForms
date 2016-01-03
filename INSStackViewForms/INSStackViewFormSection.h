//
//  INSStackViewFormSection.h
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

#import "INSStackViewFormItem.h"

@interface INSStackViewFormSection : NSObject
@property (nonatomic, copy) NSNumber *headerHeight;
@property (nonatomic, copy) NSNumber *footerHeight;

@property (nonatomic, strong) INSStackViewFormItem *headerItem;
@property (nonatomic, strong) INSStackViewFormItem *footerItem;

@property (nonatomic, readonly) NSArray <INSStackViewFormItem *> *items;

- (void)addFooterWithBuilder:(void(^)(INSStackViewFormItem *builder))block;
- (void)addHeaderWithBuilder:(void(^)(INSStackViewFormItem *builder))block;
- (void)addItemWithBuilder:(void(^)(INSStackViewFormItem *builder))block;

- (void)addItem:(INSStackViewFormItem *)item;
- (void)insertItem:(INSStackViewFormItem *)item atIndex:(NSUInteger)index;
- (void)removeItem:(INSStackViewFormItem *)item;

+ (instancetype)sectionWithBuilder:(void(^)(INSStackViewFormSection *sectionBuilder))block;
@end
