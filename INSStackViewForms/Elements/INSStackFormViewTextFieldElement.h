//
//  INSStackFormViewTextFieldElement.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 08.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewBaseElement.h"

@interface INSStackFormViewTextFieldElement : INSStackFormViewBaseElement
@property (nonatomic, strong, readonly, nonnull) UILabel *textLabel;
@property (nonatomic, strong, readonly, nonnull) UITextField *textField;

@property (nonatomic, strong, nullable) NSNumber *textFieldLengthPercentage;
@end
