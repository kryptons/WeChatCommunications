//
//  MMConversationListViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMConversationListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MMConversationListViewController ()

/** 强引用右上角按钮 */
@property (strong, nonatomic) UIButton *rightBarButton;

@property (strong, nonatomic) UIButton *leftBarButton;

@property (nonatomic,strong) RCConversationModel *tempModel;

- (void) updateBadgeValueForTabBarItem;

@end

@implementation MMConversationListViewController

#pragma mark - 设置显示的会话类型
// 如果不写在初始化里面会导致第一次进入会话列表时是空的
- (instancetype)init {
    
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"会话";
    self.view.backgroundColor = MMRandomColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置tableview样式
    self.conversationListTableView.separatorColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
    self.conversationListTableView.tableFooterView = [UIView new];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    _isClick = YES;
    [self setupRightBarButtonItem];
    
    // 设置未读消息
    [self notifyUpdateUnreadMessageCount];
    // 刷新讨论组消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNeedRefreshNotification:) name:@"kRCNeedReloadDiscussionListNotification" object:nil];
}

#pragma mark - 点击cell进入聊天页面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    if (_isClick) {
        
        _isClick = NO;
        if (model.conversationType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
            
            MMChatViewController *chatVC = [[MMChatViewController alloc] init];
            chatVC.conversationType = model.conversationType;
            chatVC.targetId = model.targetId;
            // chatVC.userName = model.conversationTitle;
            chatVC.title = model.conversationTitle;
            chatVC.conversation = model;
            chatVC.unReadMessage = model.unreadMessageCount;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
        
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
            
            MMChatViewController *chatVC = [[MMChatViewController alloc] init];
            chatVC.conversationType = model.conversationType;
            chatVC.targetId = model.targetId;
            // chatVC.userName = model.conversationTitle;
            chatVC.title = model.conversationTitle;
            chatVC.conversation = model;
            chatVC.unReadMessage = model.unreadMessageCount;
            chatVC.enableNewComingMessageIcon = YES; // 开启消息提醒
            chatVC.enableUnreadMessageIcon = YES;
            if (model.conversationModelType == ConversationType_SYSTEM) {
                
                chatVC.title = @"系统消息";
            }
            [self.navigationController pushViewController:chatVC animated:YES];
        }
        
        // 聚合会话类型
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
            
            MMConversationListViewController *chatList = [[MMConversationListViewController alloc] init];
            NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
            [chatList setDisplayConversationTypes:array];
            [chatList setCollectionConversationType:nil];
            chatList.isEnteredToCollectionViewController = YES;
            [self.navigationController pushViewController:chatList animated:YES];
        }
        // 自定义会话类型
        if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
            
            RCConversationModel *model = self.conversationListDataSource[indexPath.row];
            MMAgreeAddFriendTableViewController *agreeAddFriend = [[MMAgreeAddFriendTableViewController alloc] initWithNibName:nil bundle:nil withConversationModel:model];
            agreeAddFriend.conversationType = model.conversationType;
            agreeAddFriend.targetId = model.targetId;
            agreeAddFriend.userName = model.conversationTitle;
            agreeAddFriend.title = model.conversationTitle;
            [self.navigationController pushViewController:agreeAddFriend animated:YES];
        }
    }
}

/*********************conversationListDataSource*********************/
#pragma mark - 插入自定义会话Model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
    for (int i = 0; i < dataSource.count; i++) {
        
        RCConversationModel *model = dataSource[i];
        // 筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    return dataSource;
}

#pragma mark - 左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

#pragma mark - cell的高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 67.0f;
}

