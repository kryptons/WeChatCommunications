//
//  MMSettingViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSettingViewController.h"

#define DEFAULTS [NSUserDefaults standardUserDefaults]

@interface MMSettingViewController () {
    
    RCUserInfo *_userInfo;
}

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MMSettingViewController

static NSString *const settingCellID = @"MMSettingCell";

#pragma mark - lazy
- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserInfo:(RCUserInfo *)userInfo {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.sectionFooterHeight = 5;
    // 注册
    [self.tableView registerClass:[MMSettingCell class] forCellReuseIdentifier:settingCellID];
    // 获取数据
    self.data = [MMMineHelper getSettingVCItems];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.data ? self.data.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MMSettingGroup *group = [self.data objectAtIndex:section];
    return group.items.count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID];
    MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
    MMSettingItem *item = [group itemAtIndex:indexPath.row];
    [cell setItem:item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右边小箭头
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    id vc = nil;
    MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
    MMSettingItem *item = [group itemAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"新消息通知"]) {
        
        vc = [[MMNewMessageViewController alloc] initWithNibName:nil bundle:nil withUserInfo:_userInfo];
    }
    else if ([item.title isEqualToString:@"清除缓存"]) {
        
        [self setupAlert:item];
    }
    else if ([item.title isEqualToString:@"退出登录"]) {
        
        [self setupAlert:item];
    }
    
    if (vc != nil) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setupAlert:(MMSettingItem *)item {
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否%@?", item.title] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([item.title isEqualToString:@"清除缓存"]) {
            
            [weakSelf clearYourCache];
        }
        else if ([item.title isEqualToString:@"退出登录"]) {
            
            [weakSelf exitLogin];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:conformAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 退出登录
- (void)exitLogin {
    
    // 清除用户登录记录
    [DEFAULTS removeObjectForKey:@"email"];
    [DEFAULTS removeObjectForKey:@"password"];
    [DEFAULTS removeObjectForKey:@"token"];
    [DEFAULTS removeObjectForKey:@"userId"];
    [DEFAULTS removeObjectForKey:@"username"];
    [DEFAULTS synchronize]; // 同步数据
    // 退出
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    MMLoginViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"MMLogin"]; // 本来已经继承NavigationVC(MMLogin在NavigationController的storyBoard ID中设置)
    self.view.window.rootViewController = login;
    [[RCIM sharedRCIM] logout];
}

#pragma mark - 清除缓存
- (void)clearYourCache {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 获取沙盒路径
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        // 拼接default路径
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"default"];
        // 获取default路径下的所有文件夹
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:filePath];
        for (NSString *subPath in files) {
            
            NSError *error;
            NSString *path = [cachePath stringByAppendingPathComponent:subPath]; // 拼接路径
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [SVProgressHUD showInfoWithStatus:@"清除缓存成功" maskType:SVProgressHUDMaskTypeBlack];
        [UIView animateWithDuration:2.5 animations:^{
            
            [SVProgressHUD dismiss];
        }];
    });
}


@end



































