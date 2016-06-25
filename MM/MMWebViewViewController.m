//
//  MMWebViewViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/28.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMWebViewViewController.h"
#import "UIWebView+Extension.h"

@interface MMWebViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
/** 后退 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;

@property (weak, nonatomic) IBOutlet UIToolbar *hiddenToobar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ToobarHeightConstrait;
@end

@implementation MMWebViewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = self.html.name;
    if ([self.html.name isEqualToString:@"固生堂"]) {
        
        self.hiddenToobar.hidden = YES;
        self.ToobarHeightConstrait.constant = 0;
    }
    NSURL *url = [NSURL URLWithString:self.html.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    self.webView.allowsInlineMediaPlayback = YES; // 全屏播放
    
    [self.webView loadRequest:request];
    // 一种写法
//    NSURL *url = [NSURL URLWithString:self.html.url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    self.webView = [UIWebView loadRequest:request loaded:^(UIWebView *webView) {
//        
//        NSLog(@"url = %@", webView.request.URL);
//    } failed:^(UIWebView *webView, NSError *error) {
//        
//        NSLog(@"error = %@", error.localizedDescription);
//    } loadStarted:^(UIWebView *webView) {
//        
//        NSLog(@"start loading to url = %@", webView.request.URL);
//    } shouldLoad:^BOOL(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType) {
//        
//        return YES;
//    }];
    // 二种写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index1" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark - 后退
- (IBAction)backClick:(id)sender {
    
    [self.webView goBack];
}

#pragma mark - 前进
- (IBAction)forwardClick:(id)sender {
    
    [self.webView goForward];
}

#pragma mark - 刷新
- (IBAction)refreshClick:(id)sender {
    
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
    webView.allowsInlineMediaPlayback = YES;
}

@end
