//
//  TaskLogConverter.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "TaskLogConverter.h"
#import "CmdLineOptions.h"
#import "LineTask.h"
#import "TaskReport.h"
#import "DateFormatHelper.h"
#import "NSMutableString+AppendLine.h"

@interface TaskLogConverter ()
@property (nonatomic, strong) CmdLineOptions *options;
@end

@implementation TaskLogConverter

- (id)initWithOptions:(CmdLineOptions *)options {
    self = [super init];
    if (!self) return nil;

    self.options = options;
    return self;
}

- (BOOL)convertToMarkdownWithError:(NSError **)error {
    if (![self checkAccessToInputFileWithError:error]) return NO;
    if (![self checkAccessToOutputFileWithError:error]) return NO;

    NSMutableArray *taskReports = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSData *csvData = [fileManager contentsAtPath:self.options.inputPath];
    if (!csvData) {
        *error = [self errorWithCode:NSFileReadUnknownError localizedDescription:[NSString stringWithFormat:@"Read error: '%@'", self.options.inputPath]];
        return NO;
    }

    NSString *csvString = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    [csvString enumerateLinesUsingBlock: ^(NSString *csvLine, BOOL *stop) {
         LineTask *lineTask = [[LineTask alloc] initWithCSVLine:csvLine];
         if (![lineTask startDate] || ![lineTask duration] || ![lineTask name]) return;

         // Aggregate totals, grouped by task.
         __block TaskReport * taskReport = nil;
         [taskReports enumerateObjectsUsingBlock: ^(TaskReport *existingTaskReport, NSUInteger idx, BOOL *stop) {
              if ([existingTaskReport.name isEqualToString:lineTask.name] &&
                  [[[DateFormatHelper taskDateFormatter] stringFromDate:existingTaskReport.date] isEqualToString:[[DateFormatHelper taskDateFormatter] stringFromDate:lineTask.startDate]]) {
                  taskReport = existingTaskReport;
                  *stop = YES;
              }
          }];

         if (!taskReport) {
             taskReport = [[TaskReport alloc] init];
             taskReport.name = lineTask.name;
             taskReport.date = lineTask.startDate;
             [taskReports addObject:taskReport];
         }

         [taskReport addDuration:lineTask.duration];
     }];

    __block NSInteger totalMinuteDuration = 0;
    [taskReports enumerateObjectsUsingBlock: ^(TaskReport *taskReport, NSUInteger idx, BOOL *stop) {
         totalMinuteDuration += taskReport.totalMinutes;
     }];

    [taskReports enumerateObjectsUsingBlock: ^(TaskReport *taskReport, NSUInteger idx, BOOL *stop) {
         taskReport.timePercentage = floor(((CGFloat)taskReport.totalMinutes / (CGFloat)totalMinuteDuration) * 100.0);
     }];

    // Add 1 to the highest percentage time because we're "flooring". This makes our percentages total 100%.
    __block TaskReport *longestTask = nil;
    [taskReports enumerateObjectsUsingBlock: ^(TaskReport *taskReport, NSUInteger idx, BOOL *stop) {
         if (taskReport.totalMinutes > longestTask.totalMinutes) {
             longestTask = taskReport;
         }
     }];
    longestTask.timePercentage += 1;

    if (![self writeTaskReports:[taskReports copy] toOutputFileWithError:error]) return NO;

    return YES;
}

- (BOOL)writeTaskReports:(NSArray *)taskReports toOutputFileWithError:(NSError **)error {
    NSMutableString *md = [NSMutableString string];

    __block NSString *dateString = nil;
    __block NSDate *totalDuration = [[DateFormatHelper durationDateFormatter] dateFromString:@"00:00:00"];

    [taskReports enumerateObjectsUsingBlock: ^(TaskReport *taskReport, NSUInteger idx, BOOL *stop) {
         NSString *reportDateString = [DateFormatHelper.taskDateFormatter stringFromDate:taskReport.date];
         if (!dateString || ![dateString isEqualToString:reportDateString]) {
             dateString = [reportDateString copy];
//	        [md appendLineFormat:@"Task Log — %@", dateString];
//	        [md appendLine:@"="];
             [md appendLineFormat:@"##Task Log — %@", dateString];
         }

         [md appendFormat:@"- %@ - ", taskReport.name];
         if (taskReport.hours < 1) {
             [md appendLineFormat:@"**[%dm; %d%%]**", taskReport.minutes, taskReport.timePercentage];
         }
         else {
             [md appendLineFormat:@"**[%dh %dm; %d%%]**", taskReport.hours, taskReport.minutes, taskReport.timePercentage];
         }

         totalDuration = [totalDuration dateByAddingTimeInterval:(taskReport.totalMinutes * 60)];
     }];

    NSInteger totalHours = [[DateFormatHelper.reportDurationHourFormatter stringFromDate:totalDuration] integerValue];
    NSInteger totalMinutes = [[DateFormatHelper.reportDurationMinuteFormatter stringFromDate:totalDuration] integerValue];

    [md appendLine:@""];
    [md appendLineFormat:@"**Total: %dh %dm**", totalHours, totalMinutes];

    return [md writeToFile:self.options.outputPath atomically:YES encoding:NSUTF8StringEncoding error:error];
}

- (BOOL)checkAccessToInputFileWithError:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (!self.options.inputPath || [[self.options.inputPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1) {
        *error = [self errorWithCode:NSFileNoSuchFileError localizedDescription:@"Input file not specified"];
        return NO;
    }

    if (![fileManager fileExistsAtPath:self.options.inputPath]) {
        *error = [self errorWithCode:NSFileNoSuchFileError localizedDescription:[NSString stringWithFormat:@"File not found: '%@'", self.options.inputPath]];
        return NO;
    }

    if (![fileManager isReadableFileAtPath:self.options.inputPath]) {
        *error = [self errorWithCode:NSFileReadNoPermissionError localizedDescription:[NSString stringWithFormat:@"Cannot read: '%@'", self.options.inputPath]];
        return NO;
    }

    return YES;
}

- (BOOL)checkAccessToOutputFileWithError:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:self.options.outputPath]) {
        if (![fileManager isWritableFileAtPath:self.options.outputPath]) {
            *error = [self errorWithCode:NSFileWriteNoPermissionError localizedDescription:[NSString stringWithFormat:@"Cannot write: '%@'", self.options.outputPath]];
            return NO;
        }
    }
    else {
        if (![fileManager createFileAtPath:self.options.outputPath contents:nil attributes:nil]) {
            *error = [self errorWithCode:NSFileWriteNoPermissionError localizedDescription:[NSString stringWithFormat:@"Cannot create: '%@'", self.options.outputPath]];
            return NO;
        }
    }

    return YES;
}

- (NSError *)errorWithCode:(NSInteger)code localizedDescription:(NSString *)description {
    return [NSError errorWithDomain:NSCocoaErrorDomain code:code userInfo:@{ NSLocalizedDescriptionKey : description }];
}

@end
