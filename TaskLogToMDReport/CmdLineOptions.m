//
//  CmdLineOptions.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import "CmdLineOptions.h"

@interface CmdLineOptions ()
@property (nonatomic, strong) NSString *inputPath;
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, assign) BOOL showVersion;
@end

@implementation CmdLineOptions

- (id)initWithArgs:(const char **)argv count:(int)argc {
    self = [super init];
    if (!self) return nil;

    [self parseArgs:argv count:argc];
    [self expandPaths];

    return self;
}

- (void)parseArgs:(const char **)argv count:(int)argc {
    BOOL nextArgIsOutputFile = NO;
    for (int i=1; i<argc; i++) {
        NSString *arg = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];

        if ([arg hasPrefix:@"-"]) {
            if ([arg isEqualToString:@"-o"]) {
                nextArgIsOutputFile = YES;
            }

            if ([arg isEqualToString:@"-v"]) {
                self.showVersion = YES;
                break;
            }
        } else {
            if (nextArgIsOutputFile) {
                self.outputPath = [arg copy];
                nextArgIsOutputFile = NO;
                continue;
            }

            if (!self.inputPath) {
                self.inputPath = [arg copy];
            }
        }
    }
}

- (void)expandPaths {
    if (!self.inputPath) return;

    if ([self.inputPath hasPrefix:@"~"]) {
        self.inputPath = [self.inputPath stringByExpandingTildeInPath];
    }

    if (![self.inputPath isAbsolutePath]) {
        self.inputPath = [[NSFileManager.defaultManager currentDirectoryPath] stringByAppendingPathComponent:self.inputPath];
    }

    if (!self.outputPath) {
        self.outputPath = [self.inputPath copy];
        self.outputPath = [self.outputPath stringByDeletingPathExtension];
        self.outputPath = [self.outputPath stringByAppendingPathExtension:@"md"];
    }
}

@end
