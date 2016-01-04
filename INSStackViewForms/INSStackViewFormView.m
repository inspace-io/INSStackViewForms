//
//  INSStackViewFormView.m
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

#import "INSStackViewFormView.h"
#import "INSStackViewFormView_Private.h"

@interface INSStackViewFormView ()
@property (nonatomic, strong) UIView *topDelimiter;
@property (nonatomic, strong) UIView *bottomDelimiter;
@property (nonatomic, strong) UIView *leftDelimiter;
@property (nonatomic, strong) UIView *rightDelimiter;
@end

@implementation INSStackViewFormView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultValues];
    }
    return self;
}

- (UIColor *)delimiterColor {
    if (!_delimiterColor) {
        _delimiterColor = [UIColor lightGrayColor];
    }
    return _delimiterColor;
}

- (UIColor *)leftDelimiterColor {
    if (!_leftDelimiterColor) {
        _leftDelimiterColor = self.delimiterColor;
    }
    return _leftDelimiterColor;
}

- (UIColor *)rightDelimiterColor {
    if (!_rightDelimiterColor) {
        _rightDelimiterColor = self.delimiterColor;
    }
    return _rightDelimiterColor;
}


- (UIColor *)topDelimiterColor {
    if (!_topDelimiterColor) {
        _topDelimiterColor = self.delimiterColor;
    }
    return _topDelimiterColor;
}

- (UIColor *)bottomDelimiterColor {
    if (!_bottomDelimiterColor) {
        _bottomDelimiterColor = self.delimiterColor;
    }
    return _bottomDelimiterColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateDelimitersFrame];
}

- (void)updateDelimitersFrame {
    self.topDelimiter.frame = (CGRect){.size = CGSizeMake(self.bounds.size.width, _delimiterLineHeight)};
    self.bottomDelimiter.frame = (CGRect){ .origin = CGPointMake(0, self.bounds.size.height-_delimiterLineHeight), .size = CGSizeMake(self.bounds.size.width, _delimiterLineHeight)};
    self.rightDelimiter.frame = (CGRect){ .origin = CGPointMake(self.bounds.size.width-_delimiterLineHeight, 0), .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)};
    self.leftDelimiter.frame = (CGRect){  .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)};
    
    [self bringSubviewToFront:_topDelimiter];
    [self bringSubviewToFront:_bottomDelimiter];
    [self bringSubviewToFront:_leftDelimiter];
    [self bringSubviewToFront:_rightDelimiter];
}

- (void)setupDefaultValues {
    _delimiterLineHeight = 0.5;
    
    _topDelimiter = [[UIView alloc] initWithFrame:(CGRect){.size = CGSizeMake(self.bounds.size.width, _delimiterLineHeight)}];
    _topDelimiter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _topDelimiter.translatesAutoresizingMaskIntoConstraints = YES;
    _topDelimiter.backgroundColor = self.topDelimiterColor;
    
    [self addSubview:_topDelimiter];
    [self bringSubviewToFront:_topDelimiter];
    
    _bottomDelimiter = [[UIView alloc] initWithFrame:(CGRect){ .origin = CGPointMake(0, self.bounds.size.height-_delimiterLineHeight), .size = CGSizeMake(self.bounds.size.width, _delimiterLineHeight)}];
    _bottomDelimiter.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _bottomDelimiter.translatesAutoresizingMaskIntoConstraints = YES;
    _bottomDelimiter.backgroundColor = self.bottomDelimiterColor;
    
    [self addSubview:_bottomDelimiter];
    [self bringSubviewToFront:_bottomDelimiter];
    
    _leftDelimiter = [[UIView alloc] initWithFrame:(CGRect){  .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)}];
    _leftDelimiter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    _leftDelimiter.translatesAutoresizingMaskIntoConstraints = YES;
    _leftDelimiter.backgroundColor = self.leftDelimiterColor;
    
    [self addSubview:_leftDelimiter];
    [self bringSubviewToFront:_leftDelimiter];
    
    _rightDelimiter = [[UIView alloc] initWithFrame:(CGRect){ .origin = CGPointMake(self.bounds.size.width-_delimiterLineHeight, 0), .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)}];
    _rightDelimiter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    _rightDelimiter.translatesAutoresizingMaskIntoConstraints = YES;
    _rightDelimiter.backgroundColor = self.rightDelimiterColor;
    
    [self addSubview:_rightDelimiter];
    [self bringSubviewToFront:_rightDelimiter];
    
    self.leftDelimiter.hidden = self.rightDelimiter.hidden = self.topDelimiter.hidden = self.bottomDelimiter.hidden = YES;
}

- (void)setShowTopDelimiter:(BOOL)showDelimiter {
    _showTopDelimiter = showDelimiter;
    self.topDelimiter.hidden = !showDelimiter;
}
- (void)setShowBottomDelimiter:(BOOL)showDelimiter {
    _showBottomDelimiter = showDelimiter;
    self.bottomDelimiter.hidden = !showDelimiter;
}

- (void)setShowLeftDelimiter:(BOOL)showDelimiter {
    _showLeftDelimiter = showDelimiter;
    self.leftDelimiter.hidden = !showDelimiter;
}
- (void)setShowRightDelimiter:(BOOL)showDelimiter {
    _showRightDelimiter = showDelimiter;
    self.rightDelimiter.hidden = !showDelimiter;
}

- (void)hideAllDelimiters {
    self.showTopDelimiter = NO;
    self.showLeftDelimiter = NO;
    self.showBottomDelimiter = NO;
    self.showRightDelimiter = NO;
}


- (void)configure {
    self.clipsToBounds = YES;
    
    if (self.item.userInteractionEnabled) {
        [self removeTarget:self action:@selector(userDidSelectView:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(userDidSelectView:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)userDidSelectView:(INSStackViewFormView *)sender {
    if (self.item.actionBlock) {
        self.item.actionBlock(self);
    }
}

@end
