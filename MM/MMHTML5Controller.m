//
//  MMHTML5Controller.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHTML5Controller.h"

@interface MMHTML5Controller () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MMHTML5Controller

// cell循环利用标识
static NSString *const MMHTMLCellID = @"MMHTMLCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HTML5";
    self.navigationController.navigationBar.translucent = NO;
    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.backgroundView = view;
    
    // 注册
    [self.tableView registerClass:[MMHTMLCell class] forCellReuseIdentifier:MMHTMLCellID];
    
    MMHTML5Footer *html5Footer = [[MMHTML5Footer alloc] init];
    self.tableView.tableFooterView = html5Footer;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMHTMLCell *cell = [tableView dequeueReusableCellWithIdentifier:MMHTMLCellID];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabel.text = @"登录注册";
        cell.imageView.image = [UIImage imageNamed:@"eye"];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
       cell.textLabel.text = @"离线下载";
    }
    return cell;
}



@end
