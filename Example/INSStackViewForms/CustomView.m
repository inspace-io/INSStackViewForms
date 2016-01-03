//
//  CustomView.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()
@property (nonatomic, assign) CGFloat customHeight;
@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _customHeight = 55;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Click to make me bigger" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button addTarget:self action:@selector(makeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = self.bounds;
        [self addSubview:button];
    }
    return self;
}

- (void)makeAction:(id)sender {
    self.customHeight += 25;
    [UIView animateWithDuration:0.3 animations:^{
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }];
}

- (CGSize)intrinsicContentSize {
    CGSize superSize = [super intrinsicContentSize];
    superSize.height = self.customHeight;
    return superSize;
}


@end
