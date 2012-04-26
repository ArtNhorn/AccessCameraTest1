//
//  PhotoGrabber.h
//  AccessCameraTest1
//
//  Created by Rattapoom Jiemtea on 4/26/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@protocol PhotoGrabberDelegate <NSObject>

-(void)photoGrabber:(NSString *) image;

@end

@interface PhotoGrabber : NSObject{
    CVImageBufferRef currentImage;
    
    QTCaptureDevice * video;
    QTCaptureDecompressedVideoOutput * output;
    QTCaptureInput * input;
    QTCaptureSession * session;
    
    id<PhotoGrabberDelegate> delegate;
}
@property (nonatomic, assign) id<PhotoGrabberDelegate> delegate;

-(void) grabPhoto;
-(NSString *) deviceName;

@end
