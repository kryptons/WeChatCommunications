//
//  MMHTML5Footer.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHTML5Footer.h"

#define View_Width [UIScreen mainScreen].bounds.size.width

@interface MMHTML5Footer()

@end

@implementation MMHTML5Footer

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        NSString *path = [[NSBundle mainBundle] pathForResource:@"html5.plist" ofType:nil];
        NSArray *arrs = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *htmlArr = [NSMutableArray arrayWithCapacity:arrs.count];
        for (NSDictionary *htmlDict in arrs) {
            
            MMHTML *html = [MMHTML mmHTMLWithDictionary:htmlDict];
            [htmlArr addObject:html];
        }
        [self createHTML5:htmlArr];
    }
    return self;
}

// 创建button
- (void)createHTML5:(NSMutableArray *)arrayUrl {
    
    // 每行的列数
    int colsCount = 3;
    // 每一列宽度
    CGFloat buttonW = View_Width / colsCount;
    CGFloat buttonH = buttonW * 1.1;
    NSInteger count = arrayUrl.count;
    for (int i = 0; i < count; i++) {
        
        MMHTMLButton *htmlBtn = [MMHTMLButton buttonWithType:UIButtonTypeCustom];
        [htmlBtn addTarget:self action:@selector(htmlButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:htmlBtn];
        // 设置frame
        CGFloat buttonX = i % colsCount * buttonW;
        CGFloat buttonY = i / colsCount * buttonH;
        htmlBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 设置模型数据
        htmlBtn.html = arrayUrl[i];
    }
    // 设置footerView的高度
    NSUInteger rowCount = (count + colsCount - 1) / colsCount;
    self.height = rowCount * buttonH;
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
}

- (void)htmlButtonClick:(MMHTMLButton *)button {
    
    if ([button.html.url hasPrefix:@"http"] == NO) {
        return;
    }
    MMWebViewViewController *webView = [[MMWebViewViewController alloc] init];
    webView.html = button.html; // 数据传递
    // 一种方法
    UITabBarController *rootVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVC.selectedViewController;
    [nav pushViewController:webView animated:YES];
}

@end
