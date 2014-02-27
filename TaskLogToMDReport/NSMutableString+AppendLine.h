//
//  NSMutableString+AppendLine.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (AppendLine)

- (void)appendLine:(NSString *)line;
- (void)appendLineFormat:(NSString *)line, ...;

@end
