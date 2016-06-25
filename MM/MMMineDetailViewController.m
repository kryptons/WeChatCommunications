//
//  MMMineDetailViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMMineDetailViewController.h"

@interface MMMineDetailViewController () {
    
    RCUserInfo *_userInfo;
}

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MMMineDetailViewController

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
    
    self.navigationItem.title = @"个人信息";
    // 创建一个分组的tableView
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =  DEFAULT_BACKGROUND_COLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.sectionHeaderHeight = 5;
    // 注册
    [self.tableView registerClass:[MMSettingCell class] forCellReuseIdentifier:settingCellID];
    // Reload数据
    self.data = [MMMineHelper getMineDetailVCItems:_userInfo];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotificationData) name:@"kRCNeedEditingUserNameNotification" object:nil];
}

#pragma mark - 通知显示更新数据
- (void)reloadNotificationData {
    
    _userInfo = [RCIM sharedRCIM].currentUserInfo;
    self.data = [MMMineHelper getMineDetailVCItems:_userInfo];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
// 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return self.data ? self.data.count : 0;
}
// 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    MMSettingGroup *groud = [self.data objectAtIndex:section];
    return groud.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
    MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
    MMSettingItem *item = [group itemAtIndex:indexPath.row];
    [cell setItem:item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右边小箭头
//    cell.selectionStyle = UITableViewCellSelectionStyleNone; // 取消选中颜色
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 80.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id vc = nil;
    MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
    MMSettingItem *item = [group itemAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"昵称"]) {
        
        vc = [[MMMineEditingViewController alloc] initWithNibName:nil bundle:nil withUserInfo:_userInfo];
    }
    if (vc != nil) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
















