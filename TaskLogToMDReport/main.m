//
//  main.m
//  TaskLogToMDReport
//
//  Created by Eric D. Baker on 26/Feb/14.
//  Copyright (c) 2014 DuneParkSoftware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdLineOptions.h"
#import "TaskLogConverter.h"

NSString *const AppVersion = @"1.1.0";

void showVersion() {
	printf("tasklog2md\n");
	printf("Version: %s\n", [AppVersion cStringUsingEncoding:NSUTF8StringEncoding]);
}

int main(int argc, const char *argv[]) {
	@autoreleasepool {
		CmdLineOptions *options = [[CmdLineOptions alloc] initWithArgs:argv count:argc];

		if (options.showVersion) {
			showVersion();
			return 0;
		}
		TaskLogConverter *converter = [[TaskLogConverter alloc] initWithOptions:options];

		NSError *error = nil;
		if (![converter convertToMarkdownWithError:&error]) {
			NSLog(@"ERROR: %@", error.localizedDescription);
			return (int)error.code;
		}
	}

	return 0;
}
