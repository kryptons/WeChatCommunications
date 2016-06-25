//
//  DBHelper.h
//  RCloudMessage
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DBHelper : NSObject

+(FMDatabaseQueue *) getDatabaseQueue;

+(BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db;
@end

