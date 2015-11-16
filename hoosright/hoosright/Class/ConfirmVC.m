//
//  ConfirmVC.m
//  hoosright
//
//  Created by rupam on 8/10/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "ConfirmVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ConfirmVC ()<UIScrollViewAccessibilityDelegate,UITextViewDelegate>
{
    
    IBOutlet UILabel *VsLeb;
    IBOutlet UILabel *PostName;
    IBOutlet UIImageView *imageview1;
    IBOutlet UIImageView *imageview2;
    IBOutlet UITextView *DescriptionText;
    IBOutlet UITextView *DescriptionText1;
    NSString *temp_description1;
    
    
    NSMutableDictionary *postDic;
    
    NSString *imageurl1;
    NSString *imageurl2;
    
    NSString *videourl1;
    NSString *videourl2;
    UILabel *leb;
    
    IBOutlet UIButton *ConfirmBtn;
    IBOutlet UIScrollView *scrollView;
    CGPoint svos;
    
    
    
    
}

@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Confirm Post";
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden  = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    // NSLog(@"Value from standardUserDefaults: %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]);
    
    /*
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 24, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    */
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
    
    VsLeb.layer.cornerRadius = VsLeb.frame.size.width/2;
    VsLeb.layer.masksToBounds = YES;
    
    postDic = [[NSMutableDictionary alloc]init];
    
    // Keys are :PostImage , VideoURL , postdescription , postname ,tags, Videodata
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpostdata"];
    postDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    PostName.text = [postDic valueForKey:@"postname"];
    NSLog(@"postdescription : %@",[postDic valueForKey:@"postdescription"]);
    
    DescriptionText.text = [postDic valueForKey:@"postdescription"];
    DescriptionText.font = [UIFont fontWithName:@"GillSans-Light" size:13.0f];
    
    
    
    UIImage *image = [postDic valueForKey:@"PostImage"];
    
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
    
    imageview1.image = destImage;
    
    UIImage *image1 = _PassPostImage;
    
    float actualHeight1 = image1.size.height;
    float actualWidth1 = image1.size.width;
    float imgRatio1 = actualWidth1/actualHeight1;
    float maxRatio1 = 320.0/480.0;
    
    if(imgRatio1!=maxRatio1){
        if(imgRatio1 < maxRatio1){
            imgRatio1 = 480.0 / actualHeight1;
            actualWidth1 = imgRatio1 * actualWidth1;
            actualHeight1 = 480.0;
        }
        else{
            imgRatio1 = 320.0 / actualWidth1;
            actualHeight1 = imgRatio1 * actualHeight1;
            actualWidth1 = 320.0;
        }
    }
    CGRect rect1 = CGRectMake(0.0, 0.0, actualWidth1, actualHeight1);
    UIGraphicsBeginImageContext(rect1.size);
    
    [image1 drawInRect:rect1];
    UIImage *destImage1 = UIGraphicsGetImageFromCurrentImageContext();
    
    imageview2.image = destImage1;
    
    DescriptionText1.delegate = self;
    
    
    NSLog(@"%@",[postDic valueForKey:@"VideoURL"]);
    
    
    
    // NSLog(@"%lu",(unsigned long)[[postDic valueForKey:@"tags"] count]);
    
    
    int j = 0;
    int count = 0;
    int y = 2;
    int freespace = (self.view.frame.size.width - ((100*3)+(5*2)))/2;
    
    
    for (int i = 0; i<[[postDic valueForKey:@"tags"] count]; i++) {
        
        
        if(count%3 == 0)
        {
            leb = [[UILabel alloc]initWithFrame: CGRectMake(freespace, y , 100, 25)];
            leb.font = [UIFont fontWithName:@"GillSans-Italic" size:13.0f];
            leb.text = [[postDic valueForKey:@"tags"] objectAtIndex:i];
            leb.backgroundColor = [UIColor lightGrayColor];
            leb.textAlignment = NSTextAlignmentCenter;
            leb.textColor = [UIColor whiteColor];
            leb.layer.cornerRadius = 6;
            leb.layer.masksToBounds = YES;
        }
        else
        {
            
            leb = [[UILabel alloc]initWithFrame: CGRectMake(((100 + freespace)*(i%3))+5, y, 100, 25)];
            leb.font = [UIFont fontWithName:@"GillSans-Italic" size:13.0f];
            leb.text = [[postDic valueForKey:@"tags"] objectAtIndex:i];
            leb.backgroundColor = [UIColor lightGrayColor];
            leb.textColor = [UIColor whiteColor];
            leb.textAlignment = NSTextAlignmentCenter;
            leb.layer.cornerRadius = 6;
            leb.layer.masksToBounds = YES;
        }
        
        [self.view addSubview:leb];
        
        count = count+1;
        if (count % 3 == 0) {
            j = j+1;
            y = 0+(j*31);
        }
    }
    
    NSLog(@"%@",[postDic valueForKey:@"VideoURL"]);
    NSLog(@"%@",_PassPostVideoUrl);
    NSString *temp = [NSString stringWithFormat:@"%@",_PassPostVideoUrl];
    NSLog(@"%lu",(unsigned long)temp.length);
    
    if ([[postDic valueForKey:@"VideoURL"] isEqual:@""]) {
        
        
        if ([temp length] < 7 ) {
            
            ConfirmBtn.enabled = YES;
            
        }
        else
        {
            ConfirmBtn.enabled = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You Can Not Use Video. Use a Picture" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    else
    {
        ConfirmBtn.enabled = NO;
        if ([_PassPostVideoUrl isEqual:[NSURL URLWithString:@""]]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You Can Not Use Image. Use a Video" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else
        {
            ConfirmBtn.enabled = YES;
        }
    }

    
    
    self.navigationController.navigationBarHidden  = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
}
-(void)uploadimage :(UIImage *)image :(CGSize)imagesize
{
    
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(destImage, 90);
    
    
    NSString *filenames = [NSString stringWithFormat:@"TextLabel"]; //set name here
    //NSLog(@"%@", filenames);
    NSString *urlString = @"http://doitte.com/hoosright/imageUpload.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *uname = @"TheUserName";
    NSString *datestring = @"Photo";
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@%@.jpg\"\r\n", uname,datestring]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    
    NSRange result1 = [returnString rangeOfString:@".jpg"];
    
    
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
        
        if (result1.length >0) {
            
            imageurl2=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
            NSLog(@"%@",imageurl2);
            
            NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&uploaded_type=%@&image2=%@&video2=%@&post_desc2=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[postDic valueForKey:@"postID"],[postDic valueForKey:@"file_type"],imageurl2,@"",temp_description1];
            
            NSLog(@"%@",value);
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_friend.php"]];
            NSLog(@"my--%@",url);
            NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
            NSError *error;
            NSURLResponse *response;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
            
            
            
            
            NSMutableArray *json = [NSJSONSerialization
                                    JSONObjectWithData:urlData //1
                                    
                                    options:kNilOptions
                                    error:&error];
            
            NSLog(@"%@",json);
            
            
            if ([[json valueForKey:@"msg"] isEqual:@"Done post added!"]) {
                
                [self notificationstatus];
                
            }
            
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }


            
            
            
        }
        else
        {
            
        }
        
    }
    else
    {
       
        
        
        if (result1.length >0) {
            
            if (imageurl1.length >10) {
                
                imageurl2=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
            }
            else
            {
                imageurl1=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
            }
            
            
            
            
            
            if (imageurl2.length <7) {
                
                
                UIImage *image = _PassPostImage;
                CGSize imagesize = CGSizeMake(image.size.height, image.size.width);
                [self uploadimage:_PassPostImage:imagesize];
                
                
            }
            
            else
            {
                NSString *aValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_details"];
                
                
                NSLog(@"Value from standardUserDefaults: %@", aValue);
                
                
                NSString *tagtext = @"" ;
                
                for (int i=0; i<[[postDic valueForKey:@"tags"]count] ;i++) {
                    
                    NSString *list =[NSString stringWithFormat:@"%@,%@",[[postDic valueForKey:@"tags"] objectAtIndex:i],tagtext] ;
                    
                    tagtext =  list;
                    
                    //[NSString stringWithFormat:@"%@,%@",list,[data valueForKey:@"id"]];
                    
                    
                    NSLog(@"%@",tagtext);
                }
                if (tagtext.length>1) {
                    tagtext = [tagtext substringToIndex:[tagtext length]-1];
                }
                
                
                
                NSString *value = [NSString stringWithFormat:@"user_id=%@&post_name=%@&post_desc=%@&post_tag=%@&image1=%@&image2=%@&video1=%@&video2=%@&post_desc2=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[postDic valueForKey:@"postname"],[postDic valueForKey:@"postdescription"],tagtext,imageurl1,imageurl2,@"",@"",temp_description1];
                
                NSLog(@"%@",value);
                
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_to_B.php"]];
                NSLog(@"my--%@",url);
                NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
                NSError *error;
                NSURLResponse *response;
                NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
                
                
                
                
                NSMutableArray *json = [NSJSONSerialization
                                        JSONObjectWithData:urlData //1
                                        
                                        options:kNilOptions
                                        error:&error];
                
                NSLog(@"%@",[json valueForKey:@"msg"]);
                
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
                self.view.userInteractionEnabled = YES;
                
                if ([[json valueForKey:@"msg"] isEqual:@"Done post added!"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Posted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
            
        }
    }
    
    
    
   
}


-(void)UploadVideoRequest :( NSData *)mediaData
{
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        
        NSData *videoData = mediaData;
        long videoSize = [videoData length]/1024/1024;
        NSLog(@"%ld",videoSize);
   
        
        
        if(videoSize <= 25) // check size of video
        {
         
            
            NSString *filenames = [NSString stringWithFormat:@"TextLabel"];      //set name here
           // NSLog(@"%@", filenames);
            NSString *urlString = @"http://doitte.com/hoosright/upload_video.php";
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *uname = @"TheUserName";
            NSString *datestring = @"Photo";
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@%@.mov\"\r\n", uname,datestring]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:videoData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            
            
            NSRange result1 = [returnString rangeOfString:@".mp4"];
            
            if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
                
                
                videourl2=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
                
                
                
                
                
                
                NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&uploaded_type=%@&image2=%@&video2=%@&post_desc2=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[postDic valueForKey:@"postID"],@"V",@"",videourl2,temp_description1];
                
                NSLog(@"%@",value);
                
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_friend.php"]];
                NSLog(@"my--%@",url);
                NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
                NSError *error;
                NSURLResponse *response;
                NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
                
                
                
                
                NSMutableArray *json = [NSJSONSerialization
                                        JSONObjectWithData:urlData //1
                                        
                                        options:kNilOptions
                                        error:&error];
                
                if ([[json valueForKey:@"msg"] isEqual:@"Done post added!"]) {
                    
                    
                    
                    [self notificationstatus];
                    
                   /*
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Posted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    
                    
                    
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
                    self.view.userInteractionEnabled = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                    */
                    
                }
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
                
            }
            else
            {
                
                if (result1.length >0)
                {
                    
                    if (videourl1.length >10) {
                        
                        videourl2=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
                    }
                    else
                    {
                        videourl1=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
                    }
                    
                    
                    NSLog(@"%@",videourl1);
                    NSLog(@"%@",videourl2);
                    
                    if (videourl2.length <7) {
                        
                        
                        [self UploadVideoRequest:_passvideodata];
                        
                        
                    }
                    
                    else
                    {
                        NSString *aValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_details"];
                        
                        
                        NSLog(@"Value from standardUserDefaults: %@", aValue);
                        
                        
                        NSString *tagtext = @"" ;
                        
                        for (int i=0; i<[[postDic valueForKey:@"tags"]count] ;i++) {
                            
                            NSString *list =[NSString stringWithFormat:@"%@,%@",[[postDic valueForKey:@"tags"] objectAtIndex:i],tagtext] ;
                            
                            tagtext =  list;
                            
                            //[NSString stringWithFormat:@"%@,%@",list,[data valueForKey:@"id"]];
                            
                            
                            NSLog(@"%@",tagtext);
                        }
                        if (tagtext.length>1) {
                            tagtext = [tagtext substringToIndex:[tagtext length]-1];
                        }
                        
                        
                        
                        NSString *value = [NSString stringWithFormat:@"user_id=%@&post_name=%@&post_desc=%@&post_tag=%@&image1=%@&image2=%@&video1=%@&video2=%@&post_desc2=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[postDic valueForKey:@"postname"],[postDic valueForKey:@"postdescription"],tagtext,@"",@"",videourl1,videourl2,temp_description1];
                        
                        NSLog(@"%@",value);
                        
                        
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_to_B.php"]];
                        NSLog(@"my--%@",url);
                        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                        [theRequest setHTTPMethod:@"POST"];
                        [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                        [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
                        NSError *error;
                        NSURLResponse *response;
                        NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
                        
                        
                        
                        
                        NSMutableArray *json = [NSJSONSerialization
                                                JSONObjectWithData:urlData //1
                                                
                                                options:kNilOptions
                                                error:&error];
                        
                        NSLog(@"%@",[json valueForKey:@"msg"]);
                        
                        if ([[json valueForKey:@"msg"] isEqual:@"Done post added!"]) {
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Posted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            
                            
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
                            [self.view setUserInteractionEnabled:YES];
                            [self dismissViewControllerAnimated:YES completion:nil];
                            
                        }
                        
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }
                    }
                }
            }
            
            
        }
        else
        {
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Video must be less than 20 MB" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [al show];
        }
  
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
        });
    });
    
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Actions


