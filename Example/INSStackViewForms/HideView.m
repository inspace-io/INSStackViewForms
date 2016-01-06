//
//  HideView.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "HideView.h"
#import <UIView+INSNibLoading.h>

@implementation HideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self ins_loadContentsFromNib];
        
        self.accesoryType = INSStackViewFormViewAccessoryDisclosureIndicator;
    }
    return self;
}
- (IBAction)hideButtonTapped:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        self.hidden = YES;
    }];
}

@end
