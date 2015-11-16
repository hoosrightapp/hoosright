//
//  RequestConfirmVC.m
//  hoosright
//
//  Created by rupam on 8/21/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "RequestConfirmVC.h"
#import "AVCamViewController.h"
#import "Capture.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HUD.h"
@interface RequestConfirmVC ()
{
    IBOutlet UIImageView *Proflepic;
    IBOutlet UILabel *posttitel;
    IBOutlet UIImageView *postimage;
    
    IBOutlet UITextView *postdescription;
    
    IBOutlet UIButton *declineBtn;
    
    IBOutlet UIButton *contributebtn;
    NSDictionary *json;
    
    UIImage *VThumImage1;
    IBOutlet UIButton *play;
    
}

@end

@implementation RequestConfirmVC

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
//    [self PostDetail];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HUD showUIBlockingIndicator];
    
    Proflepic.hidden = YES;
    posttitel.hidden = YES;
    postimage.hidden = YES;
    postdescription.hidden = YES;
    declineBtn.hidden = YES;
    contributebtn.hidden = YES;
    play.hidden = YES;
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    Proflepic.layer.cornerRadius = Proflepic.frame.size.width/2;
    Proflepic.layer.masksToBounds = YES;
    
    declineBtn.layer.cornerRadius = 4.0f;
    declineBtn.layer.masksToBounds = YES;
    
    contributebtn.layer.cornerRadius = 4.0f;
    contributebtn.layer.masksToBounds = YES;
    json = [[NSDictionary alloc]init];
    
    
    [self performSelector:@selector(PostDetail) withObject:self afterDelay:1.0 ];
    
    
}


-(void)PostDetail
{
    
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&notification_master_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_PostId,_NotificationMasterId];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_notification_details.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
   json = [NSJSONSerialization
                          JSONObjectWithData:urlData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"%@",json);
    
    if ([[json valueForKey:@"msg"] isEqual:@"error getting notification details"]) {
        
        Proflepic.hidden = YES;
        posttitel.hidden = YES;
        postimage.hidden = YES;
        postdescription.hidden = YES;
        declineBtn.hidden = YES;
        contributebtn.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Wrong. Try Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        
        
    }
    else
    {
        
        // show image directlly if image or if video get thumble image
        
        if ([[[json valueForKey:@"post_details"] valueForKey:@"file_type"] isEqual:@"V"]) {
            
            
            // get thumble image from video url
            
            
//            
//            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]] options:nil];
//            AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//            NSError *error = NULL;
//            CMTime time = CMTimeMake(1, 65);
//            CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
//            NSLog(@"error==%@, Refimage==%@", error, refImg);
//            
//             postimage.image= [[UIImage alloc] initWithCGImage:refImg];
            
            
            
           //VThumImage1 = nil;
          
            NSError *err = NULL;
            CMTime time = CMTimeMake(1, 30);
            NSLog(@"%@",[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]);
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]] options:nil];
            AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generator.appliesPreferredTrackTransform = YES;
            CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
            VThumImage1 = [[UIImage alloc] initWithCGImage:imgRef] ;
            //CGImageRelease(imgRef);
            NSLog(@"%@",[[UIImage alloc] initWithCGImage:imgRef]);
           
            
          /*
            UIImage *image = VThumImage1;
            
            float actualHeight = image.size.height;
            float actualWidth = image.size.width;
            float imgRatio = actualWidth/actualHeight;
            float maxRatio = 320.0/480.0;
            
            if(imgRatio!=maxRatio){
                if(imgRatio < maxRatio){
                    imgRatio = 480.0 / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = 480.0;
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
             */
            
            
            postimage.image = VThumImage1;
          
            
        }
        
        else
        {
            
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]]]];
            
            float actualHeight = image.size.height;
            float actualWidth = image.size.width;
            float imgRatio = actualWidth/actualHeight;
            float maxRatio = 320.0/480.0;
            
            if(imgRatio!=maxRatio){
                if(imgRatio < maxRatio){
                    imgRatio = 480.0 / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = 480.0;
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
            
            //[postimage setImageWithURL:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]];
            
            postimage.image = destImage;
        }
        
        
        if (VThumImage1 == NULL) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Wrong. Try Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else
        {
            [Proflepic setImageWithURL:[[json valueForKey:@"post_details"]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
            posttitel.text = [[json valueForKey:@"post_details"]valueForKey:@"post_name"];
            
            postdescription.text = [[json valueForKey:@"post_details"]valueForKey:@"description"];
            
            if ([[[json valueForKey:@"post_details"] valueForKey:@"file_type"] isEqual:@"V"]) {
                play.hidden = NO;
                
            }
            else
            {
                play.hidden = YES;
            }
            
            
            Proflepic.hidden = NO;
            posttitel.hidden = NO;
            postimage.hidden = NO;
            postdescription.hidden = NO;
            declineBtn.hidden = NO;
            contributebtn.hidden = NO;
            

            
        }
        
        

    }
    
    [HUD hideUIBlockingIndicator];
    

    
}




- (IBAction)DeclineTap:(id)sender {
    
    
   // user_id(who sent request), (loggedin user id), post_id
    
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&current_user_id=%@",[[json valueForKey:@"post_details"]valueForKey:@"user_id"],_PostId,[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_decline.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    NSDictionary *json1 = [NSJSONSerialization
            JSONObjectWithData:urlData //1
            
            options:kNilOptions
            error:&error];
    
    NSLog(@"%@",json1);
    
    if ([[json1 valueForKey:@"msg"] isEqual:@"post declined"]) {
        
         [self notificationstatus:_NotificationMasterId];
        declineBtn.hidden = YES;
        contributebtn.hidden = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
       
    }
    
    
    
}
- (IBAction)ContributeTap:(id)sender {
    
    //[self notificationstatus:_NotificationMasterId];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
    
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc]init];
    [postdata setValue:posttitel.text forKey:@"postname"];
    [postdata setValue:postdescription.text forKey:@"postdescription"];
    
    
    NSLog(@"%@",[[json valueForKey:@"post_details"]valueForKey:@"id"]);
    [postdata setValue:[[json valueForKey:@"post_details"]valueForKey:@"id"] forKey:@"postID"];
    [postdata setValue:[[json valueForKey:@"post_details"]valueForKey:@"file_type"] forKey:@"file_type"];
    
    NSArray *components = [[[json valueForKey:@"post_details"]valueForKey:@"post_tags"]
                           componentsSeparatedByString:@","];
    
    NSLog(@"%@",components);
    //NSMutableArray *tagarr = [[NSMutableArray alloc]init];
    
    [postdata setObject:components forKey:@"tags"];
    [postdata setValue:_NotificationMasterId forKey:@"notiID"];
    
    /*
    if ([self.type isEqual:@"Video"]) {
        
        [postdata setValue:self.PassPostVideoUrl forKey:@"VideoURL"];
        [postdata setValue:self.passvideodata forKey:@"Videodata"];
    }
    else
    {
        [postdata setValue:@"" forKey:@"VideoURL"];
    }
    */
    