#pragma mark - Confirm Button Action

- (IBAction)ConfirmBtnClick:(id)sender {
    
    ConfirmBtn.enabled = NO;
    
   
    
    UIImage *image = [postDic valueForKey:@"PostImage"];
    CGSize imagesize = CGSizeMake(image.size.height, image.size.width);
    
   
    
   
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
        
        NSLog(@"%@",[postDic valueForKey:@"file_type"]);
        if ([[postDic valueForKey:@"file_type"] isEqual:@"V"]) {
            
            [self UploadVideoRequest:_passvideodata];
        }
        else
        {
            
            CGSize imagesize1 = CGSizeMake(_PassPostImage.size.height, _PassPostImage.size.width);
            
            [self uploadimage:_PassPostImage:imagesize1];
        }
        
    }
    else
    {
        NSString *temp = [NSString stringWithFormat:@"%@",_PassPostVideoUrl];
        NSInteger lenght =temp.length;
        if (lenght > 10) {
            
            [self UploadVideoRequest:[postDic valueForKey:@"Videodata"]];
        }
        else
        {
            [self uploadimage:[postDic valueForKey:@"PostImage"]:imagesize];
        }
    }
    
    
    
   
}
- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
        if([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            return NO;
        }
        return YES;
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    
        
        
        svos = scrollView.contentOffset;
        CGPoint pt;
        CGRect rc = [DescriptionText1 bounds];
        rc = [DescriptionText1 convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 25;
        [scrollView setContentOffset:pt animated:YES];
   
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@",DescriptionText1.text);
    temp_description1 = textView.text;
    
    
    [scrollView setContentOffset:CGPointZero animated:YES];
}





-(void)notificationstatus
{
    
    NSString *value = [NSString stringWithFormat:@"notification_id=%@",[postDic valueForKey:@"notiID"]];
    
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
    
    
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Posted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
    self.view.userInteractionEnabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
