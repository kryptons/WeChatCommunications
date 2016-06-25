//
//  MMLoginViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/28.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMLoginViewController.h"
#import "JSONModel/JSONModelLib.h"

#define TokenID001 @"BPsq/lFeia60FVwN/BIV5qxiKdwUDwEVb3cAtaMvw1+rLZUyShKwpiY9AaqvOqDCclntoEQNOKiaIpb9glAb8g=="
#define TokenID002 @"Hf7JPyBNv5pxbBB40q9r/3ZIXiHVgK3eO1/Yw5RoSXKNLF+D+3zVnwtALdoeTmWfPG2W6die6kRv/E8kvQ5QtA=="
#define TokenID003 @"UBdN9IKOiDOGcLMsWd5tTnZIXiHVgK3eO1/Yw5RoSXKNLF+D+3zVn84k+XFaLXPvVhWUPXFYUjdJo5UUWZpTzQ=="

#define Env @"1"

@interface MMLoginViewController () <RCAnimatedImagesViewDelegate>
/** 登录账号 */
@property (weak, nonatomic) IBOutlet MMLoginRegisterTextField *txtLoginAccount;
/** 登录密码 */
@property (weak, nonatomic) IBOutlet MMLoginRegisterTextField *txtLoginPassword;
/** 注册账号 */
@property (weak, nonatomic) IBOutlet MMLoginRegisterTextField *txtRegisterAccount;
/** 注册密码 */
@property (weak, nonatomic) IBOutlet MMLoginRegisterTextField *txtRegisterPassword;
/** 下划线 */
@property (weak, nonatomic) IBOutlet UIView *loginLineOne;
@property (weak, nonatomic) IBOutlet UIView *loginLineTwo;
@property (weak, nonatomic) IBOutlet UIView *registerLineOne;
@property (weak, nonatomic) IBOutlet UIView *registerLineTwo;
/** 右边约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpace;
/** 左边约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;

/** 添加动态图 */
// @property (nonatomic, retain) RCAnimatedImagesView *animatedImagesView;
@property (strong, nonatomic) IBOutlet RCAnimatedImagesView *animatedImagesView;

/** 是否为测试 */
@property (nonatomic) BOOL mmDebug;

@end