//   if ([self.type isEqual:@"Video"])
//   {
//       
//   }
//    else
//    {
//        UIImage *tempimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]]]];
//        
//    }
    
    
    
    
    if ([[[json valueForKey:@"post_details"] valueForKey:@"file_type"] isEqual:@"V"]) {
        
        
        [postdata setObject:VThumImage1 forKey:@"PostImage"];
        [postdata setValue:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"] forKey:@"VideoURL"];
        
        
        
        
    }
    
    else
    {
        
        UIImage *tempimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]]]];
        
        [postdata setObject:tempimage forKey:@"PostImage"];
        [postdata setValue:@"" forKey:@"VideoURL"];
        
    }

    
    
    
    
    
    
    
    
//
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:postdata] forKey:@"userpostdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"AcceptFriend" forKey:@"from"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    //[postdata setObject:tagarr forKey:@"tags"];
    
    AVCamViewController *_AVCamViewController = [[AVCamViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_AVCamViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)notificationstatus :(NSString *)id_str
{
    
    NSString *value = [NSString stringWithFormat:@"notification_id=%@",id_str];
    
    //NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/notification_status.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
     NSError *error;
     NSURLResponse *response;
     NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
     
     
     NSDictionary *json1 = [NSJSONSerialization
     JSONObjectWithData:urlData //1
     
     options:kNilOptions
     error:&error];
     
     NSLog(@"%@",json1);
     
    
}
- (IBAction)playVideoTap:(id)sender {
    
    
    
    NSURL *url = [NSURL URLWithString:[[json valueForKey:@"post_details"]valueForKey:@"upload_file1"]];
    NSLog(@"%@",url);
    
    
    Capture *_Capture = [[Capture alloc]init];
    _Capture.url = url;
    _Capture.image=[UIImage imageNamed:@"Noimage"];
    _Capture.type = @"Video";
    _Capture.from = @"NewsFeed";
    
    [self presentViewController:_Capture animated:YES completion:nil];
}





@end
