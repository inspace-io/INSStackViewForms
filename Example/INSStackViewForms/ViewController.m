//
//  ViewController.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//

#import "ViewController.h"
#import "INSStackViewFormView.h"
#import "CustomView.h"
#import "HideView.h"
#import "SectionHeaderView.h"
#import "ActionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.showItemSeparators = YES;
    // Do any additional setup after loading the view, typically from a nib.
    
    INSStackViewFormItem *item = [[INSStackViewFormItem alloc] init];
    item.itemClass = [INSStackViewFormView class];
    item.height = @100;
    item.configurationBlock = ^(INSStackViewFormView *view) {
        view.backgroundColor = [UIColor blackColor];
    };
    
    __weak typeof(self) weakSelf = self;
    item.actionBlock = ^(INSStackViewFormView *view) {
        [UIView animateWithDuration:0.25 animations:^{
            view.hidden = YES;
        } completion:^(BOOL finished) {
            [weakSelf removeItem:view.item fromSection:view.section];
        }];
        
        
    };
    
    [self insertItem:item atIndex:1 toSection:self.sections[0]];
    
}

- (NSMutableArray <INSStackViewFormSection *> *)initialCollectionSections {
    NSMutableArray *sections = [super initialCollectionSections];
    
    [sections addObject:[INSStackViewFormSection sectionWithBuilder:^(INSStackViewFormSection *sectionBuilder) {
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [CustomView class];
            builder.userInteractionEnabled = NO;
            builder.height = nil; // dynamic height
            builder.configurationBlock = ^(INSStackViewFormView *view) {
                view.backgroundColor = [UIColor whiteColor];
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [HideView class];
            builder.userInteractionEnabled = NO;
            builder.height = @50;
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [INSStackViewFormView class];
            builder.height = @50;
            builder.configurationBlock = ^(INSStackViewFormView *view) {
                view.backgroundColor = [UIColor whiteColor];
            };
            builder.actionBlock = ^(INSStackViewFormView *view) {
                NSLog(@"ACTION");
            };
        }];
        
    }]];
    
    [sections addObject:[INSStackViewFormSection sectionWithBuilder:^(INSStackViewFormSection *sectionBuilder) {
        
        [sectionBuilder addHeaderWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [SectionHeaderView class];
            builder.height = @60;
            builder.configurationBlock = ^(SectionHeaderView *view) {
                view.titleLabel.text = @"SECTION HEADER";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [ActionView class];
            builder.height = @50;
            builder.configurationBlock = ^(ActionView *view) {
                view.titleLabel.text = @"Click Me to show details!";
            };
        }];
        
    }]];
    
    return sections;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
