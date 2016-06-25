//
//  MMExpresionViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/26.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMExpresionViewController.h"

@interface MMExpresionViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation MMExpresionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    // 设置导航栏
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
}

#pragma mark - Getter and Setter 
- (UISegmentedControl *)segmentedControl {
    
    if (_segmentedControl == nil) {
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"精选表情", @"投稿表情"]];
        _segmentedControl.width = MMWidth * 0.6;
        _segmentedControl.centerX = MMWidth * 0.5;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.layer.masksToBounds = YES;
        _segmentedControl.layer.cornerRadius = 5.0f;
        [_segmentedControl setSelectedSegmentIndex:0]; // 默认选第一个
        [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIBarButtonItem *)rightBarButtonItem {
    
    if (_rightBarButtonItem == nil) {
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        [self.rightButton setImage:[[UIImage imageNamed:@"barbuttonicon_set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
        [self.rightButton addTarget:self action:@selector(rightBarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    }
    return _rightBarButtonItem;
}

#pragma mark - UIControlEventValueChanged
- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl {
    

}

- (void)rightBarButtonDown:(UIButton *)button {
    
    
}
@end
