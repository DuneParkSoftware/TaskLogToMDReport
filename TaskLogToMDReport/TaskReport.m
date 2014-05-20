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
@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, assign) NSInteger minutes;
@end

@implementation TaskReport

- (void)addDuration:(NSDate *)duration {
    if (!self.duration) {
        self.duration = [duration copy];
    }
    else {
        NSDate *zeroDate = [[DateFormatHelper durationDateFormatter] dateFromString:@"00:00:00"];
        NSTimeInterval timeInterval = [duration timeIntervalSinceDate:zeroDate];
        self.duration = [self.duration dateByAddingTimeInterval:timeInterval];
    }

    [self calculateHoursAndMinutes];
}

- (void)calculateHoursAndMinutes {
    NSInteger hours = [[[DateFormatHelper reportDurationHourFormatter] stringFromDate:self.duration] integerValue];
    NSInteger minutes = [[[DateFormatHelper reportDurationMinuteFormatter] stringFromDate:self.duration] integerValue];

    // Round minutes.
    if (minutes < 7) {
        minutes = 5;
    }
    else if (minutes >= 7 && minutes < 12) {
        minutes = 10;
    }
    else if (minutes >= 12 && minutes < 17) {
        minutes = 15;
    }
    else if (minutes >= 17 && minutes < 25) {
        minutes = 20;
    }
    else if (minutes >= 25 && minutes < 37) {
        minutes = 30;
    }
    else if (minutes >= 37 && minutes < 52) {
        minutes = 45;
    }
    else {
        minutes = 0;
        hours += 1;
    }

    self.hours = hours;
    self.minutes = minutes;
}

- (NSInteger)totalMinutes {
    return (self.hours * 60) + self.minutes;
}

@end
