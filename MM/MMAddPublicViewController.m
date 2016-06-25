//
//  MMAddFriendsViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAddPublicViewController.h"

@interface MMAddPublicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *addFriends;

@end

@implementation MMAddPublicViewController

#pragma mark - lazy
- (NSArray *)addFriends {
    
    if (!_addFriends) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"addFriend.plist" ofType:nil];
        NSArray *friends = [NSArray arrayWithContentsOfFile:path]; // 将plist文件的字典存在数组中
        NSMutableArray *friendM = [NSMutableArray arrayWithCapacity:friends.count];
        for (NSDictionary *dict in friends) {
            
            MMAddFriend *addFriend = [MMAddFriend mmAddriendWithDictionary:dict];
            [friendM addObject:addFriend];
        }
        _addFriends = [friendM copy];
    }
    return _addFriends;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加公众号";
    [self setupTableView];
}

static NSString *const cellID = @"MMAddFriendCell";
#pragma mark - 创建tableView
- (void)setupTableView {
    
    self.tableView.rowHeight = 60;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 去掉cell自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册,缓存池没有就加载xib的cell(注意要再xib设置循环标识)
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMAddFriendCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addFriendModel = self.addFriends[indexPath.row];
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMAddFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *message = [cell.addFriendModel.title stringByAppendingString:@"\n功能暂时没实现"];
    [SVProgressHUD showInfoWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
    [UIView animateWithDuration:2.5 animations:^{
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
