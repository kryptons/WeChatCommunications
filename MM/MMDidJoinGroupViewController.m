//
//  MMDidJoinGroupViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMDidJoinGroupViewController.h"

@interface MMDidJoinGroupViewController () <UIActionSheetDelegate>
{
    MMGroupInfo *_groupInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgGroupPortait;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberInGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblMyNickNameInGroup;
@property (weak, nonatomic) IBOutlet UISwitch *swMessageNotDistrub;
@property (weak, nonatomic) IBOutlet UISwitch *swConversationTop;
@property (weak, nonatomic) IBOutlet UIButton *btClearMessage;

@property (weak, nonatomic) IBOutlet UIView *HiddenView;

@property (weak, nonatomic) IBOutlet UIButton *beginToChat;

@property (weak, nonatomic) IBOutlet UIButton *deleteAndQuit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatToConstrait;
@end

@implementation MMDidJoinGroupViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withGroupInfo:(MMGroupInfo *)groupInfo {
    
    if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _groupInfo = groupInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    [self showGrouInfo];
}

#pragma mark - 显示群组详细信息
- (void)showGrouInfo {
    
    self.imgGroupPortait.layer.masksToBounds = YES;
    self.imgGroupPortait.layer.cornerRadius = 5.0f;
    self.lblGroupName.text = _groupInfo.groupName;
    self.lblNumberInGroup.text = [NSString stringWithFormat:@"%@/%@", _groupInfo.number.length == 0 ? @"1000" : _groupInfo.number, _groupInfo.maxNumber.length == 0 ? @"1000" : _groupInfo.maxNumber];
    if (_groupInfo.isJoin) {
        
        self.imgGroupPortait.image = [[UIImage imageNamed:@"chatroom_icon_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        
        self.imgGroupPortait.image = [[UIImage imageNamed:@"chatroom_icon_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.HiddenView.hidden = YES;
        [self.beginToChat setTitle:@"加入群组" forState:UIControlStateNormal];
        self.deleteAndQuit.hidden = YES;
        self.chatToConstrait.constant = 40;
    }
    // 会话置顶
    [self.swConversationTop setOn:NO];
    RCConversation *conversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
                                          targetId:_groupInfo.groupId];
    if (conversation) {
        if (conversation.isTop) {
            [self.swConversationTop setOn:YES];
        }
    }
    //消息免打扰状态
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP
     targetId:_groupInfo.groupId success:^(RCConversationNotificationStatus nStatus) {
         
         BOOL enableNotification = NO;
         if (nStatus == NOTIFY) {
             enableNotification = YES;
         }
         [self.swMessageNotDistrub setOn:enableNotification];
         
     }
     error:^(RCErrorCode status){
         
     }];
}

#pragma mark - 进入聊天
- (IBAction)beginToChat:(id)sender {
    
    if (_groupInfo.isJoin) {
        
        NSUInteger count = self.navigationController.viewControllers.count;
        if (count > 1) {
            UIViewController *preVC = self.navigationController.viewControllers[count - 2];
            if ([preVC isKindOfClass:[RCConversationViewController class]]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            } else {
                
                MMChatViewController *temp = [[MMChatViewController alloc] init];
                temp.targetId = _groupInfo.groupId;
                temp.conversationType = ConversationType_GROUP;
                temp.userName = _groupInfo.groupName;
                temp.title = _groupInfo.groupName;
                [self.navigationController pushViewController:temp animated:YES];
            }
        } else {
            
            MMChatViewController *temp = [[MMChatViewController alloc] init];
            temp.targetId = _groupInfo.groupId;
            temp.conversationType = ConversationType_GROUP;
            temp.userName = _groupInfo.groupName;
            temp.title = _groupInfo.groupName;
            [self.navigationController pushViewController:temp animated:YES];
        }
    }
    else {
        
        // 加入群组
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定加入群组?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionComfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            int groupId = [_groupInfo.groupId intValue];
            NSString *groupName = self.lblGroupName.text;
            [MMHTTPTOOLS joinGroupWithGroupID:groupId withGroupName:groupName complete:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (result) {
                        
                        _groupInfo.isJoin = YES;
                        [MMDataSource syncGroups];
                        self.imgGroupPortait.image = [[UIImage imageNamed:@"chatroom_icon_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        self.HiddenView.hidden = NO;
                        [self.beginToChat setTitle:@"发起会话" forState:UIControlStateNormal];
                        self.deleteAndQuit.hidden = NO;
                        self.chatToConstrait.constant = 140;
                        [SVProgressHUD showSuccessWithStatus:@"成功加入群组" maskType:SVProgressHUDMaskTypeBlack];
                    }
                    else {
                        
                        [SVProgressHUD showErrorWithStatus:@"加入失败\n群组人数已满" maskType:SVProgressHUDMaskTypeBlack];
                    }
                });
            }];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionComfirm];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 退出群组
- (IBAction)deleteAndQuitGroup:(id)sender {
    
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"确定退出群组？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"确定"
                       otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - 消息免提
- (IBAction)setIsMessageDistruble:(id)sender {
    
    UISwitch *isDistruble = (UISwitch *)sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:_groupInfo.groupId isBlocked:~!!isDistruble.isOn success:^(RCConversationNotificationStatus nStatus) {
        
        NSLog(@"消息免提");
    } error:^(RCErrorCode status) {
        NSLog(@"status = %zd", status);
    }];
}

#pragma mark - 会话置顶
- (IBAction)setConversationTop:(id)sender {
    
    UISwitch *isTop = (UISwitch *)sender;
    RCConversation *conversation =
    [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
                                          targetId:_groupInfo.groupId];
    if (conversation) {
        [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP
                                                   targetId:_groupInfo.groupId
                                                      isTop:isTop.isOn];
    }
}

#pragma mark - 清除聊天记录
- (IBAction)clearChatMessage:(id)sender {
    
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"确定删除聊天记录？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"确定"
                       otherButtonTitles:nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    int groupId = [_groupInfo.groupId intValue];
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            BOOL isClear =
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP
                                                targetId:_groupInfo.groupId];
            //清除消息之后回调操作，例如reload 会话列表
            if (self.clearHistoryCompletion) {
                self.clearHistoryCompletion(isClear);
            }
        }
    } else {
        
        if (buttonIndex == 0) {
            
            [MMHTTPTOOLS quitGroupWithGroupID:groupId complete:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (result) {
                        
                        _groupInfo.isJoin = NO;
                        [MMDataSource syncGroups];
                        self.imgGroupPortait.image = [[UIImage imageNamed:@"chatroom_icon_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        self.HiddenView.hidden = YES;
                        [self.beginToChat setTitle:@"加入群组" forState:UIControlStateNormal];
                        self.deleteAndQuit.hidden = YES;
                        self.chatToConstrait.constant = 40;
                        if (self.updateGroupInfoBlock) {
                            self.updateGroupInfoBlock();
                        }
                        [SVProgressHUD showSuccessWithStatus:@"退出成功" maskType:SVProgressHUDMaskTypeBlack];
                    } else {
                        
                        [SVProgressHUD showErrorWithStatus:@"退出失败" maskType:SVProgressHUDMaskTypeBlack];
                    }
                });
            }];
        }
    }
}




@end
