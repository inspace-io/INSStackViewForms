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
#import "INSStackViewLabelElement.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    INSStackViewFormItem *item = [[INSStackViewFormItem alloc] init];
    item.itemClass = [INSStackViewFormView class];
    item.height = @100;
    item.configurationBlock = ^(INSStackViewFormView *view) {
        view.backgroundColor = [UIColor blackColor];
    };
    
    __weak typeof(self) weakSelf = self;
    item.actionBlock = ^(INSStackViewFormView *view) {
        [weakSelf removeItem:view.item fromSection:view.section animated:NO completion:nil];
    };
    
    [self insertItem:item atIndex:1 toSection:self.sections[0]];
    
}

- (NSMutableArray <INSStackViewFormSection *> *)initialCollectionSections {
    NSMutableArray *sections = [super initialCollectionSections];
    
    __weak typeof(self) weakSelf = self;
    
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
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [INSStackViewLabelElement class];
            builder.title = @"TEST";
            builder.subtitle = @"SUBTITLE";
            builder.height = @50;
            builder.actionBlock = ^(INSStackViewFormView *view) {
                
            };
        }];
    }]];
    
    [sections addObject:[INSStackViewFormSection sectionWithBuilder:^(INSStackViewFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        
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
                view.accesoryType = INSStackViewFormViewAccessoryNone;
                view.titleLabel.text = @"Click Me to show details!";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackViewFormItem *builder) {
            builder.itemClass = [ActionView class];
            builder.height = @50;
            builder.configurationBlock = ^(ActionView *view) {
                view.accesoryType = INSStackViewFormViewAccessoryNone;
                view.titleLabel.text = @"Click Me to remove section!";
            };
            
            builder.actionBlock = ^(INSStackViewFormView *view) {
                NSArray *errors = nil;
                if ([weakSelf validateDataItems:&errors]) {
                    [weakSelf removeSection:[weakSelf.sections firstObject] animated:YES completion:nil];
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[errors firstObject] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                
            };
            
            builder.validationBlock = ^BOOL(__kindof UIView *view, INSStackViewFormItem *item, NSString **errorMessage) {
                if (weakSelf.sections.count <= 1) {
                    *errorMessage = @"Please don't delete me !!!";
                    return NO;
                }
                return YES;
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
