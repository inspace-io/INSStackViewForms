//
//  ActionView.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "ActionView.h"
#import <UIView+INSNibLoading.h>

@implementation ActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self ins_loadContentsFromNib];
    }
    return self;
}

@end
