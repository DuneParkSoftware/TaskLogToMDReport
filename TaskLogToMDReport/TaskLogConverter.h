//
//  TaskLogConverter.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CmdLineOptions;

@interface TaskLogConverter : NSObject

- (id)initWithOptions:(CmdLineOptions *)options;
- (BOOL)convertToMarkdownWithError:(NSError **)error;

@end
