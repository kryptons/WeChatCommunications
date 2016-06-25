//
//  MMGroupsTableViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMGroupsTableViewController.h"

@interface MMGroupsTableViewController () <UITableViewDelegate, UITableViewDataSource, JoinQuitGroupDelegate>

@property (nonatomic, strong) NSMutableArray* groups;

@property (strong, nonatomic) UIButton *rightBarButton;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MMGroupsTableViewController

#pragma mark - lazy
- (NSMutableArray *)groups {
    
    if (!_groups) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
}

static NSString *const cellID = @"MMGroupCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"群组";
    self.view.backgroundColor = MMRandomColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMGroupCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak MMGroupsTableViewController *weakSelf = self;
    [MMHTTPTOOLS getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
        self.groups = [NSMutableArray arrayWithArray:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 创建右上角BarButton
    [self setupRightBarButtonItem];
}

#pragma mark - 自定义rightBarButtonItem
- (void)setupRightBarButtonItem {
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    self.rightBarButton = rightBtn;
    [rightBtn setTitle:@"创建群组" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15]; // 设置字体大小并加粗
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30); // 设置rightBarButtonItem的位置向右偏移30
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)rightBarButtonClick {
    
    [SVProgressHUD showInfoWithStatus:@"暂时没有做" maskType:SVProgressHUDMaskTypeBlack];
    [UIView animateWithDuration:2.5 animations:^{
        
        [SVProgressHUD dismiss];
    }];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建群组" message:@"请输入群组名称" preferredStyle:UIAlertControllerStyleAlert];
//    // 创建文本输入框
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        
//        textField.placeholder = @"群名称";
//    }];
//    // 确定
//    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        UITextField *newGroupName = alert.textFields.firstObject;
//        NSLog(@"newGroupName = %@", newGroupName.text);
//        
//        __weak MMGroupsTableViewController *weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//            [MMHTTPTOOLS createGroupWithGroupName:newGroupName.text complete:^(BOOL result) {
//                
//                if (result) {
//                    
//                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"群组%@", newGroupName.text] maskType:SVProgressHUDMaskTypeBlack];
//                    [weakSelf.tableView reloadData];
//                }
//            }];
//        });
//    }];
//    // 取消
//    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:actionConfirm];
//    [alert addAction:actionCancel];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    MMGroupInfo *group = self.groups[indexPath.row];
    cell.groupInfo = group;
    cell.delegate = self;
    cell.isJoin = group.isJoin;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMGroupInfo *groupInfo = self.groups[indexPath.row];
    MMDidJoinGroupViewController *didJoin = [[MMDidJoinGroupViewController alloc] initWithNibName:NSStringFromClass([MMDidJoinGroupViewController class]) bundle:nil withGroupInfo:groupInfo];
    // 刷新列表数据
    didJoin.updateGroupInfoBlock = ^() {
        
        __weak MMGroupsTableViewController *weakSelf = self;
        [MMHTTPTOOLS getAllGroupsWithCompletion:^(NSMutableArray *result) {
            _groups = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
    };
    [self.navigationController pushViewController:didJoin animated:YES];
}

- (void)joinGroupCallback:(BOOL)result withGroupId:(NSString *)groupId {
    
    if (result) {
        
        [SVProgressHUD showSuccessWithStatus:@"加入成功" maskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        for (MMGroupInfo *group in _groups) {
            
            if ([group.groupId isEqualToString:groupId]) {
                
                if(group.number == group.maxNumber) {
                    
                    [SVProgressHUD showErrorWithStatus:@"加入失败\n人数已满" maskType:SVProgressHUDMaskTypeBlack];
                }
            }
        }
    }
    
    [MMDataSource syncGroups];
    __weak MMGroupsTableViewController *weakSelf = self;
    [MMHTTPTOOLS getAllGroupsWithCompletion:^(NSMutableArray *result) {
        _groups = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)launchGroupChatPageByGroupId:(NSString *)groupId {
    
    MMGroupInfo *groupInfo;
    for (MMGroupInfo *group in self.groups) {
        
        if ([group.groupId isEqualToString:groupId]) {
            groupInfo = group;
        }
    }
    if (groupInfo) {
        
        MMChatViewController *temp = [[MMChatViewController alloc]init];
        temp.targetId = groupInfo.groupId;
        temp.conversationType = ConversationType_GROUP;
        temp.userName = groupInfo.groupName;
        temp.title = groupInfo.groupName;
        [self.navigationController pushViewController:temp animated:YES];
    }
}

-(void) quitGroupCallback:(BOOL) result withGroupId:(NSString *)groupId
{
    if (result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"退出成功！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"加入失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    [MMDataSource syncGroups];
    
}

@end
