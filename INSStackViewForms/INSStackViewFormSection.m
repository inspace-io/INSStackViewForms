//
//  INSStackViewFormSection.m
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

#import "INSStackViewFormSection.h"

@interface INSStackViewFormSection ()
@property (nonatomic, strong) NSMutableArray <INSStackViewFormItem *> *sectionItems;
@end

@implementation INSStackViewFormSection

- (NSArray <INSStackViewFormItem *> *)items {
    return [self.sectionItems copy];
}

+ (instancetype)sectionWithBuilder:(void(^)(INSStackViewFormSection *sectionBuilder))block {
    INSStackViewFormSection *section = [[INSStackViewFormSection alloc] init];
    block(section);
    return section;
}

- (instancetype)init {
    if (self = [super init]) {
        _sectionItems = [NSMutableArray array];
    }
    return self;
}

- (INSStackViewFormItem *)addFooterWithBuilder:(void(^)(INSStackViewFormItem *builder))block {
    INSStackViewFormItem *builder = [[INSStackViewFormItem alloc] init];
    block(builder);
    self.footerItem = builder;
    return builder;
}
- (INSStackViewFormItem *)addHeaderWithBuilder:(void(^)(INSStackViewFormItem *builder))block {
    INSStackViewFormItem *builder = [[INSStackViewFormItem alloc] init];
    block(builder);
    self.headerItem = builder;
    return builder;
}
- (INSStackViewFormItem *)addItemWithBuilder:(void(^)(INSStackViewFormItem *builder))block {
    INSStackViewFormItem *builder = [[INSStackViewFormItem alloc] init];
    block(builder);
    [self.sectionItems addObject:builder];
    return builder;
}

- (void)addItem:(INSStackViewFormItem *)item {
    [self.sectionItems addObject:item];
}

- (void)insertItem:(INSStackViewFormItem *)item atIndex:(NSUInteger)index {
    [self.sectionItems insertObject:item atIndex:index];
}

- (void)removeItem:(INSStackViewFormItem *)item {
    [self.sectionItems removeObject:item];
}

@end
