//
//  MMMineEditingViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMMineEditingViewController.h"

#define marginX 10
#define marginY 5
#define TextFieldHeight 40

@interface MMMineEditingViewController () {
    
    RCUserInfo *_userInfo;
}

@property (strong, nonatomic) UITextField *myTextField;
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation MMMineEditingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserInfo:(RCUserInfo *)userInfo {
    
    if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"昵称修改";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupTextField];
    
    [self setupRightBarButton];
}

- (void)setupTextField {
    
    self.myTextField = [[UITextField alloc] init];
    self.myTextField.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width - marginX * 2, TextFieldHeight);
    self.myTextField.backgroundColor = [UIColor whiteColor];
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.myTextField];
    
    self.myTextField.text = _userInfo.name;
}

- (void)setupRightBarButton {
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveUserName:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)saveUserName:(UIButton *)button {
    
    if (self.myTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"昵称为空,请输入!" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    else if (self.myTextField.text.length > 32) {
        
        [SVProgressHUD showInfoWithStatus:@"昵称不能大于32位" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    __weak __typeof(&*self) weakSelf = self;
    [MMHTTPTOOLS updateUserName:self.myTextField.text success:^(id response) {
        
        RCUserInfo *user = [RCIMClient sharedRCIMClient].currentUserInfo;
        user.name = weakSelf.myTextField.text;
        [[MMDataBaseManager shareInstance] insertUserToDB:user];
        [RCIM sharedRCIM].currentUserInfo = user;
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
        // 添加一个通知修改昵称
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRCNeedEditingUserNameNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"修改失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

@end
