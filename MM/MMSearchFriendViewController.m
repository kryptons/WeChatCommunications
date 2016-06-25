//
//  MMSearchFriendViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSearchFriendViewController.h"

#define topConstant 20

@interface MMSearchFriendViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>

/** 搜索所有好友 */
@property (strong, nonatomic) NSMutableArray *friends;
/** UISearchBar顶部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;

@end

@implementation MMSearchFriendViewController

#pragma mark - lazy
- (NSMutableArray *)friends {
    
    if (!_friends) {
        
        _friends = [NSMutableArray array];
    }
    return _friends;
}

static NSString *const friendCell = @"MMFriendCell";
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"查找好友";
    // 注册
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMFriendCell class]) bundle:nil] forCellReuseIdentifier:friendCell];
    // 去掉分割线
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return self.friends.count;
    }
    return 0;
}
// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return 60.f;
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCell];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        cell.user = self.friends[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCUserInfo *userInfo = self.friends[indexPath.row]; // 选中好友数据
    // 添加好友
    MMAddFriendViewController *addFriend = [[MMAddFriendViewController alloc] initWithNibName:@"MMAddFriendViewController" bundle:nil withUserInfo:userInfo];
    [self.navigationController pushViewController:addFriend animated:YES];
}

#pragma mark - <UISearchBarDelegate>
/**
 *  执行delegate搜索好友
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.friends removeAllObjects];
    if (searchText.length) {
        
        [MMHTTPTOOLS searchFriendListByName:searchText complete:^(NSMutableArray *result) {
            
            if (result) {
                
                [self.friends addObjectsFromArray:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            }
        }];
    }
    else {
        
        NSLog(@"ddd");
    }
}

#pragma mark - <UISearchDisplayDelegate>
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    self.searchBarTopConstraint.constant = topConstant;
    [self.view layoutIfNeeded]; // 刷新约束
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    self.searchBarTopConstraint.constant = 0;
    [self.view layoutIfNeeded]; // 刷新约束
}


@end