@implementation MMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [self.navigationController.navigationBar setTitleTextAttributes:attr];
    
    [self.txtLoginAccount addTarget:self action:@selector(accountTextFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtLoginAccount addTarget:self action:@selector(accountTextfieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
    [self.txtLoginPassword addTarget:self action:@selector(passwordTextFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtLoginPassword addTarget:self action:@selector(passwordTextFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
    [self.txtRegisterAccount addTarget:self action:@selector(accountTextFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtRegisterAccount addTarget:self action:@selector(accountTextfieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
    [self.txtRegisterPassword addTarget:self action:@selector(passwordTextFieldDidBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtRegisterPassword addTarget:self action:@selector(passwordTextFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
    
    // 添加动态图
    self.animatedImagesView.delegate = self;
}

#pragma mark - <RCAnimatedImagesViewDelegate>
- (NSUInteger)animatedImagesNumberOfImages:(RCAnimatedImagesView*)animatedImagesView
{
    return 2;
}

- (UIImage*)animatedImagesView:(RCAnimatedImagesView*)animatedImagesView imageAtIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"aisi_bg.jpg"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.animatedImagesView startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.animatedImagesView stopAnimating];
}

- (void)viewDidUnload
{
    [self setAnimatedImagesView:nil];
    
    [super viewDidUnload];
}

#pragma mark - 改变TextField下划线颜色方法
- (void)accountTextFieldDidBeginEditing {
    
    self.loginLineOne.backgroundColor = MMTintColor;
    self.registerLineOne.backgroundColor = MMTintColor;
}

- (void)accountTextfieldDidEndEditing {
    
    self.loginLineOne.backgroundColor = MMboldColor;
    self.registerLineOne.backgroundColor = MMboldColor;
}

- (void)passwordTextFieldDidBeginEditing {
    
    self.loginLineTwo.backgroundColor = MMTintColor;
    self.registerLineTwo.backgroundColor = MMTintColor;
}

- (void)passwordTextFieldDidEndEditing {
    
    self.loginLineTwo.backgroundColor = MMboldColor;
    self.registerLineTwo.backgroundColor = MMboldColor;
}

#pragma mark - 切换注册界面
- (IBAction)registerAccountClict:(UIButton *)sender {
    
    self.leftSpace.constant = - MMWidth;
    self.rightSpace.constant = MMWidth - MMConstantMargin;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded]; // 刷新约束
    }];
    // 修改导航栏名
    self.title = @"注册MM";
}

#pragma mark - 切换登录界面
- (IBAction)loginAccountClick:(UIButton *)sender {
    
    self.leftSpace.constant = - MMConstantMargin;
    self.rightSpace.constant = - MMConstantMargin;
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded]; // 刷新约束
    }];
    self.title = @"登录MM";
}

#pragma mark - 找回密码
- (IBAction)findBackYourPassword:(id)sender {
    
    [SVProgressHUD showInfoWithStatus:@"暂时没实现" maskType:SVProgressHUDMaskTypeBlack];
    [UIView animateWithDuration:2.5 animations:^{
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 获取默认用户
/*
 * 获取默认用户名、密码、TokenID
 */
- (BOOL)getDefaultUser {
    
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]; // 获取沙盒中用户名
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]; // 获取沙盒中密码
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    return email && password && tokenID;
}

- (BOOL)isExistTokenID {
    
    NSString *isExist = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    return isExist;
}

- (NSString *)getDefaultEmail {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

- (NSString *)getDefaultPassword {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (NSString *)getDefaultUserTokenID {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
}

/*****************************************登录********************************************/
#pragma mark - 登录
- (IBAction)loginClick:(id)sender {
    
    // 检查当前网络状态
    RCNetworkStatus status = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (status == RC_NotReachable) {
        
        [SVProgressHUD showErrorWithStatus:@"当前网络不可用" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    else { // 用户登录
        
        NSString *email = self.txtLoginAccount.text;
        NSString *password = self.txtLoginPassword.text;
        [self loginWithEmail:email withPassword:password];
    }
}

- (void)loginWithEmail:(NSString *)email withPassword:(NSString *)password {
    
    if ([self validateEmail:email password:password]) {
        
        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserCookies"];
        [MMAFHttpTool loginWithEmail:email withPassword:password env:Env success:^(id response) {
            
            if ([response[@"code"] intValue] == 200) {
                
                NSString *token = response[@"result"][@"token"];
                [self loginRongCloudWithEmail:email withPassword:password withToken:token];
            }
            else {
                
                [SVProgressHUD dismiss];
                int errorCode = [response[@"code"] intValue];
                if (errorCode == 500) {
                    
                    [SVProgressHUD showErrorWithStatus:@"APP服务器错误" maskType:SVProgressHUDMaskTypeBlack];
                }
                else {
                    
                    [SVProgressHUD showErrorWithStatus:@"用户名或密码错误" maskType:SVProgressHUDMaskTypeBlack];
                }
            }
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            if (error.code == 3840) {
                
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误" maskType:SVProgressHUDMaskTypeBlack];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"DemoServer错误" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
    else {
        
        [SVProgressHUD showInfoWithStatus:@"请检查用户名和密码" maskType:SVProgressHUDMaskTypeBlack];
    }
}

#pragma mark - 登录融云服务器
/**
 *  登录融云服务器
 *
 *  @param userName 用户名
 *  @param token    token
 *  @param password 密码
 */
- (void)loginRongCloudWithEmail:(NSString *)email withPassword:(NSString *)password withToken:(NSString *)token {
    
    // 登录融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        [SVProgressHUD dismiss];
        NSLog([NSString stringWithFormat:@"token is %@  userId is %@",token,userId],nil);
        // 成功登录融云服务器
        [self loginSuccessWithEmail:email withPassword:password withToken:token withUserId:userId];
        
    } error:^(RCConnectErrorCode status) {
        
        [SVProgressHUD dismiss];
        NSLog(@"Token无效,RCConnectErrorCode is %ld",(long)status);
    } tokenIncorrect:^{
        [SVProgressHUD dismiss];
        NSLog(@"TokenID已过期，请重新获取");
    }];
}

#pragma mark - 成功登录服务器
- (void)loginSuccessWithEmail:(NSString *)email withPassword:(NSString *)password withToken:(NSString *)token withUserId:(NSString *)userId {
    
    // 保存默认用户的基本信息到沙盒中
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
    // 设置当前用户信息
    RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:email portrait:nil];
    [RCIMClient sharedRCIMClient].currentUserInfo = currentUserInfo;
    // 保存登录用户信息
    [MMHTTPTOOLS getUserInfoWithUserID:userId completion:^(RCUserInfo *user) {
        
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        [[NSUserDefaults standardUserDefaults] setObject:user.portraitUri forKey:@"portraitUri"];
        [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
    // 同步群组
    [MMDataSource syncGroups];
    [MMDataSource syncFriendList:^(NSMutableArray *friends) {}];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        MMTabBarController *tab = [[MMTabBarController alloc] init];
        self.view.window.rootViewController = tab;
    });
}

#pragma mark - 验证用户信息格式
- (BOOL)validateEmail:(NSString *)email password:(NSString *)password {
    
    NSString *alertMessage = nil;
    if (email.length == 0) {
        alertMessage = @"用户名不能为空";
    }
    else if (password.length == 0) {
        alertMessage = @"密码不能为空";
    }
    
    if (alertMessage) {
        
        [SVProgressHUD showInfoWithStatus:alertMessage maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    return [MMTextFieldValidate validateEmail:email]
        && [MMTextFieldValidate validatePassword:password];
}
/**************************************另外一种登录***********************************************/

#pragma mark - 另外一种登录方式
- (void)extraLogin {

    // 检查当前网络状态
    RCNetworkStatus status = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (status == RC_NotReachable) {
        
        [SVProgressHUD showErrorWithStatus:@"当前网络不可用" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    else { // 用户登录
        
        NSString *username = self.txtLoginAccount.text;
        NSString *password = self.txtLoginPassword.text;
        
        // 当前tokenID
        NSString *tokenID = TokenID001;
        // 获取沙盒中是否有保存用户信息
        if ([self isExistTokenID]) { // 有
            
            NSString *existTokenID = [self getDefaultUserTokenID];
            if ([existTokenID isEqualToString:tokenID]) {
                
                NSLog(@"tokenID保存在沙盒，而且跟当前的一样");
                [self loginWithUserID:username withUserName:password withTokenID:tokenID];
            }
            else {
                
                NSLog(@"tokenID保存在沙盒，而且跟当前的不一样");
                [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"tokenID"]; // 缓存在沙盒
                [self loginWithUserID:username withUserName:password withTokenID:tokenID];
            }
        }
        else { // 否
            
            NSLog(@"tokenID没有保存在沙盒");
            // 这里通过后台接口获取用户的TokenID(暂时用融云)
            [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"tokenID"]; // 缓存在沙盒
            [self loginWithUserID:username withUserName:password withTokenID:tokenID];
        }
    }
}

- (void)loginWithUserID:(NSString *)userID withUserName:(NSString *)userName withTokenID:(NSString *)tokenID {
    
    [[RCIM sharedRCIM] connectWithToken:tokenID success:^(NSString *userId) {
        
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [self login];
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"status = %zd", status);
    } tokenIncorrect:^{
        
        NSLog(@"TokenID已过期，请重新获取");
    }];
}

- (void)login {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MMTabBarController *tab = [[MMTabBarController alloc] init];
        self.view.window.rootViewController = tab;
    });
}
/*****************************************注册********************************************/
- (IBAction)registerUserInfoClick:(id)sender {
    
    // 检查当前网络状态
    RCNetworkStatus status = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
    if (status == RC_NotReachable) {
        
        [SVProgressHUD showErrorWithStatus:@"当前网络不可用" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    else { // 用户登录
        
        NSString *email = self.txtRegisterAccount.text;
        NSString *password = self.txtRegisterPassword.text;
        if ([self validateEmail:email password:password]) {
            
            [MMAFHttpTool registerWithEmail:email withMobile:@"" withUsername:email withPassword:password success:^(id response) {
                
                int code = [response[@"code"] intValue];
                if (code == 200) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:SVProgressHUDMaskTypeBlack];
                }
                else if (code == 101) {
                    
                    [SVProgressHUD showInfoWithStatus:@"账号已经被注册" maskType:SVProgressHUDMaskTypeBlack];
                }
                else {
                    
                    [SVProgressHUD showErrorWithStatus:@"注册失败" maskType:SVProgressHUDMaskTypeBlack];
                }
            } failure:^(NSError *err) {
                
                [SVProgressHUD showErrorWithStatus:@"注册失败" maskType:SVProgressHUDMaskTypeBlack];
            }];
        }
        else {
            
            [SVProgressHUD showInfoWithStatus:@"请检查用户名和密码" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}




/*****************************************注册********************************************/

#pragma mark - 点击屏幕退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
