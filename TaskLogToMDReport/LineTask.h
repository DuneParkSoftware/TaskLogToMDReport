//
//  LineTask.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineTask : NSObject

@property (nonatomic, readonly, strong) NSDate *startDate;
@property (nonatomic, readonly, strong) NSDate *duration;
@property (nonatomic, readonly, strong) NSString *name;

- (id)initWithCSVLine:(NSString *)csvLine;

@end
