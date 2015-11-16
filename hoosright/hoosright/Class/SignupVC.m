//
//  SignupVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 6/5/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "SignupVC.h"
#import "LoginVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "InternetValidation.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define SignUpURL [NSURL URLWithString:@"http://doitte.com/hoosright/register.php"]

@interface SignupVC ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *Unametext;
    IBOutlet UITextField *Emailtext;
    IBOutlet UITextField *Passwordtext;
    IBOutlet UIImageView *ProfilePicImgVw;
    IBOutlet UITextField *confirmpasswordtext;
    IBOutlet UITextField *nametext;
    UIImagePickerController *imagePicker;
    NSString *imageurl;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIImageView *headerbackground;
    
    IBOutlet UILabel *genaraltext;
    IBOutlet UIActivityIndicatorView *spiner;
    
    IBOutlet UIScrollView *ScrollVW;
    
    
     CGPoint svos;
    
    
}

@end

@implementation SignupVC
@synthesize Email;

- (void)viewDidLoad {
    [super viewDidLoad];

    spiner.hidden = YES;
    self.title = @"SignUp";
    
    UIColor *Color1 = [UIColor grayColor];
    UIColor *Color2 = [UIColor blackColor];
    
    NSString *Text1 = @"by continuing you are indicating that you have read our";
    NSString *Text2 = @"Privacy Policy";
    NSString *Text3 = @"and agree to the";
    NSString *Text4 = @"Terms & Conditions.";
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                      Text1,
                      Text2,
                      Text3,
                      Text4];
    
    
    
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: genaraltext.textColor
                                  };
    
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
    
    
        NSRange TextRange1 = [text rangeOfString:Text1];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color1}
                                range:TextRange1];
        
    
        NSRange TextRange2 = [text rangeOfString:Text2];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color2}
                                range:TextRange2];
        
        NSRange TextRange3 = [text rangeOfString:Text3];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color1}
                            range:TextRange3];
    
    
        NSRange TextRange4 = [text rangeOfString:Text4];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color2}
                            range:TextRange4];
    
    
    
   genaraltext.attributedText = attributedText;
    
    
    //Set tap Gesture on ProfilePicImgVw
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProfilePictap:)];//Set tap Gesture
    tapRecognizer.numberOfTapsRequired = 1; //Set no of tap require
    [ProfilePicImgVw addGestureRecognizer:tapRecognizer]; //Set tap Gesture on ProfilePicImgVw
    ProfilePicImgVw.userInteractionEnabled = YES; // Set ProfilePicImgVw user Interaction Enabled.
    ProfilePicImgVw.layer.cornerRadius = ProfilePicImgVw.frame.size.width/2; //make it round
    ProfilePicImgVw.clipsToBounds = YES;
    indicator.hidden = YES;
    
    //set uitextfield delegate
    Unametext.delegate = self;
    Emailtext.delegate = self;
    Passwordtext.delegate = self;
    nametext.delegate = self;
    confirmpasswordtext.delegate = self;
    
    
    //set email that comes from privious screen
    Emailtext.text = Email;
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"back"]
                                     style:UIBarButtonItemStylePlain
                                     target:self action:@selector(BackTap:)];
    self.navigationItem.leftBarButtonItem = logoutButton ;
    
    
    //Unlock if need.
    
    
    if ([ UIScreen mainScreen ].bounds .size.height < 500) {
        
        
        ScrollVW.frame = CGRectMake(ScrollVW.frame.origin.x, ScrollVW.frame.origin.y-50, ScrollVW.frame.size.width, ScrollVW.frame.size.height);
        headerbackground.frame = CGRectMake(headerbackground.frame.origin.x, headerbackground.frame.origin.y, headerbackground.frame.size.width, headerbackground.frame.size.height-50);
        
        CGRect ProfilePicFrame = ProfilePicImgVw.frame;
        ProfilePicFrame.origin.x = ProfilePicImgVw.frame.origin.x;
        ProfilePicFrame.origin.y = ProfilePicImgVw.frame.origin.y-25;
        
        ProfilePicImgVw.frame = ProfilePicFrame;
        
        
        CGRect indicatorFrame = indicator.frame;
        indicatorFrame.origin.x = indicator.frame.origin.x;
        indicatorFrame.origin.y = indicator.frame.origin.y-25;
        
        indicator.frame = indicatorFrame;
        
        
        
        
    }
     
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = NO;
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
    
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
     self.navigationController.navigationBarHidden  = YES;
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItext field delegate

