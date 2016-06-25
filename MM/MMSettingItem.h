//
//  MMSettingItem.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

// 枚举
typedef NS_ENUM(NSInteger, MMSettingItemAlignment){
    
    MMSettingItemAlignmentLeft,
    MMSettingItemAlignmentRight,
    MMSettingItemAlignmentMiddle
};

typedef NS_ENUM(NSInteger, MMSettingItemType){
    
    MMSettingItemTypeDefault,       // image, title, rightTitle, rightImage
    MMSettingItemTypeButton,        // button
    MMSettingItemTypeSwitch
};

@interface MMSettingItem : NSObject

/** 对齐方式 */
@property (assign, nonatomic) MMSettingItemAlignment alignment;

/** 类型 */
@property (assign, nonatomic) MMSettingItemType type;

// 数据
/** 主图片，左边 */
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSURL *imageURL;

/** 主题 */
@property (strong, nonatomic) NSString *title;

/** 中间图片 */
@property (nonatomic, strong) NSString *middleImageName;
@property (strong, nonatomic) NSURL *middleImageURL;

// 3.2 图片集
@property (nonatomic, strong) NSArray *subImages;

// 4 副标题
@property (nonatomic, strong) NSString *subTitle;

// 5 右图片
@property (nonatomic, strong) NSString *rightImageName;
@property (nonatomic, strong) NSURL *rightImageURL;


/************************ 样式 ************************/
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *btnBGColor;
@property (nonatomic, strong) UIColor *btnTitleColor;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, strong) UIFont *subTitleFont;

@property (nonatomic, assign) CGFloat rightImageHeightOfCell;
@property (nonatomic, assign) CGFloat middleImageHeightOfCell;

/************************ 类方法 ************************/
+ (MMSettingItem *) createWithTitle:(NSString *)title;
+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title;
+ (MMSettingItem *) createWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title middleImageName:(NSString *)MMSettingItem subTitle:(NSString *)subTitle;
+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle rightImageName:(NSString *)rightImageName;
+ (MMSettingItem *) createWithImageName:(NSString *)imageName title:(NSString *)title middleImageName:(NSString *)middleImageName subTitle:(NSString *)subTitle rightImageName:(NSString *)rightImageName;


@end
