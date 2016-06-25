//
//  MMAddFriendCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAddFriendCell.h"

@interface MMAddFriendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMM;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation MMAddFriendCell

- (void)setAddFriendModel:(MMAddFriend *)addFriendModel {
    
    _addFriendModel = addFriendModel;
    // [self.imageViewMM setHeaderWithPictureName:_addFriendModel.icon]; // 这个画圆图片模糊
    [self.imageViewMM cutRadiusToCircleWithImage:addFriendModel.icon];
    self.titleLabel.text = addFriendModel.title;
    self.subTitleLabel.text = addFriendModel.subTitle;
}

@end
