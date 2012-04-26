//
//  PhotoGrabber.m
//  AccessCameraTest1
//
//  Created by Rattapoom Jiemtea on 4/26/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "PhotoGrabber.h"

@implementation PhotoGrabber

@synthesize delegate;

-(id) init{
    if((self = [super init])){
        NSError * error = nil;
        
        video = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
        BOOL success = [video open:&error];
        if ( ! success || error ){
            NSLog(@"Did not succeed in acquire: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        input = [[QTCaptureDeviceInput alloc] initWithDevice:video];
        session = [[QTCaptureSession alloc] init];
        
        success = [session addInput:input error:&error];
        
        if ( ! success || error ){
            NSLog(@"Did not succeed in connecting input to session: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        output = [[QTCaptureDecompressedVideoOutput alloc] init];
        [output setDelegate:self];
        success = [session addOutput:output error:&error];
        
        if ( ! success || error ){
            NSLog(@"Did succeed in connecting output to session: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        currentImage = nil;
    }
    return self;
}
-(void) grabPhoto{
    [session startRunning];
}
-(NSString *) deviceName{
    return [video localizedDisplayName];
}
- (void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection
{
    if ( currentImage ) return;
    
    CVBufferRetain(videoFrame);
    
    @synchronized (self) {
        currentImage = videoFrame;
    }
    
    [self performSelectorOnMainThread:@selector(saveImage) withObject:nil waitUntilDone:NO];
}
-(void) saveImage{
    [session stopRunning];
    
    NSCIImageRep * imageRep = [NSCIImageRep imageRepWithCIImage:
                                [CIImage imageWithCVImageBuffer:
                                 currentImage]];
    NSImage *image = [[NSImage alloc] initWithSize:[imageRep size]];
    [image addRepresentation:imageRep];
    
    NSData *bitmapData = [image TIFFRepresentation];
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:bitmapData];
    NSData *imageData = [bitmapRep representationUsingType:NSJPEGFileType properties:nil];
    
    [image release];
    image = [[NSImage alloc] initWithData:imageData];
    
    if ( [self.delegate respondsToSelector:@selector(photoGrabbed:)] )
        [self.delegate photoGrabbed:image];
    
    [image release];
    CVBufferRelease(currentImage);
    currentImage = nil;
}
- (void)dealloc
{
    self.delegate = nil;
    
    if ( [session isRunning] )
        [session stopRunning];
    
    if ( [video isOpen] )
        [video close];
    

    [session removeInput:input];
    [session removeOutput:output];
    
    [input release];
    [session release];
    [output release];
    [super dealloc];
}
@end
