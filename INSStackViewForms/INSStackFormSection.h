//
//  INSStackFormSection.h
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

#import "INSStackFormItem.h"

@interface INSStackFormSection : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSNumber *headerHeight;
@property (nonatomic, copy) NSNumber *footerHeight;

@property (nonatomic, strong) INSStackFormItem *headerItem;
@property (nonatomic, strong) INSStackFormItem *footerItem;

@property (nonatomic, assign) BOOL showItemSeparators;
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, readonly) NSArray <INSStackFormItem *> *items;

- (INSStackFormItem *)addFooterWithBuilder:(void(^)(INSStackFormItem *builder))block;
- (INSStackFormItem *)addHeaderWithBuilder:(void(^)(INSStackFormItem *builder))block;
- (INSStackFormItem *)addItemWithBuilder:(void(^)(INSStackFormItem *builder))block;

- (void)addItem:(INSStackFormItem *)item;
- (void)insertItem:(INSStackFormItem *)item atIndex:(NSUInteger)index;
- (void)removeItem:(INSStackFormItem *)item;

+ (instancetype)sectionWithBuilder:(void(^)(INSStackFormSection *sectionBuilder))block;
@end