/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
 */


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
        if (textField.tag != 0) {
            
            
            svos = ScrollVW.contentOffset;
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:ScrollVW];
            pt = rc.origin;
            pt.x = 0;
            pt.y -= 10;
            [ScrollVW setContentOffset:pt animated:YES];
        }
   
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        
        
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [ScrollVW setContentOffset:CGPointZero animated:YES];
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark -/* Methods*/


-(void)picFromGallery{
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,nil];
    

    [self presentViewController:imagePicker animated:YES completion:NULL];
    
    
}
-(void)picFromCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    }
    else
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    
    
}

#pragma  mark- uiimagepicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    ProfilePicImgVw.image = image;
    
    
    CGSize imagesize = CGSizeMake(image.size.width/2, image.size.height/2);
    [self uploadimage:ProfilePicImgVw.image :imagesize];
    
        
        
}

#pragma mark - Signup method

-(void)Signup
{
   
    if ([InternetValidation connectedToNetwork])  //check internet connection
    {
        
        [spiner startAnimating];
        spiner.hidden = NO;
        
        
        if ( Unametext.text.length > 0 && Emailtext.text.length > 0 && Passwordtext.text.length > 0 && imageurl.length > 0) {
            
            if ([Passwordtext.text isEqual:confirmpasswordtext.text]) {
                
                
                
                
                
                NSString *value = [NSString stringWithFormat:@"uname=%@&email=%@&pwd=%@&img_path=%@&name=%@",Unametext.text,Emailtext.text,Passwordtext.text,imageurl,nametext.text];
                
                NSLog(@"value :%@",value);
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SignUpURL]];
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
                
                
                if ([[json valueForKey:@"status"]intValue] == 1)
                    
                {
                    UIAlertView *alart = [[UIAlertView alloc]
                                          initWithTitle:@"HoosRight"
                                          message:@"You Have SignUp Successfully."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
                    
                    [alart show];
                    
                    
                    LoginVC *_LoginVC = [[LoginVC alloc]init];
                    [self.navigationController pushViewController:_LoginVC animated:YES];
                    
                    //[self dismissViewControllerAnimated:YES completion:nil];
                    
                    
                }
                else
                {
                    UIAlertView *alart = [[UIAlertView alloc]
                                          initWithTitle:@"HoosRight"
                                          message:@"Something Wrong. Try Again."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
                    
                    [alart show];
                    
                    
                }
                
            }
            else
            {
               
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Password Not Matched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alart = [[UIAlertView alloc]
                                  initWithTitle:@"HoosRight"
                                  message:@"Please Fill All Field or Please Give Your Picture "
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil];
            
            [alart show];
            
            
        }

        
        
        
    }
    else
    {
        
        
        UIAlertView *alart = [[UIAlertView alloc]
                              initWithTitle:@"HoosRight"
                              message:@"NO Internet.Please Check Your Internet Connection"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alart show];
    }
    spiner.hidden = YES;
}



#pragma mark - upload image to server
-(void)uploadimage :(UIImage *)image :(CGSize)imagesize
{
    
    indicator.hidden = NO;
    [indicator startAnimating];
    ProfilePicImgVw.alpha =.5f;
    

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
    ProfilePicImgVw.image = destImage;
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
    if (result1.length>0) {
        imageurl=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
        NSLog(@"%@",imageurl);
        
        [ProfilePicImgVw setImageWithURL:[NSURL URLWithString:imageurl]];
        
    }

    indicator.hidden = YES;
    [indicator stopAnimating];
    ProfilePicImgVw.alpha =1.0f;
    
    
}
/*
-(void)uploadimage :(UIImage *)image :(CGSize)imagesize
{
    
    
    
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *imageData = UIImageJPEGRepresentation(destImage, 90);
    NSString *imagePostUrl = [NSString stringWithFormat:@"%@", @"http://doitte.com/hoosright/imageUpload.php"];
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    NSError* error;
    NSDictionary *parameters = @{@"imageName": imageString};
    NSMutableURLRequest *req=[[AFHTTPRequestSerializer serializer]
                              multipartFormRequestWithMethod:@"POST"
                              URLString:imagePostUrl
                              parameters:parameters
                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                              {
                                  [formData appendPartWithFileData:imageData
                                                              name:@"image"
                                                          fileName:@"image"
                                                          mimeType:@"image/jpeg"];
                                  
                                  //NSLog(@"%@",error);
            }error:&error];
    
   // NSLog(@"%@",error);
    
    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:req
                                                                  success: ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response: %@", responseObject);
        
        // NSError* error;
        NSString *convertedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"string: %@",convertedString);
        NSRange result1 = [convertedString rangeOfString:@".jpg"];
        if (result1.length>0) {
            imageurl=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",convertedString];
            NSLog(@"%@",imageurl);
              indicator.hidden = YES;
              [indicator stopAnimating];
             ProfilePicImgVw.alpha =1.0f;
            [ProfilePicImgVw setImageWithURL:[NSURL URLWithString:imageurl]];
            
            
            
        }
        
    }
                                  
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
}];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[NSOperationQueue mainQueue] addOperation:op];
}
 
 */


#pragma mark- action sheet delegate datasource

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"From Photo Gallery"]) {
        [self picFromGallery];
        
    }
    if ([buttonTitle isEqualToString:@"Take New Pic"]) {
        [self picFromCamera];
    }
    
    
}
#pragma mark - /* Actions */


