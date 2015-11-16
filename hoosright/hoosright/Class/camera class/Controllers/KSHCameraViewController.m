//
//  KSHCameraViewController.m
//  hoosright
//
//  Created by rupam on 7/7/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "KSHCameraViewController.h"
#import "KSHCameraController.h"
#import "KSHPreviewView.h"
#import "KSHCaptureButton.h"
#import "KSHContextManager.h"
#import "KSHOverlayView.h"
#import "TWPhotoPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NewsFeedVC.h"
#import "Capture.h"

static void *CameraTorchModeObservationContext     = &CameraTorchModeObservationContext;

@interface KSHCameraViewController () <KSHPreviewViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) KSHCameraController *cameraController;
@property (strong, nonatomic) KSHPreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *cameraFlashButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;
@property (weak, nonatomic) IBOutlet KSHOverlayView *overlayView;
@property (strong, nonatomic) IBOutlet UIImageView *LastVideo;



@end

@implementation KSHCameraViewController

- (void)dealloc {
    [self.cameraController removeObserver:self forKeyPath:@"torchMode"];
}

- (KSHCameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[KSHCameraController alloc] init];
    }
    return _cameraController;
}

-(KSHPreviewView *)previewView
{
    if (!_previewView) {
        _previewView = [[KSHPreviewView alloc] initWithFrame:self.view.bounds context:[KSHContextManager sharedInstance].eaglContext];
    }
    return _previewView;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden  = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self lastVideo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
    
    self.cameraController.filterEnable = NO;
    //self.overlayView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
    self.overlayView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    self.overlayView.tapedHandelDelegate = self;
    
    self.previewView.coreImageContext = [KSHContextManager sharedInstance].ciContext;
    
    self.cameraController.imageTarget = self.previewView;
    [self.view insertSubview:self.previewView atIndex:0];
    
    
    self.cameraController.sessionPreset = AVCaptureSessionPresetMedium;
    
    self.overlayView.session = self.cameraController.captureSession;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.cameraController startSession];
    }
    else {
        NSLog(@"%@", error.localizedDescription);
    }
    
    
    if ([self.cameraController cameraHasTorch]) {
        [self.cameraController addObserver:self forKeyPath:@"torchMode" options:NSKeyValueObservingOptionNew context:CameraTorchModeObservationContext];
    }
    else {
        self.cameraFlashButton.enabled = YES;
    }

    self.LastVideo.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(LibraryVideoTap:)];
    pgr.numberOfTapsRequired = 1;
    pgr.numberOfTouchesRequired = 1;
    pgr.delegate = self;
    [self.LastVideo addGestureRecognizer:pgr];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)switchFlashButtonPressed:(UIButton *)sender {
    switch (self.cameraController.torchMode) {
        case AVCaptureTorchModeOff:
            self.cameraController.torchMode = AVCaptureTorchModeOn;
            break;
            
        case AVCaptureTorchModeOn:
            self.cameraController.torchMode = AVCaptureTorchModeAuto;
            break;
            
        case AVCaptureTorchModeAuto:
            self.cameraController.torchMode = AVCaptureTorchModeOff;
            break;
            
        default:
            break;
    }
}

- (IBAction)switchCameraButtonPressed:(UIButton *)sender {
    if ([self.cameraController canSwitchCameras]) {
        self.cameraController.filterEnable = NO;
        [self.cameraController switchCameras];
    }
}

- (IBAction)recordButtonPressed:(KSHCaptureButton *)sender {
    
        if (!self.cameraController.isRecording) {
        sender.selected = YES;
        [self.cameraController startRecording];
        //[self updateOverLayer];
        [self startTimer];
    }
    else{
        sender.selected = NO;
        [self.cameraController stopRecording];
        //[self updateOverLayer];
        [self stopTimer];
        
        [self performSelector:@selector(load) withObject:nil afterDelay:2.0f];
        
        }
    
    }

-(void)load
{
    [self lastVideo];
    
    NSMutableArray *assets = [[NSMutableArray alloc]init];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
        
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [assets insertObject:result atIndex:0];
        }
        
        
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allVideos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (assets.count) {
                
                ALAssetRepresentation *representation = [[assets objectAtIndex:0] defaultRepresentation];
                *stop = YES;
                NSURL *url = [representation url];
                Capture *Capture_ = [[Capture alloc]init];
                Capture_.url = url;
                Capture_.image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                
                
                ALAssetRepresentation *rep = [[assets objectAtIndex:0] defaultRepresentation];
                Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                
                Capture_.passvideodata = data;
                

                Capture_.type = @"Video";
                
                [self.navigationController pushViewController:Capture_ animated:YES];
            }
        }
        *stop = NO;
    };
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];

}


