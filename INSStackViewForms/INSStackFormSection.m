//
//  INSStackFormSection.m
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

#import "INSStackFormSection.h"

@interface INSStackFormSection ()
@property (nonatomic, strong) NSMutableArray <INSStackFormItem *> *sectionItems;
@end

@implementation INSStackFormSection

- (NSArray <INSStackFormItem *> *)items {
    return [self.sectionItems copy];
}

- (NSArray <INSStackFormItem *> *)itemsIncludingSupplementaryItems {
    NSMutableArray *array = [self.sectionItems mutableCopy];
    if (self.headerItem) {
        [array insertObject:self.headerItem atIndex:0];
    }
    if (self.footerItem) {
        [array addObject:self.footerItem];
    }
    return [array copy];
}


+ (instancetype)sectionWithBuilder:(void(^)(INSStackFormSection *sectionBuilder))block {
    INSStackFormSection *section = [[INSStackFormSection alloc] init];
    block(section);
    return section;
}

- (instancetype)init {
    if (self = [super init]) {
        _sectionItems = [NSMutableArray array];
    }
    return self;
}

- (INSStackFormItem *)addFooterWithBuilder:(void(^)(INSStackFormItem *builder))block {
    INSStackFormItem *builder = [[INSStackFormItem alloc] init];
    block(builder);
    self.footerItem = builder;
    return builder;
}
- (INSStackFormItem *)addHeaderWithBuilder:(void(^)(INSStackFormItem *builder))block {
    INSStackFormItem *builder = [[INSStackFormItem alloc] init];
    block(builder);
    self.headerItem = builder;
    return builder;
}
- (INSStackFormItem *)addItemWithBuilder:(void(^)(INSStackFormItem *builder))block {
    INSStackFormItem *builder = [[INSStackFormItem alloc] init];
    block(builder);
    [self.sectionItems addObject:builder];
    return builder;
}

- (void)addItem:(INSStackFormItem *)item {
    [self.sectionItems addObject:item];
}

- (void)insertItem:(INSStackFormItem *)item atIndex:(NSUInteger)index {
    [self.sectionItems insertObject:item atIndex:index];
}

- (void)removeItem:(INSStackFormItem *)item {
    [self.sectionItems removeObject:item];
}

- (void)removeItemAtIndex:(NSInteger)index {
    [self.sectionItems removeObjectAtIndex:index];
}

@end