#pragma mark - Signup tap
- (IBAction)SignupTap:(id)sender {
    
    
     spiner.hidden = NO;
    
    
    
    if ([InternetValidation connectedToNetwork])  //check internet connection
    {
        
        [spiner startAnimating];
        spiner.hidden = NO;
        
        
        if ( Unametext.text.length > 0 && Emailtext.text.length > 0 && Passwordtext.text.length > 0 && imageurl.length > 0) {
            
            if ([Passwordtext.text isEqual:confirmpasswordtext.text]) {
                
                
                
                
                
                NSString *value = [NSString stringWithFormat:@"uname=%@&email=%@&pwd=%@&img_path=%@&name=%@",Unametext.text,Emailtext.text,Passwordtext.text,imageurl,nametext.text];
                
                NSLog(@"value :%@",value);
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SignUpURL]];
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
                
                
                if ([[json valueForKey:@"status"]intValue] == 1)
                    
                {
                    UIAlertView *alart = [[UIAlertView alloc]
                                          initWithTitle:@"HoosRight"
                                          message:@"You Have SignUp Successfully."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
                    
                    [alart show];
                    
                    
                    LoginVC *_LoginVC = [[LoginVC alloc]init];
                    [self.navigationController pushViewController:_LoginVC animated:YES];
                    
                    //[self dismissViewControllerAnimated:YES completion:nil];
                    
                    
                }
                else
                {
                    UIAlertView *alart = [[UIAlertView alloc]
                                          initWithTitle:@"HoosRight"
                                          message:@"Something Wrong. Try Again."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
                    
                    [alart show];
                    
                    
                }
                
            }
            else
            {
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Password Not Matched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alart = [[UIAlertView alloc]
                                  initWithTitle:@"HoosRight"
                                  message:@"Please Fill All Field or Please Give Your Picture "
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil];
            
            [alart show];
            
            
        }
        
        
        
        
    }
    else
    {
        
        
        UIAlertView *alart = [[UIAlertView alloc]
                              initWithTitle:@"HoosRight"
                              message:@"NO Internet.Please Check Your Internet Connection"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alart show];
    }
    spiner.hidden = YES;
    
    //[self Signup];
}

#pragma mark - ProfilePic tap

- (void)ProfilePictap:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc ]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Photo Gallery",@"Take New Pic", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - BackButton Tap

-(IBAction)BackTap:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
