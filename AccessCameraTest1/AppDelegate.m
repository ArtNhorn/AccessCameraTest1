//
//  AppDelegate.m
//  AccessCameraTest1
//
//  Created by Rattapoom Jiemtea on 4/26/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize outputView = _outputView;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    PhotoGrabber *grabber = [[PhotoGrabber alloc] init];
	grabber.delegate =  self;
	[grabber grabPhoto];
}
@end