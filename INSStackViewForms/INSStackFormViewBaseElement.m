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

#import "INSStackFormViewBaseElement.h"
#import "INSStackFormViewBaseElement_Private.h"

@interface INSStackViewFormTransparentView : UIView
@end

@implementation INSStackViewFormTransparentView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (view.isUserInteractionEnabled && CGRectContainsPoint(view.frame, point)) {
            return YES;
        }
    }
    return NO;
}

@end

@interface INSStackFormViewBaseElement ()
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *accessoryContentView;
@property (nonatomic, strong) NSLayoutConstraint *accessoryContentViewWidthConstraint;

@property (nonatomic, strong) UIView *topDelimiter;
@property (nonatomic, strong) UIView *bottomDelimiter;
@property (nonatomic, strong) UIView *leftDelimiter;
@property (nonatomic, strong) UIView *rightDelimiter;

@end

@implementation INSStackFormViewBaseElement

+ (NSBundle *)resourcesBundle {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"INSStackViewForms" ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

#pragma mark - INSNibLoading
// Specify which view will be for container when using INSNibLoading
- (UIView *)ins_contentViewForNib {
    return self.contentView;
}

#pragma mark -

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setHighlighted:highlighted animated:YES];
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    if (_selectedBackgroundView != selectedBackgroundView) {
        [_selectedBackgroundView removeFromSuperview];
        _selectedBackgroundView = selectedBackgroundView;
        
        if (_selectedBackgroundView) {
            _selectedBackgroundView.alpha = 0.0;
            _selectedBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_selectedBackgroundView];
            [self sendSubviewToBack:_selectedBackgroundView];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_selectedBackgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_selectedBackgroundView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_selectedBackgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_selectedBackgroundView)]];
        }
    }
}

- (void)setAccesoryType:(INSStackFormViewBaseElementAccessoryType)accesoryType {
    _accesoryType = accesoryType;
    if (_accesoryType == INSStackFormViewBaseElementAccessoryDisclosureIndicator) {
        UIImageView *disclousureIndicator = [[UIImageView alloc] initWithFrame:(CGRect){.size = CGSizeMake(8, 14)}];
        disclousureIndicator.image = [UIImage imageNamed:@"forwardarrow" inBundle:[[self class] resourcesBundle] compatibleWithTraitCollection:nil];
        self.accessoryView = disclousureIndicator;
        if (!self.selectedBackgroundView) {
            self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        }
    } else {
        self.accessoryView = nil;
    }
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if (_accessoryView != accessoryView) {
        [_accessoryView removeFromSuperview];
        _accessoryView = accessoryView;
        self.accessoryContentViewWidthConstraint.constant = _accessoryView ? 40 : 0;
        if (_accessoryView) {
            [self.accessoryContentView addSubview:_accessoryView];
            _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.accessoryContentView addConstraint:[NSLayoutConstraint constraintWithItem:_accessoryView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.accessoryContentView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.f constant:0.f]];
            
            [self.accessoryContentView addConstraint:[NSLayoutConstraint constraintWithItem:_accessoryView
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.accessoryContentView
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.f constant:0.f]];
            
            [_accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_accessoryView(height)]" options:0 metrics:@{@"height":@(_accessoryView.frame.size.height)} views:NSDictionaryOfVariableBindings(_accessoryView)]];
            [_accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_accessoryView(width)]" options:0 metrics:@{@"width":@(_accessoryView.frame.size.width)} views:NSDictionaryOfVariableBindings(_accessoryView)]];
        }
    }
}

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
    self.topDelimiter.frame = (CGRect){.origin = CGPointMake(self.topDelimiterInset.left, 0), .size = CGSizeMake(self.bounds.size.width - self.topDelimiterInset.left - self.topDelimiterInset.right, _delimiterLineHeight)};
    self.bottomDelimiter.frame = (CGRect){.origin = CGPointMake(self.bottomDelimiterInset.left, self.bounds.size.height-_delimiterLineHeight), .size = CGSizeMake(self.bounds.size.width - self.bottomDelimiterInset.left - self.bottomDelimiterInset.right, _delimiterLineHeight)};
    self.rightDelimiter.frame = (CGRect){ .origin = CGPointMake(self.bounds.size.width-_delimiterLineHeight, 0), .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)};
    self.leftDelimiter.frame = (CGRect){  .size = CGSizeMake(_delimiterLineHeight, self.bounds.size.height)};
    
    [self bringSubviewToFront:_topDelimiter];
    [self bringSubviewToFront:_bottomDelimiter];
    [self bringSubviewToFront:_leftDelimiter];
    [self bringSubviewToFront:_rightDelimiter];
}

- (void)setupDefaultValues {
    _delimiterLineHeight = 0.5;
    
    _contentView = [[INSStackViewFormTransparentView alloc] initWithFrame:CGRectZero];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    
    _accessoryContentView = [[INSStackViewFormTransparentView alloc] initWithFrame:CGRectZero];
    _accessoryContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_accessoryContentView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]-0-[_accessoryContentView]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_contentView, _accessoryContentView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                            options:0
                                            metrics:nil
                                              views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_accessoryContentView]|"
                                            options:0
                                            metrics:nil
                                              views:NSDictionaryOfVariableBindings(_accessoryContentView)]];
    
    
    self.accessoryContentViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_accessoryContentView(0)]"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_accessoryContentView)] firstObject];
    [self.accessoryContentView addConstraint:self.accessoryContentViewWidthConstraint];
    
    _topDelimiter = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointMake(self.topDelimiterInset.left, 0), .size = CGSizeMake(self.bounds.size.width - self.topDelimiterInset.left - self.topDelimiterInset.right, _delimiterLineHeight)}];
    _topDelimiter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _topDelimiter.translatesAutoresizingMaskIntoConstraints = YES;
    _topDelimiter.backgroundColor = self.topDelimiterColor;
    
    [self addSubview:_topDelimiter];
    [self bringSubviewToFront:_topDelimiter];
    
    _bottomDelimiter = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointMake(self.bottomDelimiterInset.left, self.bounds.size.height-_delimiterLineHeight), .size = CGSizeMake(self.bounds.size.width - self.bottomDelimiterInset.left - self.bottomDelimiterInset.right, _delimiterLineHeight)}];
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
        
        [self addTarget:self action:@selector(controlTouchDownInside:) forControlEvents:UIControlEventTouchDown];
    }
    
    if (self.item.actionBlock) {
        self.accesoryType = INSStackFormViewBaseElementAccessoryDisclosureIndicator;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected];
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (selected || self.highlighted) {
                self.selectedBackgroundView.alpha = 1.0;
            } else {
                self.selectedBackgroundView.alpha = 0.0;
            }
        } completion:nil];
    } else {
        if (selected || self.highlighted) {
            self.selectedBackgroundView.alpha = 1.0;
        } else {
            self.selectedBackgroundView.alpha = 0.0;
        }
    }
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted];
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (highlighted || self.selected) {
                self.selectedBackgroundView.alpha = 1.0;
            } else {
                self.selectedBackgroundView.alpha = 0.0;
            }
        } completion:nil];
    } else {
        if (highlighted || self.selected) {
            self.selectedBackgroundView.alpha = 1.0;
        } else {
            self.selectedBackgroundView.alpha = 0.0;
        }
    }
}

- (void)userDidSelectView:(INSStackFormViewBaseElement *)sender {
    [self setHighlighted:NO animated:YES];
    
    if (self.item.actionBlock) {
        self.item.actionBlock(self);
    }
}

- (void)controlTouchDownInside:(INSStackFormViewBaseElement *)sender {
    [self setHighlighted:YES animated:YES];
}

@end
