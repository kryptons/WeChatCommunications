//
//  MMSettingCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSettingCell.h"
#import "UIDevice+Extension.h"

#define CellWidth self.frame.size.width
#define CellHeight self.frame.size.height

@interface MMSettingCell()

@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblSubTitle;

@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *middleImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (strong, nonatomic) UISwitch *cSwitch;
@property (strong, nonatomic) UIButton *cButton;

@property (strong, nonatomic) NSMutableArray *subImageArray;
@property (nonatomic, assign) float leftFreeSpace;
@end

@implementation MMSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.lblTitle];
        [self addSubview:self.lblSubTitle];
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.middleImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.cSwitch];
        [self addSubview:self.cButton];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.leftFreeSpace = CellWidth * 0.05;
    [super layoutSubviews];
    
    float spaceX = self.leftFreeSpace;
    
    if (self.item.type == MMSettingItemTypeButton) {
        
        float buttonX = CellWidth * 0.04;
        float buttonY = CellHeight * 0.09;
        float buttonWidth = CellWidth - buttonX * 2;
        float buttonHeight = CellHeight - buttonY * 2;
        [self.cButton setFrame:CGRectMake(buttonX, 0, buttonWidth, buttonHeight)];
    }
    
    float x = spaceX;
    float y = CellHeight * 0.22;
    float h = CellHeight - y * 2;
    y -= 0.25;
    CGSize size;
    
    // main Image
    if (self.item.imageName) {
        
        [self.mainImageView setFrame:CGRectMake(x, y, h, h)];
        x += h + spaceX;
    }
    
    // title
    if (self.item.title) {
        
        size = [self.lblTitle sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (self.item.alignment == MMSettingItemAlignmentMiddle) {
            
            [self.lblTitle setFrame:CGRectMake((CellWidth - size.width) * 0.5, y, size.width, h)];
        }
        else {
            [self.lblTitle setFrame:CGRectMake(x, y - 0.5, size.width, h)];
        }
    }
    
    if (self.item.alignment == MMSettingItemAlignmentRight) {
        
        float rx = CellWidth - (self.item.accessoryType == UITableViewCellAccessoryDisclosureIndicator ? 35 : 10);
        
        if (self.item.type == MMSettingItemTypeSwitch) {
            
            float cx = rx - self.cSwitch.frame.size.width / 1.7;
            [self.cSwitch setCenter:CGPointMake(cx, CellHeight / 2.0)];
            rx -= self.cSwitch.frame.size.width - 5;
        }
        
        if (self.item.rightImageName) {
            float mh = CellHeight * self.item.rightImageHeightOfCell;
            float my = (CellHeight - mh) / 2;
            rx -= mh;
            [self.rightImageView setFrame:CGRectMake(rx, my, mh, mh)];
            rx -= mh * 0.15;
        }
        if (self.item.subTitle) {
            size = [self.lblSubTitle sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            rx -= size.width;
            [self.lblSubTitle setFrame:CGRectMake(rx, y - 0.5, size.width, h)];
            rx -= 5;
        }
        if (self.item.middleImageName) {
            float mh = CellHeight * self.item.middleImageHeightOfCell;
            float my = (CellHeight - mh) / 2 - 0.5;
            rx -= mh;
            [self.middleImageView setFrame:CGRectMake(rx, my, mh, mh)];
            rx -= mh * 0.15;
        }
    }
    else if (self.item.alignment == MMSettingItemAlignmentLeft) {
        float t = 105;
        if ([UIDevice deviceVerType] == DeviceVer6P) {
            t = 120;
        }
        float lx = (x < t ? t : x);
        if (self.item.subTitle) {
            size = [self.lblSubTitle sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            [self.lblSubTitle setFrame:CGRectMake(lx, y - 0.5, size.width, h)];
            lx += size.width + 5;
        }
        else if (self.item.subImages && self.item.subImages.count > 0) {
            float imageWidth = CellHeight * 0.65;
            float width = CellWidth * 0.89 - lx;
            float space = 0;
            NSUInteger count = width / imageWidth * 1.1;
            count = count < self.subImageArray.count ? count : self.subImageArray.count;
            for (int i = 0; i < count; i ++) {
                UIButton *iV = [self.subImageArray objectAtIndex:i];
                [iV setFrame:CGRectMake(lx + (imageWidth + space) * i, (CellHeight - imageWidth) / 2, imageWidth, imageWidth)];
                space = imageWidth * 0.1;
            }
            for (int i = (int)count; i < self.item.subImages.count; i ++) {
                UIButton *iV = [self.subImageArray objectAtIndex:i];
                [iV removeFromSuperview];
            }
        }
    }
}

// 设置数据
- (void)setItem:(MMSettingItem *)item {
    
    _item = item;
    if (item.type == MMSettingItemTypeButton) {
        
        [self.cButton setTitle:item.title forState:UIControlStateNormal];
        [self.cButton setBackgroundColor:item.btnBGColor];
        [self.cButton setTitleColor:item.btnTitleColor forState:UIControlStateNormal];
        [self.cButton setHidden:NO];
        [self.lblTitle setHidden:YES];
    }
    else {
        
        [self.cButton setHidden:YES];
        [self.lblTitle setText:item.title];
        [self.lblTitle setHidden:NO];
    }
    
    if (item.subTitle) {
        
        [self.lblSubTitle setText:item.subTitle];
        [self.lblSubTitle setHidden:NO];
    }
    else {
        
        [self.lblSubTitle setHidden:YES];
    }
    
    if (item.imageName) {
        
        [self.mainImageView setImage:[[UIImage imageNamed:item.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.mainImageView setHidden:NO];
    }
    else {
        
        [self.mainImageView setImage:nil];
        [self.mainImageView setHidden:YES];
    }
    
    if (item.middleImageName) {
        
        [self.middleImageView setImage:[[UIImage imageNamed:item.middleImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.middleImageView setHidden:NO];
    }
    else {
        
        [self.middleImageView setImage:nil];
        [self.middleImageView setHidden:YES];
    }

    if (item.rightImageName) {
        [self.rightImageView setImage:[[UIImage imageNamed:item.rightImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.rightImageView setHidden:NO];
    }
    else {
        [self.rightImageView setImage:nil];
        [self.rightImageView setHidden:YES];
    }
    
    if (item.type == MMSettingItemTypeSwitch) {
        [self.cSwitch setHidden:NO];
    }
    else {
        [self.cSwitch setHidden:YES];
    }
    
    if (item.subImages) {
        
        for (int i = 0; i < item.subImages.count; i++) {
            
            id imageName = item.subImages[i];
            UIButton *button = nil;
            if (i < self.subImageArray.count) {
                
                button = self.subImageArray[i];
            }
            else {
                button = [[UIButton alloc] init];
                [self.subImageArray addObject:button];
            }
            if ([imageName isKindOfClass:[NSString class]]) {
                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
            [self addSubview:button];
        }
        for (int i = (int)(item.subImages.count); i < self.subImageArray.count; i ++) {
            UIButton *button = self.subImageArray[i];
            [button removeFromSuperview];
        }
    }
    // 设置样式
    [self setBackgroundColor:item.bgColor];
    [self setAccessoryType:item.accessoryType];
    [self setSelectionStyle:item.selectionStyle];
    
    [self.lblTitle setFont:item.titleFont];
    [self.lblTitle setTextColor:item.titleColor];
    
    [self.lblSubTitle setFont:item.subTitleFont];
    [self.lblSubTitle setTextColor:item.subTitleColor];
    
    [self layoutSubviews];
}

+ (CGFloat)getHeightForText:(MMSettingItem *)item {
    
    if (item.type == MMSettingItemTypeButton) {
        
        return 50.0f;
    }
    else if (item.subImages && item.subImages.count > 0) {
        
        return 90.0f;
    }
    return 43.0f;
}

#pragma mark - lazy Getter

- (UILabel *)lblTitle {
    
    if (_lblTitle == nil) {
        
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _lblTitle;
}

- (UILabel *)lblSubTitle {
    
    if (_lblSubTitle == nil) {
        
        _lblSubTitle = [[UILabel alloc] init];
        [_lblSubTitle setFont:[UIFont systemFontOfSize:15.0f]];
        [_lblSubTitle setTextColor:[UIColor grayColor]];
    }
    return _lblSubTitle;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        
        _mainImageView = [[UIImageView alloc] init];
    }
    return _mainImageView;
}

- (UIImageView *)middleImageView {
    
    if (_middleImageView == nil) {
        
        _middleImageView = [[UIImageView alloc] init];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    
    if (_rightImageView == nil) {
        
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (NSMutableArray *)subImageArray {
    
    if (_subImageArray == nil) {
        
        _subImageArray = [NSMutableArray array];
    }
    return _subImageArray;
}

- (UISwitch *)cSwitch {
    
    if (_cSwitch == nil) {
        
        _cSwitch = [[UISwitch alloc] init];
    }
    return _cSwitch;
}

- (UIButton *) cButton
{
    if (_cButton == nil) {
        _cButton = [[UIButton alloc] init];
        [_cButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_cButton.layer setMasksToBounds:YES];
        [_cButton.layer setCornerRadius:4.0f];
        [_cButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor darkGrayColor])];
        [_cButton.layer setBorderWidth:0.5f];
    }
    return _cButton;
}

@end























