//
//  ActionView.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewBaseElement.h"

@interface ActionView : INSStackFormViewBaseElement
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
