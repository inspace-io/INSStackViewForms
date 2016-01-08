//
//  INSStackViewTextFieldElement.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 08.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackViewFormView.h"

@interface INSStackViewTextFieldElement : INSStackViewFormView
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, strong) NSNumber *textFieldLengthPercentage;
@end
