//
//  Capture.m
//  hoosright
//
//  Created by rupam on 7/10/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "Capture.h"
#import "CreatePostVC.h"
#import "TWVideoPlayer.h"
#import "ConfirmVC.h"

@interface Capture ()
{
    TWVideoPlayer *videoPlayer;
    IBOutlet UIButton *nextbtn;
}
@property (strong, nonatomic) IBOutlet UIImageView *LargeImage;

@end

@implementation Capture

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.LargeImage.contentMode = UIViewContentModeCenter;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.tabBarController.tabBar setHidden:YES];
    [self display :self.url :self.image :self.type];
    
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
    
    self.navigationController.navigationBarHidden  = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void)display :(NSURL *)url :(UIImage *)image :(NSString *)type
{
    if ([self.from isEqual:@"createVC"] ||[self.from isEqual:@"NewsFeed"])
    {
        nextbtn.hidden = YES;
    }
    if ([type isEqual:@"Video"]) {
        
        
        videoPlayer = [[TWVideoPlayer alloc]
                       initWithContentURL:url];
        
        //self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin ;
        [videoPlayer prepareToPlay];
        
        [videoPlayer.view removeFromSuperview];
        CGRect videoRect = (CGRect) {
            .size.width = 320,
            .size.height = 351,
            .origin.x =(self.view.frame.size.width - 320)/2,
            .origin.y = (self.view.frame.size.height - 351)/2,
        };
        [self.view addSubview:videoPlayer.view];
        videoPlayer.view.frame = videoRect;
        videoPlayer.controlStyle = MPMovieControlStyleNone;
    }
    else
    {
        
        
        
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 320.0/354.0;
        
        if(imgRatio!=maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = 351.0 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 351.0;
            }
            else{
                imgRatio = 320.0 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 320.0;
            }
        }
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        
        [image drawInRect:rect];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        //ProfilePicImgVw.image = destImage;
        self.LargeImage.image = destImage;
        UIGraphicsEndImageContext();

       
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    
    if ([self.from isEqual:@"createVC"] ||[self.from isEqual:@"NewsFeed"] )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [videoPlayer stop];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)next:(id)sender {
    
    if ([self.type isEqual:@"Video"]) {
       
        if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"FromB"]|| [[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
            ConfirmVC *ConfirmVC_ = [[ConfirmVC alloc]init];
            ConfirmVC_.PassPostImage = self.image;
            ConfirmVC_.Type = @"Video";
            ConfirmVC_.PassPostVideoUrl = self.url;
            NSLog(@"%@",_passvideodata);
            ConfirmVC_.passvideodata = _passvideodata;
            
            
            
            [self.navigationController pushViewController:ConfirmVC_ animated:YES];
            
        }
        else
        {
            CreatePostVC *CreatePostVC_ = [[CreatePostVC alloc]init];
            CreatePostVC_.PassPostImage = self.image;
            CreatePostVC_.type = @"Video";
            CreatePostVC_.PassPostVideoUrl = self.url;
            CreatePostVC_.passvideodata= _passvideodata;
            [self.navigationController pushViewController:CreatePostVC_ animated:YES];
        }
        
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"FromB"]|| [[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
            
            ConfirmVC *ConfirmVC_ = [[ConfirmVC alloc]init];
            ConfirmVC_.PassPostImage = self.LargeImage.image;
            ConfirmVC_.Type = @"Image";
            [self.navigationController pushViewController:ConfirmVC_ animated:YES];
        }
        else
        {
            CreatePostVC *CreatePostVC_ = [[CreatePostVC alloc]init];
            CreatePostVC_.PassPostImage = self.LargeImage.image;
            CreatePostVC_.type = @"Image";
            [self.navigationController pushViewController:CreatePostVC_ animated:YES];
            
        }
        
        

        
    }
    
    
    
}

@end
