//
//  MyCollectionViewCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MyCollectionViewCell.h"

#define CollectionViewWidth (MMWidth - 2 * MMMargin) / 3

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CollectionViewWidth, CollectionViewWidth)];
        [self addSubview:self.imageView];
    }
    return self;
}


@end
