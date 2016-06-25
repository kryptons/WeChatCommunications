//
//  MMSettingGroup.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSettingGroup.h"

@implementation MMSettingGroup

- (id) initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle settingItems:(MMSettingItem *)firstObj, ...
{
    if (self = [super init]) {
        
        _headerTitle = headerTitle;
        _footerTitle = footerTitle;
        _items = [[NSMutableArray alloc] init];
        va_list argList;
        if (firstObj) {
            [_items addObject:firstObj];
            va_start(argList, firstObj);
            id arg;
            while ((arg = va_arg(argList, id))) {
                [_items addObject:arg];
            }
            va_end(argList);
        }
    }
    return self;
}

- (MMSettingItem *)itemAtIndex:(NSUInteger)index
{
    return [_items objectAtIndex:index];
}

- (NSUInteger)indexOfItem:(MMSettingItem *)item
{
    return [_items indexOfObject:item];
}

- (NSUInteger)itemsCount
{
    return self.items.count;
}


@end
