//
//  MMTabBarController.m
//  MM
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMTabBarController.h"

@interface MMTabBarController ()

@end

@implementation MMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar背景颜色
    [self setupTabbarBackgroundColor];
    
    // 全局设置UITabBarItem文字属性
    [self setupTabBarItem];
    
    // 添加所有的子控制器
    [self setupAllChildVCs];
}

#pragma mark - 设置tabbar背景颜色
- (void)setupTabbarBackgroundColor {
    
    // 第一种方法
    // [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    // [UITabBar appearance].translucent = NO; // 取消tabBar的透明效果
    
    // 第二种方法: 在tabBar上添加一个有颜色的View
    UIView *tabbarView = [[UIView alloc] init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    tabbarView.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:tabbarView atIndex:0];
    
    // 第三种方法
    // [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@""]];
    // [UITabBar appearance].translucent = NO; // 取消tabBar的透明效果
}


#pragma mark - 添加所有的子控制器
- (void)setupAllChildVCs {
    
    // 会话
    [self setupChildVC:[[MMConversationListViewController alloc] init] title:@"会话" image:[UIImage imageNamed:@"tabbar_mainframe"] selectImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    // 好友
    [self setupChildVC:[[MMAddressBookTableViewController alloc] init] title:@"通讯录" image:[UIImage imageNamed:@"tabbar_contacts"] selectImage:[UIImage imageNamed:@"tabbar_contactsHL"]];
    // 群组
    [self setupChildVC:[[MMGroupsTableViewController alloc] init] title:@"群组" image:[UIImage imageNamed:@"tabbar_discover"] selectImage:[UIImage imageNamed:@"tabbar_discoverHL"]];
    // HTML5
    [self setupChildVC:[[MMHTML5Controller alloc] init] title:@"H5" image:[UIImage imageNamed:@"tabbar_new"] selectImage:[UIImage imageNamed:@"tabbar_newHL"]];
    // 我
    [self setupChildVC:[[MMMineTableViewController alloc] init] title:@"我" image:[UIImage imageNamed:@"tabbar_me"] selectImage:[UIImage imageNamed:@"tabbar_meHL"]];
}

#pragma mark - 添加一个子控制器
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage {
    
    MMNavigationController *mmNav = [[MMNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:mmNav];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectImage;
    vc.view.backgroundColor = [UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1.0];
}

#pragma mark - 全局设置tabBarItem的属性
- (void)setupTabBarItem {
    
    // 正常情况
    NSMutableDictionary *normal = [NSMutableDictionary dictionary];
    // 文字颜色
    normal[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 字体大小
    normal[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    // 选中情况
    NSMutableDictionary *select = [NSMutableDictionary dictionary];
    select[NSForegroundColorAttributeName] = MMTintColor;
    // 统一一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法,才可以通过Appearance对象来统一设置控件的属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normal forState:UIControlStateNormal];
    [item setTitleTextAttributes:select forState:UIControlStateSelected];
}
@end
