//
//  UIDevice+Extension.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeviceVerType) {
    
    DeviceVer4,
    DeviceVer5,
    DeviceVer6,
    DeviceVer6P
};

@interface UIDevice (Extension)

+ (DeviceVerType)deviceVerType;

@end
