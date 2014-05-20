//
//  LineTask.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "LineTask.h"
#import "DateFormatHelper.h"

@interface LineTask ()
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *duration;
@property (nonatomic, strong) NSString *name;
@end

@implementation LineTask

- (id)initWithCSVLine:(NSString *)csvLine {
    self = [super init];
    if (!self) return nil;

    [self parseCSVLine:csvLine];
    return self;
}

- (void)parseCSVLine:(NSString *)csvLine {
    NSArray *components = [csvLine componentsSeparatedByString:@"\",\""];
    if ([components count] != 3) return;

    [self parseStartDate:components[0]];
    [self parseDuration:components[1]];
    [self parseName:components[2]];
}

- (void)parseStartDate:(NSString *)startDateComponent {
    if ([startDateComponent hasPrefix:@"\""]) {
        startDateComponent = [startDateComponent substringWithRange:NSMakeRange(1, [startDateComponent length] - 1)];
    }

    self.startDate = [[DateFormatHelper startDateFormatter] dateFromString:startDateComponent];
}

- (void)parseDuration:(NSString *)durationComponent {
    self.duration = [[DateFormatHelper durationDateFormatter] dateFromString:durationComponent];
    if (self.duration == nil) {
        self.duration = [[DateFormatHelper durationHMSDateFormatter] dateFromString:durationComponent];
    }
}

- (void)parseName:(NSString *)nameComponent {
    if ([nameComponent hasSuffix:@"\""]) {
        nameComponent = [nameComponent substringWithRange:NSMakeRange(0, [nameComponent length] - 1)];
    }
    self.name = [nameComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
