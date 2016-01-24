//
//  INSStackFormItem.h
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

@class INSStackFormItem;

typedef void(^INSStackFormItemBlock)(__kindof UIView * __nonnull item);
typedef BOOL(^INSStackFormItemValidationBlock)(__kindof UIView * __nullable view, INSStackFormItem * __nonnull item, NSString * __nullable * __nullable errorMessage);

@interface INSStackFormItem : NSObject
@property (nonatomic, strong, nonnull) Class itemClass;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic, strong, nullable) id value;
@property (nonatomic, assign) BOOL userInteractionEnabled;
@property (nonatomic, copy, nullable) NSNumber *height;

@property (nonatomic, copy, nullable) INSStackFormItemBlock configurationBlock;
@property (nonatomic, copy, nullable) INSStackFormItemBlock actionBlock;
@property (nonatomic, copy, nullable) INSStackFormItemBlock valueChangedBlock;
@property (nonatomic, copy, nullable) INSStackFormItemValidationBlock validationBlock;

@end
