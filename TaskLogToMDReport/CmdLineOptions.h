//
//  CmdLineOptions.h
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmdLineOptions : NSObject

@property (nonatomic, readonly, strong) NSString *inputPath;
@property (nonatomic, readonly, strong) NSString *outputPath;

- (id)initWithArgs:(const char **)argv count:(int)argc;

@end
