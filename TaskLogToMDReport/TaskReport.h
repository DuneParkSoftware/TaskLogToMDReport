//
//  TaskReport.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskReport : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, readonly, strong) NSDate *duration;

- (void)addDuration:(NSDate *)duration;

@end
