//
//  MMAgreeAddFriendTableViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAgreeAddFriendTableViewController.h"

@interface MMAgreeAddFriendTableViewController () <UITableViewDelegate, UITableViewDataSource>
{
    RCConversationModel *_model;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *friends;

@end

@implementation MMAgreeAddFriendTableViewController

static NSString *const cellID = @"agreeFriend";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConversationModel:(RCConversationModel *)model {
    
    if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    self.friends = [[[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationType targetId:self.targetId count:30] mutableCopy];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMAgreeFriendCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __block MMAgreeAddFriendTableViewController *weakSelf = self;
    [self.friends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        RCMessage *message = obj;
        if (![message.content isKindOfClass:[RCContactNotificationMessage class]]) {
            
            [weakSelf.friends removeObject:obj];
        }
        else if (![((RCContactNotificationMessage *)message.content).operation isEqualToString:ContactNotificationMessage_ContactOperationRequest]) {
            
            [weakSelf.friends removeObject:obj];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friends.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMAgreeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.message = self.friends[indexPath.row];
    
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        RCMessage *message = self.friends[indexPath.row];
        if ([[RCIMClient sharedRCIMClient] deleteMessages:@[[NSNumber numberWithLong:message.messageId]]]) {
            
            [self.friends removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            
            [SVProgressHUD showErrorWithStatus:@"删除失败" maskType:SVProgressHUDMaskTypeBlack];
        }
        if (0 == self.friends.count) {
            
            // 删除会话列表
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:self.targetId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RCMessage *message = self.friends[indexPath.row];
    
    RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
    if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
        return;
    }
    [MMAFHttpTool requestAgreeToAddFriendWithUserID:_contactNotificationMsg.sourceUserId withIsAccess:YES success:^(id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[RCIMClient sharedRCIMClient] deleteMessages:@[[NSNumber numberWithLong:message.messageId]]]) {
                
                [self.friends removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:@"添加失败" maskType:SVProgressHUDMaskTypeBlack];
            }
            
        });
    } failure:^(NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"添加失败" maskType:SVProgressHUDMaskTypeBlack];
        });
    }];
}




@end
