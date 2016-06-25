//
//  MMPictureViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMPictureViewController.h"
#import "MyCollectionViewCell.h"
#import "MMHomePictureViewController.h"
#import "AppDelegate.h"

#define CollectionViewWidth (MMWidth - 2 * MMMargin) / 3

@interface MMPictureViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *pictures;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MMPictureViewController

static NSString *const cellID = @"MyCollectionViewCell";
#pragma mark - lazy
- (NSMutableArray *)pictures {
    
    if (!_pictures) {
        
        _pictures = [NSMutableArray array];
        // 加载图片信息
        for (NSInteger i = 1; i <= 20; i++) {
            
            NSString *pictureName = [NSString stringWithFormat:@"%zd.jpg", i];
            UIImage *photo = [UIImage imageNamed:pictureName];
            [_pictures addObject:photo];
        }
    }
    return _pictures;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片动画";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.bounds = CGRectMake(0, 0, CollectionViewWidth, CollectionViewWidth);
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CollectionViewWidth, CollectionViewWidth);
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    NSInteger row   = self.pictures.count / 3;
    
    if (self.pictures.count % 3 == 0) {
        
        self.collectionView.contentSize = CGSizeMake(MMWidth, (CollectionViewWidth + MMMargin) * row);
    }
    else {
        
        self.collectionView.contentSize = CGSizeMake(MMWidth, (CollectionViewWidth + MMMargin) * (row + 1) + 100);
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    // 注册
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imageView.image = self.pictures[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    MMHomePictureViewController *homeVC = [[MMHomePictureViewController alloc] init];
    homeVC.headImage = cell.imageView.image;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = cell.imageView.image;
    imageView.bounds = cell.bounds;
    imageView.center = CGPointMake(cell.center.x, cell.center.y - collectionView.contentOffset.y + 64);
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.backgroundColor = [UIColor whiteColor];
    [window addSubview:imageView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.imageView = imageView;
    appDelegate.pushCenter = imageView.center;
    appDelegate.popCenter  = CGPointMake(70, 200);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            imageView.bounds              = CGRectMake(0, 0, 110, 110);
            imageView.layer.shadowOffset  = CGSizeMake(2, 2);
            imageView.layer.shadowRadius  = 30;
            imageView.layer.shadowColor   = [UIColor purpleColor].CGColor;
            imageView.layer.shadowOpacity = 0.8;
            imageView.center = CGPointMake(70, 200 + 64);
            
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius  = imageView.width * 0.5;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                imageView.bounds = CGRectMake(0, 0, 100, 100);
            } completion:^(BOOL finished) {
                
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius  = imageView.width * 0.5;
                
                imageView.layer.shadowOffset  = CGSizeMake(0, 0);
                imageView.layer.shadowRadius  = 0;
                imageView.layer.shadowColor   = [UIColor clearColor].CGColor;
                [self performSelector:@selector(goToNextViewController:) withObject:homeVC afterDelay:0.1];
            }];
        }];
        
    }];
}

-(void)goToNextViewController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:NO];
    self.view.alpha = 1;
}

@end















