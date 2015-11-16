

#import "AVCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVCamPreviewView

+ (Class)layerClass
{
    
	return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
    
	//return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
	//[(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
