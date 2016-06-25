//
//  NSString+Extension.m
//  GSTPatient
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


#pragma mark - 转换日期
+ (NSString *)getDate:(NSString *)date {
    
    // 转换date的时间戳
    NSDate *dateString = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *stringDate = [dateFormatter stringFromDate:dateString];
    return stringDate;
}

#pragma mark - 当前时间转为时间戳
+ (NSString *)switchNowTimeToTimeStamp {
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; // 转为字符型
    return timeString;
}

#pragma mark - 正则表达式判断是否为手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

#pragma mark - 获取当前时间
+ (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]]; // [NSDate date]当前时间
    return currentTime;
}

#pragma mark - 第一种计算缓存大小
+ (NSInteger)getCacheSizeFirstMethod {
    
    // 文件总大小
    NSInteger size = 0;
    // 沙盒路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接default路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"default"];
    // 文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // enumeratorAtPath迭代器，也就是遍历。返回一个迭代器，可以通过for...in遍历里面的数据
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:filePath];
    // 遍历default文件中所有文件
    for (NSString *subPath in enumerator) {
        
        // 拼接文件的全路径
        NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
        // 获取全路径文件属性
        NSDictionary *pathDict = [fileManager attributesOfItemAtPath:fullPath error:nil];
        // 累加计算总大小
        size += [pathDict fileSize];
    }
    return size;
}

#pragma mark - 第二种计算缓存大小
+ (NSInteger)getCacheSizeSecondMethod {
    
    // 文件总大小
    NSInteger size = 0;
    // 沙盒路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接default路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"default"];
    // 获取default中所有文件
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:filePath];
    // 遍历default文件中所有内容
    for (NSString *subPath in subPaths) {
        
        // 拼接文件全路径
        NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
        // 获取文件属性
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        // 累加计算缓存大小
        size += [fileDict fileSize];
    }
    return size;
}

#pragma mark - 计算缓存大小
+ (NSString *)getCacheSize {
    
    NSInteger size = 0;
    
    // 获取沙盒的宏
    NSString *cacheFiles = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"];
    size = cacheFiles.fileSize;
    CGFloat unit = 1000.0;
    NSString *text = nil;
    if (size >= 1000.0 * 1000.0 * 1000.0) {
        text = [NSString stringWithFormat:@"(%.1f GB)", size / unit / unit / unit];
    }
    else if (size >= 1000.0 * 1000.0) {
        text = [NSString stringWithFormat:@"(%.1f MB)", size / unit / unit ];
    }
    else if (size >= 1000.0) {
        text = [NSString stringWithFormat:@"(%.1f KB)", size / unit];
    }
    else {
        text = [NSString stringWithFormat:@"(%zd B)", size];
    }
    return text;
}

// 判断一个路径是文件夹还是文件(另一种方法)
// [[fileManager attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeDirectory]; // 文件夹
// [[fileManager attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeRegular];  // 文件
- (NSInteger)fileSize {
    
    // 文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 路径是否存在
    BOOL isExists = [fileManager fileExistsAtPath:self isDirectory:&isDirectory];
    // 路径不存在
    if (isExists == NO) {
        return 0;
    }
    if (isDirectory == YES) {
        
        // 文件总大小
        NSInteger size = 0;
        // 获取default里所有文件
        NSArray *subPaths = [fileManager subpathsAtPath:self];
        for (NSString *subPath in subPaths) {
            
            // 拼接全路径
            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
            // 获取全路径文件的属性
            NSDictionary *fileDict = [fileManager attributesOfItemAtPath:fullPath error:nil];
            // 累加计算总大小
            size += [fileDict fileSize];
        }
        return size;
    }
    else { // 不是文件夹
        
        return [fileManager attributesOfItemAtPath:self error:nil].fileSize;
    }
}

@end





