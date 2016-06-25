//
//  MMNewMessageViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMNewMessageViewController.h"

@interface MMNewMessageViewController () {
    
    RCUserInfo *_userInfo;
}

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MMNewMessageViewController

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
    
    self.navigationItem.title = @"新消息通知";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    // 注册
    [self.tableView registerClass:[MMSettingCell class] forCellReuseIdentifier:settingCellID];
    // 获取数据
    self.data = [MMMineHelper getNewMessageItems];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data ? self.data.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MMSettingGroup *group = [self.data objectAtIndex:section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID];
    MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
    MMSettingItem *item = [group itemAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
}

#pragma mark - UITableViewDelegate
// 加载数据
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MMHeaderFooterView *view = [[MMHeaderFooterView alloc] initWithReuseIdentifier:@"MMHeaderFooterView"];
    if (self.data && self.data.count > section) {
        
        MMSettingGroup *group = [self.data objectAtIndex:section];
        [view setText:group.headerTitle];
    }
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    MMHeaderFooterView *view = [[MMHeaderFooterView alloc] initWithReuseIdentifier:@"MMHeaderFooterView"];
    if (self.data && self.data.count > 0) {
        
        MMSettingGroup *group = [self.data objectAtIndex:section];
        [view setText:group.footerTitle];
    }
    return view;
}

// 计算高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.data && self.data.count > indexPath.section) {
        
        MMSettingGroup *group = [self.data objectAtIndex:indexPath.section];
        MMSettingItem *item = [group itemAtIndex:indexPath.row];
        return [MMSettingCell getHeightForText:item];
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.data && self.data.count > section) {
        MMSettingGroup *group = [self.data objectAtIndex:section];
        if (group.headerTitle == nil) {
            return section == 0 ? 15.0f : 10.0f;
        }
        return [MMHeaderFooterView getHeightForText:group.headerTitle];
    }
    return 10.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.data && self.data.count > section) {
        MMSettingGroup *group = [_data objectAtIndex:section];
        if (group.footerTitle == nil) {
            return section == _data.count - 1 ? 30.0f : 10.0f;
        }
        return [MMHeaderFooterView getHeightForText:group.footerTitle];
    }
    return 10.0f;
}

@end
