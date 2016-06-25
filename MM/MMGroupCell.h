//
//  MMGroupCell.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMGroupInfo;
@protocol JoinQuitGroupDelegate;

@interface MMGroupCell : UITableViewCell

@property (assign, nonatomic) id<JoinQuitGroupDelegate>delegate;

@property (nonatomic,copy) NSString *groupID;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblInstru;
@property (weak, nonatomic) IBOutlet UIImageView *imvGroupPort;
@property (weak, nonatomic) IBOutlet UIButton *btJoin;
@property (strong, nonatomic) MMGroupInfo *groupInfo;

/** 是否加入 */
@property (assign, nonatomic) BOOL isJoin;


@end

// 代理
@protocol JoinQuitGroupDelegate <NSObject>

@required

- (void)joinGroupCallback:(BOOL )result withGroupId:(NSString*)groupId;
- (void)quitGroupCallback:(BOOL )result withGroupId:(NSString*)groupId;
- (void)launchGroupChatPageByGroupId:(NSString*)groupId;

@end






