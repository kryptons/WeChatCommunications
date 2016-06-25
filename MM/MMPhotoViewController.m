//
//  MMPhotoViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMPhotoViewController.h"
#import "MMSwitchPicture.h"

@interface MMPhotoViewController ()

@end

@implementation MMPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"相册";
    MMSwitchPicture *switchPicture = [[MMSwitchPicture alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:switchPicture];
    switchPicture.urlArray = @[@"http://box.dwstatic.com/skin/Irelia/Irelia_0.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_1.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_2.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_3.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_4.jpg", @"http://box.dwstatic.com/skin/Irelia/Irelia_5.jpg"];
    switchPicture.isLoop = YES;
    [switchPicture setData];
}


@end
