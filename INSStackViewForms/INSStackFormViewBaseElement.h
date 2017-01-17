//
//  INSStackViewFormView.h
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

@class INSStackFormView;

#import "INSStackFormSection.h"
#import "INSStackFormItem.h"

typedef NS_ENUM(NSInteger, INSStackFormViewBaseElementAccessoryType) {
    INSStackFormViewBaseElementAccessoryNone,    // clear accessory view
    INSStackFormViewBaseElementAccessoryDisclosureIndicator
};

@interface INSStackFormViewBaseElement : UIControl
@property (nonatomic, weak, readonly, nullable) INSStackFormView *stackFormView;
@property (nonatomic, weak, readonly, nullable) INSStackFormSection *section;
@property (nonatomic, weak, readonly, nullable) INSStackFormItem *item;

@property (nonatomic, readonly, strong, nonnull) UIView *contentView;
@property (nonatomic, strong, nullable) UIView *accessoryView;
@property (nonatomic, assign) INSStackFormViewBaseElementAccessoryType accesoryType;

@property (nonatomic, strong, nullable) UIView *selectedBackgroundView;

@property (nonatomic, assign) IBInspectable CGFloat delimiterLineHeight;

@property (nonatomic, strong, null_resettable) IBInspectable UIColor *delimiterColor;

@property (nonatomic, strong, null_resettable) IBInspectable UIColor *topDelimiterColor;
@property (nonatomic, strong, null_resettable) IBInspectable UIColor *bottomDelimiterColor;
@property (nonatomic, strong, null_resettable) IBInspectable UIColor *leftDelimiterColor;
@property (nonatomic, strong, null_resettable) IBInspectable UIColor *rightDelimiterColor;

@property (nonatomic, assign) UIEdgeInsets topDelimiterInset;
@property (nonatomic, assign) UIEdgeInsets bottomDelimiterInset;

@property (nonatomic, assign) IBInspectable BOOL showTopDelimiter;
@property (nonatomic, assign) IBInspectable BOOL showBottomDelimiter;
@property (nonatomic, assign) IBInspectable BOOL showLeftDelimiter;
@property (nonatomic, assign) IBInspectable BOOL showRightDelimiter;

- (void)hideAllDelimiters;
- (void)configure;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
@end
