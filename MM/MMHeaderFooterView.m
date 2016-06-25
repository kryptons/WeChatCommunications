//
//  MMHeaderFooterView.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHeaderFooterView.h"

static UILabel *hLabel = nil;

@implementation MMHeaderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setUserInteractionEnabled:NO];
        [self addSubview:self.titleLabel];
        [self setBackgroundView:[[UIView alloc] init]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    float x = self.frame.size.width * 0.065;
    float w = self.frame.size.width * 0.89;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)];
    [self.titleLabel setFrame:CGRectMake(x, 6, w, size.height)];
}

- (void) setText:(NSString *)text
{
    _text = text;
    [self.titleLabel setText:text];
    [self layoutSubviews];
}

+ (CGFloat) getHeightForText:(NSString *)text
{
    if (text == nil) {
        return 15.0f;
    }
    if (hLabel == nil) {
        hLabel = [[UILabel alloc] init];
        [hLabel setNumberOfLines:0];
        [hLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    [hLabel setText:text];
    float w = [UIScreen mainScreen].bounds.size.width * 0.92;
    return [hLabel sizeThatFits:CGSizeMake(w, MAXFLOAT)].height + 14;
}

#pragma mark - Getter
- (UILabel *) titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}

@end
