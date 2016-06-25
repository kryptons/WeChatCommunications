//
//  MMHomePictureViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHomePictureViewController.h"
#import "AppDelegate.h"

@interface MMHomePictureViewController () {
    
    CGFloat radius;
}
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *backButton;

@end

@implementation MMHomePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"主页";
    radius = 50;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MMWidth, 200)];
    image.backgroundColor = [UIColor lightGrayColor];
    image.image = self.headImage;
    [self.view addSubview:image];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.center = CGPointMake(70, 200);
    self.imageView.bounds = CGRectMake(0, 0, 100, 100);
    self.imageView.image = self.headImage;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = self.imageView.width * 0.5;
    [self.view addSubview:_imageView];
    
    [self setupRightBackButton];
    
    [self expandCircle];
}

- (void)setupRightBackButton {
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [self.backButton setTitle:@"恢复" forState:UIControlStateNormal];
    self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}

- (void)backButtonClick:(UIButton *)button {
    
    button.enabled = NO;
    [self addImage];
    [self narrowCircle];
}

#pragma mark - 放大圈圈
- (void)expandCircle {
    
    CGRect rect = CGRectInset(self.imageView.frame, -600, -600);
    
    CGPathRef startPath = CGPathCreateWithEllipseInRect(rect, NULL);
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(self.imageView.frame, NULL);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = startPath;
    
    self.view.layer.mask = maskLayer;
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    expandAnimation.fromValue = (__bridge id)(endPath);
    expandAnimation.toValue   = (__bridge id)(startPath);
    expandAnimation.duration = 1;
    expandAnimation.delegate = self;
    [expandAnimation setValue:@"expand" forKey:@"expand"];
    expandAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:expandAnimation forKey:@"expandCircle"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);
}

#pragma mark - 缩小圈圈
- (void)narrowCircle {
    
    CGRect rect = CGRectInset(self.imageView.frame, -600, -600);
    
    CGPathRef startPath = CGPathCreateWithEllipseInRect(rect, NULL);
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(self.imageView.frame, NULL);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = endPath;
    
    self.view.layer.mask = maskLayer;
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    narrowAnimation.fromValue = (__bridge id)(startPath);
    narrowAnimation.toValue   = (__bridge id)(endPath);
    narrowAnimation.duration = 1;
    narrowAnimation.delegate = self;
    [narrowAnimation setValue:@"narrow" forKey:@"narrow"];
    narrowAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:narrowAnimation forKey:@"narrowCircle"];
    
    CGPathRelease(startPath);
    CGPathRelease(endPath);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"expand"] isEqualToString:@"expand"]) {
        
        [self removeImage];
    }
    else if ([[anim valueForKey:@"narrow"] isEqualToString:@"narrow"]) {
        
        [self animation];
    }
}

#pragma mark - 去掉照片
- (void)removeImage {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.imageView removeFromSuperview];
}

#pragma mark - 添加照片
- (void)addImage {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:delegate.imageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    imageView.image = delegate.imageView.image;
    imageView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - 返回时动画
- (void)animation {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIImageView *imageView = delegate.imageView;
    
    NSArray *vcArr = self.navigationController.viewControllers;
    UIViewController *vc = vcArr[vcArr.count - 2];
    vc.view.alpha = 0;
    [delegate.window addSubview:vc.view];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            imageView.bounds = CGRectMake(0, 0, 110, 110);
            imageView.layer.shadowOffset = CGSizeMake(4, 4);
            imageView.layer.shadowRadius = 30;
            imageView.layer.shadowColor  = [UIColor blackColor].CGColor;
            imageView.layer.shadowOpacity = 0.8;
            imageView.center = delegate.pushCenter;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                imageView.bounds = CGRectMake(0, 0, 100, 100);
                vc.view.alpha = 1;
            } completion:^(BOOL finished) {
                
                imageView.layer.shadowOffset = CGSizeMake(0, 0);
                imageView.layer.shadowRadius = 0;
                imageView.layer.shadowColor  = [UIColor clearColor].CGColor;
                [delegate.imageView removeFromSuperview];
                [self performSelector:@selector(goToNextViewController:) withObject:vc afterDelay:0.25];
            }];
        }];
    }];
}

-(void)goToNextViewController:(UIViewController *)ViewController
{
    
    [self.navigationController popViewControllerAnimated:NO];
}
@end
