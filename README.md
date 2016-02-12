[![](http://inspace.io/github-cover.jpg)](http://inspace.io)

# Introduction

**INSStackViewForms** was written by **[Michał Zaborowski](https://github.com/m1entus)** for **[inspace.io](http://inspace.io)**

# INSStackViewForms

`INSStackViewForms` is a library for creating dynamic UIStackView forms. It subclass from UIStackView. Fully compatible with Swift & Obj-C. The goal of the library is to make modular forms created from already defined custom views. Main advantage of this library is that we build it using UIStackView which don't dequeue views, so you have access to all views all the time.

INSStackViewForms provides a very powerful DSL (Domain Specific Language) used to create a form. It keeps track of this specification on runtime, updating the UI on the fly.

If you want to support <iOS9 where UIStackView is not available, solution is to use [OAStackView](https://github.com/oarrabi/OAStackView). All you need to do is import `OAStackView` to your project and all magic will be done.

[![](https://raw.github.com/inspace-io/INSStackViewForms/master/Screens/animation.gif)](https://raw.github.com/inspace-io/INSStackViewForms/master/Screens/animation.gif)
[![](https://raw.github.com/inspace-io/INSStackViewForms/master/Screens/1.png)](https://raw.github.com/inspace-io/INSStackViewForms/master/Screens/1.png)

# Usage
```objective-c
[self.stackFormView addSection:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {

    [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
        builder.itemClass = [CustomView class];
        builder.userInteractionEnabled = NO;
        builder.height = nil; // dynamic height
        builder.configurationBlock = ^(CustomView *view) {
            view.backgroundColor = [UIColor whiteColor];
        };
    }];

    [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
        builder.itemClass = [INSStackFormViewLabelElement class];
        builder.height = @50;
        builder.title = @"Title of text label";
        builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
            view.backgroundColor = [UIColor whiteColor];
            view.textLabel.textColor = [UIColor redColor];
        };
        builder.actionBlock = ^(INSStackFormViewLabelElement *view) {
            NSLog(@"ACTION");
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
                [weakSelf.stackFormView removeSection:[weakSelf.stackFormView.sections firstObject] animated:YES completion:nil];
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
```

## CocoaPods

Add the following to your `Podfile` and run `$ pod install`.

CocoaPods support iOS9

``` ruby
pod 'INSStackViewForms'
```

If you want to support <iOS9 where UIStackView is not available, solution is to use [OAStackView](https://github.com/oarrabi/OAStackView). I prepared subspec to make it easier.

CocoaPods support <iOS9

``` ruby
pod 'INSStackViewForms/OAStackView'
```

If you don't have CocoaPods installed, you can learn how to do so [here](http://cocoapods.org).

## ARC

`INSStackViewForms` uses ARC.

## Contact

[inspace.io](http://inspace.io)

[Twitter](https://twitter.com/inspace_io)

# License

The MIT License (MIT)

Copyright (c) 2016 inspace.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
