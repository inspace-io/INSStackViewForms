//
//  INSStackFormViewTextFieldElement.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 08.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewTextFieldElement.h"

@interface INSStackFormViewTextFieldElement () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *additionalConstraints;
@end

@implementation INSStackFormViewTextFieldElement

- (void)dealloc {
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

- (void)setAccessoryView:(UIView *)accessoryView {
    [super setAccessoryView:accessoryView];
    [self.contentView setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.textField.textColor = [UIColor blackColor];
        self.textField.delegate = self;
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)configure {
    [super configure];
    
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.textLabel.text = self.item.title;
    self.textField.text = self.item.subtitle;
    self.textField.delegate = self;
}


#pragma mark - LayoutConstraints

- (NSArray *)layoutConstraints {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    
    // Add Constraints
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textField]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textLabel]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.textField
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.contentView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.f constant:0.f]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.contentView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.f constant:0.f]];
    
    return result;
}

- (void)updateConstraints {
    if (self.additionalConstraints){
        [self.contentView removeConstraints:self.additionalConstraints];
    }
    NSDictionary *views = @{@"label": self.textLabel, @"textField": self.textField};
    NSDictionary *metrics = @{@"width": self.accessoryView ? @0 : @8};
    
    if (self.textLabel.text.length > 0) {
        self.additionalConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textField]-width-|" options:0 metrics:metrics views:views]];
    } else {
        self.additionalConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-width-|" options:0 metrics:metrics views:views]];
    }
    
    [self.additionalConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                           constant:0.0]];
    
    [self.contentView addConstraints:self.additionalConstraints];
    [super updateConstraints];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

#pragma mark - Helper

- (void)textFieldDidChange:(UITextField *)textField{
    if([self.textField.text length] > 0) {
        self.item.value = self.textField.text;
    } else {
        self.item.value = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
