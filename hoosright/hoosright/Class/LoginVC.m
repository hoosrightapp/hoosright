//
//  LoginVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/21/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "LoginVC.h"
#import "NewsFeedVC.h"
#import "CustomTabBarViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "InternetValidation.h"
#define LogInURL [NSURL URLWithString:@"http://doitte.com/hoosright/login.php"]
@interface LoginVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *signinBtn;
    IBOutlet UITextField *usernametext;
    IBOutlet UITextField *passwordtext;
    UIActivityIndicatorView *activity;
    CustomTabBarViewController *tabbarcontroler;
    
    
}

@end

@implementation LoginVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
   
    
    
    
    // set UITextField delegate
    
    usernametext.delegate = self;
    passwordtext.delegate = self;
    usernametext.text = nil;
    passwordtext.text = nil;
    
    
    //[usernametext becomeFirstResponder];
   
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return  YES;
//}


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
        [textField resignFirstResponder];
        
        [self Login];
        
        
        
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
    [self.tabBarController.tabBar setHidden:NO];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = YES;
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleDefault;  //make status bar default.
    
    [self.tabBarController.tabBar setHidden:YES];
}


#pragma mark - 
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - Login method
-(void)Login
{
    
    if ([InternetValidation connectedToNetwork])//check internet connection
    {
        activity = [[UIActivityIndicatorView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:activity];
        activity.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
        [activity startAnimating];
        
        if (usernametext.text.length >0 && passwordtext.text.length > 0) { // all field mandatory
            
            NSString *value = [NSString stringWithFormat:@"uname=%@&pwd=%@",usernametext.text,passwordtext.text];
            NSLog(@"%@",value );
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",LogInURL]];
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
            [activity stopAnimating];
            
            NSLog(@"%@",[json valueForKey:@"user_details"] );
            
            NSLog(@"%@",[json valueForKey:@"user_details"]);
            if ([[json valueForKey:@"status"]intValue] == 0) {
                
                UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Wrong Username or Password. Try Again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alart show];
                
            }
            else
            {
                //set user as login
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Login" forKey:@"Loginstatus"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //save user Data
                
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"user_details"] forKey:@"Userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                 [self dismissViewControllerAnimated:YES completion:NULL];
                
                
               
                
            }

        }
        else
        {
            [activity stopAnimating];
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Please Fill All Field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alart show];
        }
        
        
    }
    else
    {
        [activity stopAnimating];
        UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"NO Internet.Please Check Your Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alart show];
    }
    
    }

#pragma marrk - 
#pragma mark - Actions

- (IBAction)backTap:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
   
    
}
- (IBAction)signinTap:(id)sender {
    
    [self Login];
    
}

