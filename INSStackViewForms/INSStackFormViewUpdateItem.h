//
//  INSStackFormViewUpdateItem.h
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 12.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, INSStackFormViewUpdateAction) {
    INSStackFormViewUpdateActionInsert,
    INSStackFormViewUpdateActionDelete,
    INSStackFormViewUpdateActionReload,
    INSStackFormViewUpdateActionMove,
    INSStackFormViewUpdateActionNone
};

@interface INSStackFormViewUpdateItem : NSObject

@property (nonatomic, readonly, strong) NSIndexPath *indexPathBeforeUpdate; // nil for INSStackFormViewUpdateActionInsert
@property (nonatomic, readonly, strong) NSIndexPath *indexPathAfterUpdate;  // nil for INSStackFormViewUpdateActionDelete
@property (nonatomic, readonly, assign) INSStackFormViewUpdateAction updateAction;


- (id)initWithInitialIndexPath:(NSIndexPath *)initialIndexPath
                finalIndexPath:(NSIndexPath *)finalIndexPath
                  updateAction:(INSStackFormViewUpdateAction)action;

- (id)initWithAction:(INSStackFormViewUpdateAction)action
        forIndexPath:(NSIndexPath *)indexPath;

- (id)initWithOldIndexPath:(NSIndexPath *)oldIndexPath newIndexPath:(NSIndexPath *)newIndexPath;

- (INSStackFormViewUpdateAction)updateAction;

- (NSComparisonResult)compareIndexPaths:(INSStackFormViewUpdateItem *)otherItem;

- (NSComparisonResult)inverseCompareIndexPaths:(INSStackFormViewUpdateItem *)otherItem;
@end
