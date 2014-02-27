//
//  NSMutableString+AppendLine.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "NSMutableString+AppendLine.h"

@implementation NSMutableString (AppendLine)

- (void)appendLine:(NSString *)line {
    if (line) {
        [self appendString:[NSString stringWithFormat:@"%@\n", line]];
    }
}

- (void)appendLineFormat:(NSString *)line, ... {
    if (line) {
        va_list args;
        va_start(args, line);
        [self appendFormat:@"%@\n", [[NSString alloc] initWithFormat:line arguments:args]];
        va_end(args);
    }
}

@end
