//
//  UIImageView+JWExtension.m
//  百思不得姐
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "UIImageView+JWExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (JWExtension)

#pragma mark - 实现传图片的URL
- (void)setHeaderURLWithString:(NSString *)url placeholderWithName:(NSString *)name {
    
    [self setPlaceHolderUrlWithString:url headerWithName:name];
}

/**
 *  私有方法
 */
- (void)setPlaceHolderUrlWithString:(NSString *)url headerWithName:(NSString *)name {
    
    UIImage *placeHolder = [UIImage circleImageWithName:name];
    [self setHeaderWithPlaceHolder:placeHolder urlWithString:url];
}

- (void)setHeaderWithPlaceHolder:(UIImage *)placeHolder urlWithString:(NSString *)url {
    
    // 什么时候调用completed这个block呢？
    // 图片下载完成时就会调用
    MMWeakSelf;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 如果图片下载失败，不做任何处理，按照默认的做法显示占位图片
        if(image == nil) return;
        weakSelf.image = image.circleImage;
    }];

}

#pragma mark - 实现图片名
- (void)setHeaderWithPictureName:(NSString *)pictureName {
    
    self.image = [UIImage circleImageWithName:pictureName];
}

- (void)cutRadiusToCircleWithImage:(NSString *)image {
    
    self.layer.cornerRadius = self.width * 0.5;
    self.layer.masksToBounds = YES;
    self.image = [UIImage imageNamed:image];
}

@end
