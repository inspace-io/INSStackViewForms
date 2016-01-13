//
//  INSStackFormViewUpdateItem.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 12.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

@import UIKit;
#import "INSStackFormSection.h"
#import "INSStackFormItem.h"

typedef NS_ENUM(NSInteger, INSStackFormViewUpdateAction) {
    INSStackFormViewUpdateActionInsert,
    INSStackFormViewUpdateActionDelete,
    INSStackFormViewUpdateActionReload,
    INSStackFormViewUpdateActionRefresh,
    INSStackFormViewUpdateActionMove,
    INSStackFormViewUpdateActionNone
};

@interface INSStackFormViewUpdateItem : NSObject

@property (nonatomic, readonly, strong) NSIndexPath *indexPathBeforeUpdate; // nil for INSStackFormViewUpdateActionInsert
@property (nonatomic, readonly, strong) NSIndexPath *indexPathAfterUpdate;  // nil for INSStackFormViewUpdateActionDelete
@property (nonatomic, readonly, assign) INSStackFormViewUpdateAction updateAction;

@property (nonatomic, readonly, assign) INSStackFormSection *section;
@property (nonatomic, readonly, assign) INSStackFormItem *item;

- (id)initWithInitialIndexPath:(NSIndexPath *)initialIndexPath
                finalIndexPath:(NSIndexPath *)finalIndexPath
                  updateAction:(INSStackFormViewUpdateAction)action section:(INSStackFormSection *)section item:(INSStackFormItem *)item;

- (id)initWithAction:(INSStackFormViewUpdateAction)action
        forIndexPath:(NSIndexPath *)indexPath section:(INSStackFormSection *)section item:(INSStackFormItem *)item;

- (BOOL)isSectionOperation;

- (INSStackFormViewUpdateAction)updateAction;

- (NSComparisonResult)compareIndexPaths:(INSStackFormViewUpdateItem *)otherItem;

- (NSComparisonResult)inverseCompareIndexPaths:(INSStackFormViewUpdateItem *)otherItem;
@end
