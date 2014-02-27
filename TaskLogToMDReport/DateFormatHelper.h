//
//  DateFormatHelper.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatHelper : NSObject

+ (NSDateFormatter *)startDateFormatter;
+ (NSDateFormatter *)durationDateFormatter;
+ (NSDateFormatter *)taskDateFormatter;
+ (NSDateFormatter *)reportDurationHourFormatter;
+ (NSDateFormatter *)reportDurationMinuteFormatter;

@end
