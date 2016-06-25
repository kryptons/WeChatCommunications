//
//  MMHTML.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHTML.h"

@implementation MMHTML

+ (instancetype)mmHTMLWithDictionary:(NSDictionary *)dict {
    
    MMHTML *html = [[MMHTML alloc] init];
    
    html.name = dict[@"name"];
    html.icon = dict[@"icon"];
    html.url = dict[@"url"];
    return html;
}

@end
