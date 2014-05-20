//
//  DateFormatHelper.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "DateFormatHelper.h"

@implementation DateFormatHelper

+ (NSDateFormatter *)startDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateStyle = NSDateFormatterShortStyle;
                      dateFormatter.timeStyle = NSDateFormatterShortStyle;
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

+ (NSDateFormatter *)durationDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateFormat = @"HH:mm:ss";
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

+ (NSDateFormatter *)durationHMSDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateFormat = @"HH'h 'mm'm 'ss's'";
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

+ (NSDateFormatter *)taskDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateStyle = NSDateFormatterShortStyle;
                      dateFormatter.timeStyle = NSDateFormatterNoStyle;
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

+ (NSDateFormatter *)reportDurationHourFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateFormat = @"H";
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

+ (NSDateFormatter *)reportDurationMinuteFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.dateFormat = @"m";
                      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  });
    return dateFormatter;
}

@end
