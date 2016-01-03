//
//  SectionHeaderView.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import <UIView+INSNibLoading.h>

@interface SectionHeaderView : INSNibLoadedView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