#pragma mark - 自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    
    __weak MMConversationListViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            if (_contactNotificationMsg.sourceUserId == nil) {
                
                MMChatListCell *cell = [[MMChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.lblDetail.text = @"好友请求";
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
                return cell;
                
            }
            NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
            if (_cache_userinfo) {
                userName = _cache_userinfo[@"username"];
                portraitUri = _cache_userinfo[@"portraitUri"];
            } else {
                NSDictionary *emptyDic = @{};
                [[NSUserDefaults standardUserDefaults]setObject:emptyDic forKey:_contactNotificationMsg.sourceUserId];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [MMHTTPTOOLS getUserInfoWithUserID:_contactNotificationMsg.sourceUserId
                                      completion:^(RCUserInfo *user) {
                                          if (user == nil) {
                                              return;
                                          }
                                          MMUserInfo *rcduserinfo_ = [[MMUserInfo alloc] init];
                                          rcduserinfo_.name = user.name;
                                          rcduserinfo_.userId = user.userId;
                                          rcduserinfo_.portraitUri = user.portraitUri;
                                          
                                          model.extend = rcduserinfo_;
                                          
                                          //local cache for userInfo
                                          NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                                                        @"portraitUri":rcduserinfo_.portraitUri
                                                                        };
                                          [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                          
                                          [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                      }];
            }
        }
        
    }else{
        MMUserInfo *user = (MMUserInfo *)model.extend;
        userName    = user.name;
        portraitUri = user.portraitUri;
    }
    
    MMChatListCell *cell = [[MMChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [self ConvertMessageTime:model.sentTime / 1000];
    cell.model = model;
    return cell;
}

#pragma mark - 时间戳转换
- (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    
    return timeText;
}

/*********************刷新消息**************************/
#pragma mark - 设置不断刷新讨论组消息
- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    
    __weak typeof(&*self) __blockSelf = self;
    if (__blockSelf.displayConversationTypeArray.count == 1 && [__blockSelf.displayConversationTypeArray[0] integerValue] == ConversationType_DISCUSSION) {
        
        [__blockSelf refreshConversationTableViewIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRCNeedReloadDiscussionListNotification" object:nil];
}
//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.showConnectingStatusOnNavigatorBar = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRCNeedReloadDiscussionListNotification" object:nil];
}

#pragma mark - 设置未读消息
- (void)notifyUpdateUnreadMessageCount {
    
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem {
    
    __weak typeof(self) __weakSelf = self;
    // 异步读取
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            
            __weakSelf.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
        }
        else {
            
            __weakSelf.tabBarItem.badgeValue = nil;
        }
    });
}

/******************************************************/
#pragma mark - 自定义rightBarButtonItem
- (void)setupRightBarButtonItem {
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
    self.rightBarButton = rightButton;
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    [rightButton setImage:[UIImage imageNamed:@"barbuttonicon_add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightButtonClick:(UIButton *)sender {
    
    NSArray *menuItems = @[
                           
                           [JWMenuItem menuItem:@"发起聊天"
                                          image:[[UIImage imageNamed:@"chat_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     titleColor:[UIColor whiteColor]
                                         target:self
                                         action:@selector(pushChat:)],
                           [JWMenuItem menuItem:@"添加朋友"
                                          image:[[UIImage imageNamed:@"addfriend_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     titleColor:[UIColor whiteColor]
                                         target:self
                                         action:@selector(pushAddFriend:)],
                           [JWMenuItem menuItem:@"通讯录"
                                          image:[[UIImage imageNamed:@"contact_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     titleColor:[UIColor whiteColor]
                                         target:self
                                         action:@selector(pushAddressBook:)],
                           [JWMenuItem menuItem:@"公众账号"
                                          image:[[UIImage imageNamed:@"public_account"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     titleColor:[UIColor whiteColor]
                                         target:self
                                         action:@selector(pushPublicService:)],
                           [JWMenuItem menuItem:@"添加公众号"
                                          image:[[UIImage imageNamed:@"add_public_account"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     titleColor:[UIColor whiteColor]
                                         target:self
                                         action:@selector(pushAddPublicService:)],
                           ];
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.x = MMWidth - 24;
    targetFrame.origin.y = targetFrame.origin.y + 48;
    [JWMenu showMenuInView:self.navigationController.view fromRect:targetFrame menuItems:menuItems viewBackgroundColor:@"2AB928"]; // 绿色
}

- (void)pushChat:(UIButton *)sender {
    
    [self dismissPop:@"发起聊天暂时没实现"];
}

- (void)pushAddFriend:(UIButton *)sender {
    
    MMSearchFriendViewController *search = [[MMSearchFriendViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)pushAddressBook:(UIButton *)sender {
    
    [self dismissPop:@"通讯录暂时没实现"];
}

- (void)pushPublicService:(UIButton *)sender {
    
    [self dismissPop:@"公众账号暂时没实现"];
}

- (void)pushAddPublicService:(UIButton *)sender {
    
    MMAddPublicViewController *addFriends = [[MMAddPublicViewController alloc] init];
    [self.navigationController pushViewController:addFriends animated:NO];
}

- (void)dismissPop:(NSString *)message {
    
    [SVProgressHUD showInfoWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
    [UIView animateWithDuration:2.5 animations:^{
        [SVProgressHUD dismiss];
    }];
}


@end