- (IBAction)FBLoginTap:(id)sender {

    [FBSession.activeSession closeAndClearTokenInformation];
    
        [FBSession openActiveSessionWithReadPermissions:@[@"email",@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             
             NSLog(@"%@",[session accessTokenData].accessToken );
             
             [[NSUserDefaults standardUserDefaults] setValue:[session accessTokenData].accessToken forKey:@"accesstoken"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             FBRequestConnection *connection = [[FBRequestConnection alloc] init];
             FBRequest *request1 = [FBRequest requestForMe];
             
             if (FBSession.activeSession.isOpen)
             {
                 
                 [connection addRequest:request1
                      completionHandler:
                  ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                      if (!error) {
                          
                          
                          
                          NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/%@?fields=id,name,bio,website,email,link,hometown&access_token=%@",[user valueForKey:@"id"],[session accessTokenData].accessToken]];
                          NSLog(@"my--%@",url1);
                          NSMutableURLRequest *theRequest1 = [[NSMutableURLRequest alloc] initWithURL:url1];
                          [theRequest1 setHTTPMethod:@"GET"];
                          [theRequest1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                          //NSError *error;
                          NSURLResponse *response1;
                          NSData *urlData1=[NSURLConnection sendSynchronousRequest:theRequest1 returningResponse:&response1 error:&error];
                          NSString *data1=[[NSString alloc]initWithData:urlData1 encoding:NSUTF8StringEncoding];
                          NSLog(@"%@",data1);
                          NSLog(@"%@",response1);

                          NSDictionary *result = [NSJSONSerialization
                                                 JSONObjectWithData:urlData1 //1
                                                 
                                                 options:kNilOptions
                                                 error:&error];
                              NSLog(@"%@",result);
                              
                              
                              NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/%@/picture?redirect=false&access_token=%@",[user valueForKey:@"id"],[session accessTokenData].accessToken]];
                              NSLog(@"my--%@",url);
                              NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                              [theRequest setHTTPMethod:@"GET"];
                              [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                              //NSError *error;
                              NSURLResponse *response;
                              NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
                              NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                              NSLog(@"%@",data);
                              NSLog(@"%@",response);
                              
                              NSMutableArray *json =[[NSMutableArray alloc]init];
                              // NSError *error;
                              json = [NSJSONSerialization
                                      JSONObjectWithData:urlData //1
                                      
                                      options:kNilOptions
                                      error:&error];
                              NSLog(@"%@",json);
                              
                              NSArray *array = [[result valueForKey:@"email"] componentsSeparatedByString:@"@"];
                              NSLog(@"%@",[array objectAtIndex:0]);
                              
                              
                              NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"&" options:NSRegularExpressionCaseInsensitive error:&error];
                              
                              NSString *feedpicStr = [regex1 stringByReplacingMatchesInString:[[json valueForKey:@"data"]valueForKey:@"url"] options:0 range:NSMakeRange(0, [[[json valueForKey:@"data"]valueForKey:@"url"] length]) withTemplate:@"*"];
                              
                              NSLog(@"%@",feedpicStr);
                              
                              
                              NSString *value = [NSString stringWithFormat:@"email=%@&uname=%@&profile_pic=%@&name=%@&facebook_id=%@",[result valueForKey:@"email"],[array objectAtIndex:0],feedpicStr,[result valueForKey:@"name"],[user valueForKey:@"id"]];
                              
                              NSLog(@"%@",value);
                              
                              
                              url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/facebook_register.php"]];
                              NSLog(@"my--%@",url);
                              theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                              [theRequest setHTTPMethod:@"POST"];
                              [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                              [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
                              
                              urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
                              
                              
                              
                              
                              NSDictionary *json1 = [NSJSONSerialization
                                                     JSONObjectWithData:urlData //1
                                                     
                                                     options:kNilOptions
                                                     error:&error];
                              
                              //NSLog(@"%@",json1);
                              
                              
                              
                              /************** For user login Status *****************/
                              
                              [[NSUserDefaults standardUserDefaults] setObject:@"Login" forKey:@"Loginstatus"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                          
                              
                                /************** For user detail *****************/
                              
                              [[NSUserDefaults standardUserDefaults] setObject:[json1 valueForKey:@"user_details"] forKey:@"Userdata"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                          
                          
                              
                          /************** For from on newsfeed  *****************/
                          
                          [[NSUserDefaults standardUserDefaults] setObject:@"Timeline" forKey:@"from"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                        
                          
                          [self dismissViewControllerAnimated:YES completion:NULL];
                              
                              
                          
                          
                      }
                      
                      
                  }
                  
                  ];
                 
                 [connection start];
             }
             
             
            
            
         }];
    
}
- (IBAction)ForgottenTap:(id)sender {
    
    
    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Type Your E-mail to Get Your Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    Alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [Alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld", (long)buttonIndex);
    
    if (buttonIndex==1) {
        NSError *error;
        NSString *value = [NSString stringWithFormat:@"email=%@",[alertView textFieldAtIndex:0].text];
        
        NSLog(@"%@",value);
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/send_password_reset_mail.php"]];
        NSLog(@"my--%@",url);
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
        //NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        
        
        
        NSDictionary *json1 = [NSJSONSerialization
                               JSONObjectWithData:urlData //1
                               
                               options:kNilOptions
                               error:&error];
        
        NSLog(@"%@",json1);
        
        
        
        
        if ([[json1 valueForKey:@"msg"] isEqual:@"Mail sent successfully!"]) {
            UIAlertView *Alert  = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Please Check Your Email. Reset Your Password From There" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
        
    }
    

}



@end
