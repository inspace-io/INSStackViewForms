//
//  ViewController.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 03.01.2016.
//  Copyright © 2016 Inspace Labs Sp z o. o. Spółka Komandytowa. All rights reserved.
//

#import "ViewController.h"
#import "INSStackFormViewBaseElement.h"
#import "CustomView.h"
#import "HideView.h"
#import "SectionHeaderView.h"
#import "ActionView.h"
#import "INSStackFormViewLabelElement.h"
#import "INSStackFormViewTextFieldElement.h"

@interface ViewController () <INSStackViewFormViewDateSource>
@property (weak, nonatomic) IBOutlet INSStackFormView *stackFormView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.stackFormView.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
    
    INSStackFormItem *item = [[INSStackFormItem alloc] init];
    item.itemClass = [INSStackFormViewBaseElement class];
    item.height = @100;
    item.configurationBlock = ^(INSStackFormViewBaseElement *view) {
        view.backgroundColor = [UIColor blackColor];
    };
    
    __weak typeof(self) weakSelf = self;
    item.actionBlock = ^(INSStackFormViewBaseElement *view) {
        [weakSelf.stackFormView performBatchUpdates:^{
            [weakSelf.stackFormView deleteItems:@[view.item]];
        } completion:nil];
    };
    
    [self.stackFormView addSections:[self sectionsForStackFormView:self.stackFormView]];
    
    [self.stackFormView insertItems:@[item] toSection:self.stackFormView.sections[0] atIndex:2];
}

- (NSArray <INSStackFormSection *> *)sectionsForStackFormView:(INSStackFormView *)stackViewFormView {
    NSMutableArray *sections = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [CustomView class];
            builder.userInteractionEnabled = NO;
            builder.height = nil; // dynamic height
            builder.configurationBlock = ^(INSStackFormViewBaseElement *view) {
                view.backgroundColor = [UIColor whiteColor];
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [HideView class];
            builder.userInteractionEnabled = NO;
            builder.height = @50;
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewBaseElement class];
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewBaseElement *view) {
                view.backgroundColor = [UIColor whiteColor];
            };
            builder.actionBlock = ^(INSStackFormViewBaseElement *view) {
                NSLog(@"ACTION");
            };
        }];
        
    }]];
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"TEST";
            builder.height = @50;
            builder.actionBlock = ^(INSStackFormViewBaseElement *view) {
                
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Name";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Name";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Last Name";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Last Name";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"Phone";
            builder.title = @"Phone";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Phone";
                view.textField.keyboardType = UIKeyboardTypePhonePad;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Section Validation Test !";
            builder.height = @50;
            builder.actionBlock = ^(INSStackFormViewBaseElement *view) {
                NSArray *errors = nil;
                if (![view.stackFormView validateSection:view.section errorMessages:&errors]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[errors firstObject] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Section Valid!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            };
            builder.validationBlock = ^BOOL(__kindof INSStackFormViewBaseElement *view, INSStackFormItem *item, NSString **errorMessage) {
                if (![view.stackFormView firstItemWithIdentifier:@"Phone"].value) {
                    *errorMessage = @"Phone number can't be nil";
                    return NO;
                }
                return YES;
            };
        }];
        
        
    }]];
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        
        [sectionBuilder addHeaderWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [SectionHeaderView class];
            builder.height = @60;
            builder.configurationBlock = ^(SectionHeaderView *view) {
                view.titleLabel.text = @"SECTION HEADER";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [ActionView class];
            builder.height = @50;
            builder.configurationBlock = ^(ActionView *view) {
                view.accesoryType = INSStackFormViewBaseElementAccessoryNone;
                view.titleLabel.text = @"Click Me to show details!";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [ActionView class];
            builder.height = @50;
            builder.configurationBlock = ^(ActionView *view) {
                view.accesoryType = INSStackFormViewBaseElementAccessoryNone;
                view.titleLabel.text = @"Click Me to remove section!";
            };
            
            builder.actionBlock = ^(INSStackFormViewBaseElement *view) {
                NSArray *errors = nil;
                if ([weakSelf.stackFormView validateDataItems:&errors]) {
                    [weakSelf.stackFormView performBatchUpdates:^{
                        [weakSelf.stackFormView deleteSections:@[[weakSelf.stackFormView.sections firstObject]]];
                    } completion:nil];

                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[errors firstObject] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                
            };
            
            builder.validationBlock = ^BOOL(__kindof UIView *view, INSStackFormItem *item, NSString **errorMessage) {
                if (weakSelf.stackFormView.sections.count <= 1) {
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
