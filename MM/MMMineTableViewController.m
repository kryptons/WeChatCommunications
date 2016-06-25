//
//  MMMineTableViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMMineTableViewController.h"
#import "MMBubbleAnimationViewController.h"
#import "MMPictureViewController.h"
#import "MMPhotoViewController.h"

@interface MMMineTableViewController ()

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MMMineTableViewController

#pragma mark - lazy
- (NSMutableArray *)data {
    
    if (!_data) {
        
        _data = [NSMutableArray array];
    }
    return _data;
}

static NSString *const userDetailCell = @"MMUserDetailCell";
static NSString *const settingCell = @"MMSettingCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0); // 设置tableView的内边距，向上移20
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.sectionHeaderHeight = 5;
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundView = view;
    
    // 注册
    [self.tableView registerClass:[MMUserDetailCell class] forCellReuseIdentifier:userDetailCell];
    [self.tableView registerClass:[MMSettingCell class] forCellReuseIdentifier:settingCell];
    // 加载数据
    [self reloadDetailData];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDetailData) name:@"kRCNeedEditingUserNameNotification" object:nil];
}

- (void)reloadDetailData {
    
   RCUserInfo *user = [[RCIM sharedRCIM] currentUserInfo];
    [MMHTTPTOOLS getUserInfoWithUserID:user.userId completion:^(RCUserInfo *user) {
        
        self.userInfo = user;
    }];
    self.data = [MMMineHelper getMineVCItems];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
// 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.data ? self.data.count + 1 : 0;
}

// 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
    }
    else {
        
        MMSettingGroup *group = [self.data objectAtIndex:section - 1]; // 这里section从1开始
        return group.itemsCount;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MMUserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:userDetailCell forIndexPath:indexPath];
        cell.userInfo = self.userInfo;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右边小箭头
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else {
        
        MMSettingGroup *group = [self.data objectAtIndex:indexPath.section - 1];
        MMSettingItem *item = [group itemAtIndex:indexPath.row];
        MMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell];
        // 设置数据
        [cell setItem:item];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右边小箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id vc = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        vc = [[MMMineDetailViewController alloc] initWithNibName:nil bundle:nil withUserInfo:self.userInfo];
    }
    else {
        
        MMSettingGroup *group = [self.data objectAtIndex:indexPath.section - 1];
        MMSettingItem *item = [group itemAtIndex:indexPath.row];
        if ([item.title isEqualToString:@"表情"]) {
            
            vc = [[MMExpresionViewController alloc] init];
        }
        else if ([item.title isEqualToString:@"相册"]) {
            
            vc = [[MMPhotoViewController alloc] init];
        }
        else if ([item.title isEqualToString:@"炫酷动画"]) {
            
            vc = [[MMBubbleAnimationViewController alloc] init];
        }
        else if ([item.title isEqualToString:@"图片动画"]) {
            
            vc = [[MMPictureViewController alloc] init];
        }
        else if ([item.title isEqualToString:@"设置"]) {
            
            vc = [[MMSettingViewController alloc] initWithNibName:nil bundle:nil withUserInfo:self.userInfo];
        }
    }
    if (vc != nil) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 90.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [super tableView:tableView heightForFooterInSection:0];
    }
    return [super tableView:tableView heightForFooterInSection:section - 1];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
