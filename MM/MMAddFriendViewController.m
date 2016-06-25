//
//  MMAddFriendViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAddFriendViewController.h"

@interface MMAddFriendViewController ()
{
    RCUserInfo *_userInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation MMAddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserInfo:(RCUserInfo *)userInfo {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    // 显示好友信息
    self.lblName.text = _userInfo.name;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
}

#pragma mark - 添加好友
- (IBAction)addFriendClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定添加为好友?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [MMHTTPTOOLS requestAddFriend:_userInfo.userId complete:^(BOOL result) {
            
            if (result) {
                
                [SVProgressHUD showSuccessWithStatus:@"请求发送成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:@"请求发送失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionConfirm];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
