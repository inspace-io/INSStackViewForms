//
//  INSStackFormViewUpdateItem.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 12.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewUpdateItem.h"

@interface INSStackFormViewUpdateItem ()
@property (nonatomic, strong) NSIndexPath *indexPathBeforeUpdate; // nil for INSStackFormViewUpdateActionInsert
@property (nonatomic, strong) NSIndexPath *indexPathAfterUpdate;  // nil for INSStackFormViewUpdateActionDelete
@property (nonatomic, assign) INSStackFormViewUpdateAction updateAction;

@property (nonatomic, assign) INSStackFormSection *section;
@property (nonatomic, assign) INSStackFormItem *item;
@end

@implementation INSStackFormViewUpdateItem

- (id)initWithInitialIndexPath:(NSIndexPath *)initialIndexPath
                finalIndexPath:(NSIndexPath *)finalIndexPath
                  updateAction:(INSStackFormViewUpdateAction)action section:(INSStackFormSection *)section item:(INSStackFormItem *)item {
    if ((self = [super init])) {
        _indexPathBeforeUpdate = initialIndexPath;
        _indexPathAfterUpdate = finalIndexPath;
        _updateAction = action;
        _section = section;
        _item = item;
    }
    return self;
}

- (id)initWithAction:(INSStackFormViewUpdateAction)action
        forIndexPath:(NSIndexPath *)indexPath section:(INSStackFormSection *)section item:(INSStackFormItem *)item {
    if (action == INSStackFormViewUpdateActionInsert)
        return [self initWithInitialIndexPath:nil finalIndexPath:indexPath updateAction:action section:section item:item];
    else if (action == INSStackFormViewUpdateActionDelete)
        return [self initWithInitialIndexPath:indexPath finalIndexPath:nil updateAction:action section:section item:item];
    else if (action == INSStackFormViewUpdateActionReload)
        return [self initWithInitialIndexPath:indexPath finalIndexPath:indexPath updateAction:action section:section item:item];
    
    return nil;
}


- (BOOL)isSectionOperation {
    return (_indexPathBeforeUpdate.item == NSNotFound || _indexPathAfterUpdate.item == NSNotFound) && self.section;
}

- (NSComparisonResult)compareIndexPaths:(INSStackFormViewUpdateItem *)otherItem {
    NSComparisonResult result = NSOrderedSame;
    NSIndexPath *selfIndexPath = nil;
    NSIndexPath *otherIndexPath = nil;
    
    switch (_updateAction) {
        case INSStackFormViewUpdateActionInsert:
            selfIndexPath = _indexPathAfterUpdate;
            otherIndexPath = [otherItem indexPathAfterUpdate];
            break;
        case INSStackFormViewUpdateActionDelete:
            selfIndexPath = _indexPathBeforeUpdate;
            otherIndexPath = [otherItem indexPathBeforeUpdate];
        default: break;
    }
    
    if (self.isSectionOperation) result = [@(selfIndexPath.section) compare:@(otherIndexPath.section)];
    else result = [selfIndexPath compare:otherIndexPath];
    return result;
}

- (NSComparisonResult)inverseCompareIndexPaths:(INSStackFormViewUpdateItem *)otherItem {
    return (NSComparisonResult)([self compareIndexPaths:otherItem] * -1);
}

@end
