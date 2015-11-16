//
//  SignupPreviousVC.m
//  hoosright
//
//  Created by rupam on 6/11/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "SignupPreviousVC.h"
#import "SignupVC.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "NewsFeedVC.h"

@interface SignupPreviousVC ()<UITextFieldDelegate>
{
    
    IBOutlet UIImageView *background;
    IBOutlet UITextField *Emailtext;
}

@end

@implementation SignupPreviousVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //text field delegate
    Emailtext.delegate = self;
    
    
    
   
     if ([[UIScreen mainScreen] bounds].size.height == 568)
     {
         [background setImage:[UIImage imageNamed:@"SB2"]];
         
     }
     else if ([[UIScreen mainScreen] bounds].size.height == 480)
     {
         [background setImage:[UIImage imageNamed:@"SB1"]];
     
     
     }
     else
     {
         [background setImage:[UIImage imageNamed:@"SB3"]];
     
     }
     
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark  - /* Action */

- (IBAction)Signupnexttap:(id)sender {
    
    if (Emailtext.text.length > 0) {
        SignupVC *SignupVC_ = [[SignupVC alloc]init];
        SignupVC_.Email = Emailtext.text;
        NSLog(@"%@",Emailtext.text);
        [self.navigationController pushViewController:SignupVC_ animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Please Give Your Email - ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    
    
    
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
                      
                      /*
                       
                      NSString *value = [NSString stringWithFormat:@"email=%@&uname=%@&profile_pic=%@&name=%@",[result valueForKey:@"email"],[array objectAtIndex:0],feedpicStr,[result valueForKey:@"name"]];
                       
                       */
                      
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
                      
                      NSLog(@"%@",json1);
                      
                      
                      
                      
                      
                      [[NSUserDefaults standardUserDefaults] setObject:@"Login" forKey:@"Loginstatus"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      //save user Data
                      
                      [[NSUserDefaults standardUserDefaults] setObject:[json1 valueForKey:@"user_details"] forKey:@"Userdata"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      /************** For from on newsfeed*****************/
                      
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


@end
