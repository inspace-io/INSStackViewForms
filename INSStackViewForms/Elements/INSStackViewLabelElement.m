//
//  INSStackViewLabelElement.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 06.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackViewLabelElement.h"

@interface INSStackViewLabelElement ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) NSLayoutConstraint *detailTextLabelTrailingConstraint;
@end

@implementation INSStackViewLabelElement

- (void)setAccessoryView:(UIView *)accessoryView {
    [super setAccessoryView:accessoryView];
    if (accessoryView) {
        self.detailTextLabelTrailingConstraint.constant = 0;
    } else {
        self.detailTextLabelTrailingConstraint.constant = 12;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.textLabel];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1.f constant:0.f]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textLabel]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_textLabel)]];
        
        self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.detailTextLabel];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.f constant:0.f]];
        
        self.detailTextLabelTrailingConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_detailTextLabel]-12-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_detailTextLabel)] firstObject];
        
        [self.contentView addConstraint:self.detailTextLabelTrailingConstraint];
    }
    return self;
}

- (void)configure {
    [super configure];
    self.textLabel.text = self.item.title;
    self.detailTextLabel.text = self.item.subtitle;
}
@end
