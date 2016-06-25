//
//  MMBubbleAnimationViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMBubbleAnimationViewController.h"
#import "MMBubbleButton.h"
#import "MMMouseTouch.h"

#define BubbleButtonHeight 40

#define NavHeight          64

#define ButtonWidth        60.0

#define ButtonHeight       35.0

#define IMAGE_PER_WIDTH    200.0

#define IMAGE_PER_HEIGIT   300.0

@interface MMBubbleAnimationViewController ()

@property (strong, nonatomic) MMBubbleButton *bubbleButton;

@property (strong, nonatomic) UIButton *loadingButton;

@property (strong, nonatomic) UIButton *exchangeButton;

@property (strong, nonatomic) UIButton *recoveryButton;

@property (strong, nonatomic)  UIButton *rightHiddenButton;

@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UIImageView *imageView3D;

@end

@implementation MMBubbleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"动画";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    // 点击圆圈动画
    [self.view addSubview:[MMMouseTouch viewWithCicle:self.view.frame]];
    
    // bubble动图
    [self setupBubbleButton];
    // 创建加载图片button
    [self setupLoadingButton];
    // 创建隐藏button
}


#pragma mark - 创建加载图片的button
- (void)setupLoadingButton {
    
    self.loadingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ButtonWidth, ButtonHeight)];
    [self.loadingButton setTitle:@"加载图片" forState:UIControlStateNormal];
    self.loadingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    self.loadingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.loadingButton addTarget:self action:@selector(setupExchangeAndRecoveryButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadingButton];
}

#pragma mark - 创建3D旋转和复原button
- (void)setupExchangeAndRecoveryButton {
    
    self.loadingButton.hidden = YES;
    self.exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(MMWidth * 0.5 - ButtonWidth - 10, 10, ButtonWidth, ButtonHeight)];
    self.recoveryButton = [[UIButton alloc] initWithFrame:CGRectMake(MMWidth * 0.5 + 10, 10, ButtonWidth, ButtonHeight)];
    [self.view addSubview:self.exchangeButton];
    [self.view addSubview:self.recoveryButton];
    self.exchangeButton.layer.masksToBounds = YES;
    self.recoveryButton.layer.masksToBounds = YES;
    self.exchangeButton.layer.cornerRadius  = 8;
    self.recoveryButton.layer.cornerRadius  = 8;
    self.exchangeButton.backgroundColor = [UIColor orangeColor];
    self.recoveryButton.backgroundColor = [UIColor blueColor];
    [self.exchangeButton setTitle:@"3D旋转" forState:UIControlStateNormal];
    [self.recoveryButton setTitle:@"复原" forState:UIControlStateNormal];
    self.exchangeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.recoveryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.exchangeButton addTarget:self action:@selector(exchangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.recoveryButton addTarget:self action:@selector(recoveryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 加载图片
    [self loadingPictureTo3D];
    
    // 创建隐藏button
    [self setupHiddenButton];
}

#pragma mark - 执行3D动效
// 动效是否执行中
static bool isFolding = NO;
- (void)exchangeButtonClick:(UIButton *)button {
    
    isFolding = YES;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
       
        // 折叠
        [self.backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = obj;
            imageView.layer.transform = [self config3DTransformWithRotateAngle:[self getRandomNumber:0 to:360]
                                                                  andPositionX:[self getRandomNumber:0 to:100]
                                                                  andPositionY:[self getRandomNumber:0 to:300]];
        }];
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            isFolding = NO;
        }
    }];
}

- (void)recoveryButtonClick:(UIButton *)button {
    
    /*
     delay延迟多久调用完成finished
     动画效果usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
     initialSpringVelocity（默认0）则表示初始的速度，数值越大一开始移动越快，值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况http://www.renfei.org/blog/ios-8-spring-animation.html
     */
    value = 0;
    isFolding = NO;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:00 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = obj;
            imageView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            isFolding = NO;
        }
    }];

}

- (CATransform3D)config3DTransformWithRotateAngle:(double)angle andPositionX:(double)x andPositionY:(double)y {
    
    /*
     旋转 CATransform3DRotate (CATransform3D t, CGFloat angle,CGFloat x, CGFloat y, CGFloat z) angle旋转弧度：角度 * M_PI / 180，
     x值范围-1 --- 1之间 正数表示左侧看向外旋转，负数表示向里CATransform3DRotate(transform, M_PI*angle/180, 1, 0, 0）图1
     y值范围-1 --- 1之间 正数左侧看表示向外旋转，负数表示向里CATransform3DRotate(transform, M_PI*angle/180, 0, 1, 0）图2
     同时设置x，y表示沿着对角线翻转
     CATransform3DRotate(transform, M_PI*angle/180, 1, 1, 0）图3
     z值范围-1 --- 1之间 正数逆时针旋转，负数表示顺CATransform3DRotate(transform, M_PI*angle/180, 0, 0, -1）图4
     同时设置x,y,z按照设定的数值进行旋转
     CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 1, 1, 1);图5
     */
    
    CATransform3D transform = CATransform3DIdentity;
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI * angle / 180, 1.0, 1.0, 1.0);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    CATransform3D moveImage = CATransform3DMakeTranslation(x, y, 0);
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, moveImage);
    return concatTransform;
}

