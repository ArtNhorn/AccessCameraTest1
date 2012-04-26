//
//  AppDelegate.h
//  AccessCameraTest1
//
//  Created by Rattapoom Jiemtea on 4/26/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> 

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet QTCaptureView *outputView;

@end
