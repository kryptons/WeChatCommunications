//
//  MMBubbleButton.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBubbleButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame
                      maxLeft:(CGFloat)maxLeft
                     maxRight:(CGFloat)maxRight
                    maxHeight:(CGFloat)maxHeight;

@property (assign, nonatomic) CGFloat maxLeft;
@property (assign, nonatomic) CGFloat maxRight;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSArray *images;

- (void)generateBubbleWithImage:(UIImage *)image;

// you have to set images first.
- (void)generateBubbleInRandom;

@end
