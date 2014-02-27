//
//  TaskReport.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "TaskReport.h"
#import "DateFormatHelper.h"

@interface TaskReport ()
@property (nonatomic, strong) NSDate *duration;
@end

@implementation TaskReport

- (void)addDuration:(NSDate *)duration {
    if (!self.duration) {
        self.duration = [duration copy];
    } else {
        NSDate *zeroDate = [[DateFormatHelper durationDateFormatter] dateFromString:@"00:00:00"];
        NSTimeInterval timeInterval = [duration timeIntervalSinceDate:zeroDate];
        self.duration = [self.duration dateByAddingTimeInterval:timeInterval];
    }
}

@end
