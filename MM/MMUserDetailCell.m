//
//  MMUserDetailCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMUserDetailCell.h"

#define CellFrameWidth self.frame.size.width
#define CellFrameHeight self.frame.size.height

@interface MMUserDetailCell()

@property (strong, nonatomic) UILabel *lblUserName;
@property (strong, nonatomic) UILabel *lblUserID;
@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation MMUserDetailCell

#pragma mark - lazy
- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 8.0f;
    }
    return _iconImageView;
}

- (UILabel *)lblUserName {
    
    if (!_lblUserName) {
        
        _lblUserName = [[UILabel alloc] init];
        [_lblUserName setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _lblUserName;
}

- (UILabel *)lblUserID {
    
    if (!_lblUserID) {
        
        _lblUserID = [[UILabel alloc] init];
        [_lblUserID setFont:[UIFont systemFontOfSize:14.0f]];
        [_lblUserID setTextColor:[UIColor grayColor]];
    }
    return _lblUserID;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.lblUserName];
        [self addSubview:self.lblUserID];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews]; // 没写的话会出现UITableViewCellSeparatorView(一条横线)
    // 头像
    float iconW = 64.0f;
    float iconH = iconW;
    float iconX = (CellFrameHeight - iconH) * 0.5;
    float iconY = iconX;
    [self.iconImageView setFrame:CGRectMake(iconX, iconY, iconW, iconH)];
    
    // 用户名
    float userX = iconW + iconX * 2;
    float userY = iconY;
    float userW = CellFrameWidth - userX - iconX * 3;
    float userH = iconH * 0.4;
    [_lblUserName setFrame:CGRectMake(userX, userY, userW, userH)];
    
    // MM号
    float idX = userX;
    float idW = userW;
    float idH = userH;
    float idY = CGRectGetMaxY(self.iconImageView.frame) - idH;
    [_lblUserID setFrame:CGRectMake(idX, idY, idW, idH)];
}

- (void)setUserInfo:(RCUserInfo *)userInfo {
    
    _userInfo = userInfo;
    // 设置头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[[UIImage imageNamed:@"publish-gst"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    // 昵称
    if (userInfo.name && userInfo.name.length > 0) {
        
        [self.lblUserName setText:userInfo.name];
    }
    else {
        
        [self.lblUserName setText:@""];
    }
    
    if (userInfo.userId && userInfo.userId.length > 0) {
        
        [self.lblUserID setText:[NSString stringWithFormat:@"MM号:%@", userInfo.userId]];
    }
    
}

@end