/*
 
 - (IBAction)filterEnableButtonPressed:(UIButton *)sender {
    if (self.cameraController.filterEnable) {
        self.cameraController.filterEnable = NO;
        [sender setImage:[UIImage imageNamed:@"OnOffButton_off"] forState:UIControlStateNormal];
    }else{
        self.cameraController.filterEnable = YES;

        [sender setImage:[UIImage imageNamed:@"OnOffButton_on"] forState:UIControlStateNormal];
    }

}
 
*/

- (void)updateOverLayer
{
    if (!self.cameraController.isRecording) {
        [UIView animateWithDuration:0.2 animations:^{
            self.cameraFlashButton.transform = CGAffineTransformMakeTranslation(0, -60);
            self.cameraFlashButton.alpha = 0;
            self.cameraSwitchButton.transform = CGAffineTransformMakeTranslation(0,-60);
            self.cameraSwitchButton.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.timerViewTopConstraint.constant = 0;
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        }];
    }else{
        self.timerViewTopConstraint.constant = -25;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:.5 options:0 animations:^{
                self.cameraFlashButton.transform = CGAffineTransformIdentity;
                self.cameraFlashButton.alpha = 1;
                self.cameraSwitchButton.transform = CGAffineTransformIdentity;
                self.cameraSwitchButton.alpha = 1;
            } completion:nil];
        }];
    }
}

- (void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimeDisplay {
    NSUInteger time = self.cameraController.recordedDuration;
    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    NSString *timeString = [NSString stringWithFormat:format, hours, minutes, seconds];
    self.timerLabel.text = timeString;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timerLabel.text  = @"00:00:00";
}

#pragma mark- update View Status

- (void)updateFlashButtonByTochMode:(AVCaptureTorchMode)touchMode {
    
    switch (touchMode) {
        case AVCaptureTorchModeOff:
            [self.cameraFlashButton setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal];
            break;
            
        case AVCaptureTorchModeOn:
            [self.cameraFlashButton setImage:[UIImage imageNamed:@"SwitchFlash_on"] forState:UIControlStateNormal];
            break;
            
        case AVCaptureTorchModeAuto:
            [self.cameraFlashButton setImage:[UIImage imageNamed:@"SwitchFlash_auto"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma mark- KSHPreviewViewDelegate
- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.cameraController focusAtPoint:point];
}

- (void)tappedToExposeAtPoint:(CGPoint)point {
    [self.cameraController exposeAtPoint:point];
}

- (void)tappedToResetFocusAndExposure {
    [self.cameraController resetFocusAndExposureModes];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == CameraTorchModeObservationContext) {
        [self updateFlashButtonByTochMode:(AVCaptureTorchMode)[change[@"new"] intValue]];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)LibraryimageTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    photoPicker.Type = @"Image";
    
    
    photoPicker.cropBlock = ^(UIImage *image) {
        NSLog(@"This is the image you choose %@",image);
        //do something
    };
    [self presentViewController:photoPicker animated:YES completion:NULL];
}


- (void)LibraryVideoTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
    
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    photoPicker.Type = @"Video";
    
    
//    photoPicker.cropBlock = ^(UIImage *image) {
//        NSLog(@"This is the image you choose %@",image);
//        //do something
//    };
    //[self.navigationController presentViewController:photoPicker animated:YES completion:NULL];
    
    
    [self.navigationController pushViewController:photoPicker animated:YES];

}

- (IBAction)backtocamera:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)lastVideo
{
   
    
    NSMutableArray *assets = [[NSMutableArray alloc]init];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [assets insertObject:result atIndex:0];
        }
        
        
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allVideos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (assets.count) {
                
                ALAssetRepresentation *representation = [[assets objectAtIndex:0] defaultRepresentation];
                *stop = YES;
                self.LastVideo.image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                
            }
        }
        *stop = NO;
    };
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];

    
}
- (IBAction)Close:(id)sender {
    
    
    
    //remove data from UserDefault
    //Use: for detect for create post or not.
    //class:CreatePostVC
    //method: -(IBAction)SubmitToBButtnTap:(id)sender
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
    
    
    // View annimation
    
    //self.view.frame = CGRectMake(0,self.view.frame.size.height,self.view.frame.size.width, self.view.frame.size.height);
    
    
    [UIView animateWithDuration:.2
                          delay:.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         
                         [self dismissViewControllerAnimated:NO completion:nil];
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                         [UIView animateWithDuration:.5
                                               delay:.2
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
                                              
                                              
                                          }
                                          completion:^(BOOL finished){
                                              
                                              
                                              
                                          }];
                     }];
    


    
}





@end