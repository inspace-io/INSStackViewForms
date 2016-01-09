//
//  INSStackViewLabelElement.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 06.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewBaseElement.h"

@interface INSStackFormViewLabelElement : INSStackFormViewBaseElement
@property (nonatomic, readonly, strong, nonnull) UILabel *textLabel;
@property (nonatomic, readonly, strong, nonnull) UILabel *detailTextLabel;
@end
