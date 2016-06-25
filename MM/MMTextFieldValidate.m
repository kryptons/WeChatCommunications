//
//  MMTextFieldValidate.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MMTextFieldValidate.h"

@implementation MMTextFieldValidate

#pragma mark - 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile {
    
    if (mobile.length == 0) {
        
        NSString *message = @"手机号不能为空";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                           message:message
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    if (![NSString isMobileNumber:mobile]) {
        
        NSString *message = @"手机号格式不正确";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - 验证电子邮箱
+ (BOOL)validateEmail:(NSString *)email {
    
    if (email.length == 0) {
        return NO;
    }
    NSString *expression = [NSString stringWithFormat:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    NSError *error = NULL;
    NSRegularExpression *regularExpre = [[NSRegularExpression alloc] initWithPattern:expression
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSTextCheckingResult *match = [regularExpre firstMatchInString:email
                                                           options:0
                                                             range:NSMakeRange(0,[email length])];
    if (!match) {
        
        NSString *message = @"邮箱格式不正确";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

//验证密码
+(BOOL)validatePassword:(NSString *)password
{
    if (password.length == 0) {
        return NO;
    }
    if (password.length < 6) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"密码不足六位！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
