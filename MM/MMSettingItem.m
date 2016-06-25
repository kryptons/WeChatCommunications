//
//  MMSettingItem.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSettingItem.h"

@implementation MMSettingItem

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.alignment = MMSettingItemAlignmentRight;
        self.bgColor = [UIColor whiteColor];
        
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:15.5f];
        self.subTitleColor = [UIColor grayColor];
        self.subTitleFont = [UIFont systemFontOfSize:15.0f];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.rightImageHeightOfCell = 0.72;
        self.middleImageHeightOfCell = 0.35;
    }
    return self;
}

+ (MMSettingItem *)createWithTitle:(NSString *)title {
    
    return [MMSettingItem createWithImageName:nil title:title];
}

+ (MMSettingItem *)createWithImageName:(NSString *)imageName title:(NSString *)title {
    
    return [MMSettingItem createWithImageName:imageName title:title subTitle:nil rightImageName:nil];
}

+ (MMSettingItem *) createWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    return [MMSettingItem createWithImageName:nil title:title subTitle:subTitle rightImageName:nil];
}

+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title middleImageName:(NSString *)middleImageName subTitle:(NSString *)subTitle {
    
    return [MMSettingItem createWithImageName:imageName title:title middleImageName:middleImageName subTitle:subTitle rightImageName:nil];
}

+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle rightImageName:(NSString *)rightImageName {
    
    return [MMSettingItem createWithImageName:imageName title:title middleImageName:nil subTitle:subTitle rightImageName:rightImageName];
}

+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title middleImageName:(NSString *)middleImageName subTitle:(NSString *)subTitle rightImageName:(NSString *)rightImageName
{
    MMSettingItem *item = [[MMSettingItem alloc] init];
    item.imageName = imageName;
    item.middleImageName = middleImageName;
    item.rightImageName = rightImageName;
    item.title = title;
    item.subTitle = subTitle;
    return item;
}

- (void)setAlignment:(MMSettingItemAlignment)alignment
{
    _alignment = alignment;
    if (alignment == MMSettingItemAlignmentMiddle) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setType:(MMSettingItemType)type
{
    _type = type;
    if (type == MMSettingItemTypeSwitch) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (type == MMSettingItemTypeButton) {
        self.btnBGColor = [UIColor colorWithRed:2.0/255.0 green:187.0/255.0 blue:1.0/255.0 alpha:1.0f];
        self.btnTitleColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgColor = [UIColor clearColor];
    }
}
@end