- (CGFloat)getRandomNumber:(int)from to:(int)to {
    
    return (from + 1 + (arc4random() % (to - from + 1)));
}

#pragma mark - 创建隐藏button
- (void)setupHiddenButton {
    
    self.rightHiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ButtonWidth, ButtonHeight)];
    [self.rightHiddenButton setTitle:@"隐藏" forState:UIControlStateNormal];
    self.rightHiddenButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    self.rightHiddenButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.rightHiddenButton addTarget:self action:@selector(rightHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightHiddenButton];
}

- (void)rightHiddenButtonClick:(UIButton *)button {
    
    self.recoveryButton.hidden = YES;
    self.exchangeButton.hidden = YES;
    self.backView.hidden       = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - 加载图片
CGFloat value = 0;
- (void)loadingPictureTo3D {
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake((MMWidth - IMAGE_PER_WIDTH) * 0.5, 80, IMAGE_PER_WIDTH, IMAGE_PER_HEIGIT)];
    [self.view addSubview:self.backView];
    NSArray *imageUrls = @[@"http://box.dwstatic.com/skin/Irelia/Irelia_0.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_1.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_2.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_3.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_4.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_5.jpg"];
    NSInteger index = arc4random() % imageUrls.count; // 取余
    NSString *url = imageUrls[index];
    
    CGFloat ratio = 0.25;
    for (int i = 0; i < 4; i++) {
        
        self.imageView3D = [[UIImageView alloc] init];
        [self.imageView3D sd_setImageWithURL:[NSURL URLWithString:url]];
        
        self.imageView3D.layer.contentsRect = CGRectMake(ratio * i, 0, ratio, 0.5);
        self.imageView3D.frame = CGRectMake(IMAGE_PER_WIDTH * ratio * i, 0, IMAGE_PER_WIDTH * ratio, IMAGE_PER_HEIGIT * 0.5);
        if (i == 0) {
            
            self.imageView3D.layer.contentsRect = CGRectMake(0, 0, ratio, 0.5);
            self.imageView3D.frame = CGRectMake(0, 0, IMAGE_PER_WIDTH * ratio, IMAGE_PER_HEIGIT * 0.5);
        }
        [self.backView addSubview:self.imageView3D];
    }
    
    for (int i = 0; i < 4; i++) {
        
        self.imageView3D = [[UIImageView alloc] init];
        [self.imageView3D sd_setImageWithURL:[NSURL URLWithString:url]];
        
        self.imageView3D.layer.contentsRect = CGRectMake(ratio * i, 0.5, ratio, 0.5);
        self.imageView3D.frame = CGRectMake(IMAGE_PER_WIDTH * ratio * i, 0.5 * IMAGE_PER_HEIGIT, IMAGE_PER_WIDTH * ratio, IMAGE_PER_HEIGIT * 0.5);
        if (i == 0) {
            
            self.imageView3D.layer.contentsRect = CGRectMake(0, 0.5, ratio, 0.5);
            self.imageView3D.frame = CGRectMake(0, 0.5 * IMAGE_PER_HEIGIT, IMAGE_PER_WIDTH * ratio, IMAGE_PER_HEIGIT * 0.5);
        }
        [self.backView addSubview:self.imageView3D];
    }
}


- (void)setupBubbleButton {
    
    self.bubbleButton = [[MMBubbleButton alloc] initWithFrame:CGRectMake((MMWidth - BubbleButtonHeight) * 0.5, MMHeight - BubbleButtonHeight - NavHeight, BubbleButtonHeight, BubbleButtonHeight)];
    [self.bubbleButton addTarget:self action:@selector(bubbleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleButton setImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.view addSubview:self.bubbleButton];
    
    self.bubbleButton.maxLeft = MMWidth * 0.5;
    self.bubbleButton.maxRight = MMWidth * 0.5;
    self.bubbleButton.maxHeight = MMHeight;
    self.bubbleButton.duration = 30;
    self.bubbleButton.images = @[[UIImage imageNamed:@"animationRed"], [UIImage imageNamed:@"animationGray"], [UIImage imageNamed:@"animationGreen"], [UIImage imageNamed:@"animationBlue"]];
}

#pragma mark - 显示动画
- (void)bubbleButtonClick:(UIButton *)button {
    
    [self.bubbleButton generateBubbleInRandom];
}

@end
