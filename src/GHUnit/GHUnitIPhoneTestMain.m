//
//  GHUnitIPhoneTestMain.m
//  GHUnitIPhone
//
//  Created by Gabriel Handford on 1/25/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHUnit.h"

int main(int argc, char *argv[]) {
	setenv("NSDebugEnabled", "1", 1);
	setenv("NSAutoreleaseFreedObjectCheckEnabled", "1", 1);
	setenv("NSZombieEnabled", "1", 1);
	setenv("NSDeallocateZombies", "0", 1);
	//setenv("MallocStackLogging", "1", 1);
	//setenv("MallocStackLoggingNoCompact", "1", 1);
	setenv("NSHangOnUncaughtException", "1", 1);
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// Register any special test case classes
	//[[GHTesting sharedInstance] registerClassName:@"GHSpecialTestCase"];	
	
	int retVal = 0;
	// If GHUNIT_CLI is set we are using the command line interface and run the tests
	// Otherwise load the GUI app
	if (getenv("GHUNIT_CLI")) {
		retVal = [GHTestRunner run];
	} else {
		retVal = UIApplicationMain(argc, argv, nil, @"GHUnitIPhoneAppDelegate");
	}
	[pool release];
	return retVal;
}
