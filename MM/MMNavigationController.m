//
//  MMNavigationController.m
//  MM
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMNavigationController.h"

@interface MMNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation MMNavigationController


// 第一次使用这个类只调用一次
+ (void)initialize {
    
    // UINavigationBar(全局设置)
    UINavigationBar *bar = [UINavigationBar appearance];
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7)
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg_6"] forBarMetrics:UIBarMetricsDefault];
        
    }
    else
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:attr];
    // UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *normal = [NSMutableDictionary dictionary];
    normal[NSForegroundColorAttributeName] = [UIColor blackColor];
    normal[NSFontAttributeName] = [UIFont systemFontOfSize:15]; // 取消粗体
    [item setTitleTextAttributes:normal forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *disable = [NSMutableDictionary dictionary];
    disable[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disable forState:UIControlStateDisabled];
    // UIControlStateHighlighted
    NSMutableDictionary *high = [NSMutableDictionary dictionary];
    high[NSForegroundColorAttributeName] = [UIColor greenColor];
    high[NSFontAttributeName] = [UIFont systemFontOfSize:15];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 通过设置导航控制的代理，设置手势的代理为导航控制器告诉手势要好使
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  每当触发返回手势时都会调用一次这个方法
 *  返回值为YES手势有效，NO为失效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 如果当前消失的是第一个子控制器，就应该禁止掉[返回手势]
    return self.childViewControllers.count > 1;
}

/**
 *  拦截所有push进来的子控制器
 *  @param viewController 是每次push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count >= 1) {
        
        // 左角返回
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        // 设置自定义的控件的内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backClick {
    
    [self popViewControllerAnimated:YES];
}

#pragma mark - 设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return UIStatusBarStyleLightContent;
}

@end
