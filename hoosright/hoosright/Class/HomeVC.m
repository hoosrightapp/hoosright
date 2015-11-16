//
//  HomeVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/21/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "HomeVC.h"
#import "LoginVC.h"
#import "SignupPreviousVC.h"

@interface HomeVC ()
{
    
    IBOutlet UIButton *LogInBtn;
    IBOutlet UIButton *SignUpBtn;
    
    
    
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480 )
    {
        LogInBtn.layer.cornerRadius = 20;
        LogInBtn.layer.masksToBounds = YES;
        
        SignUpBtn.layer.cornerRadius = 20;
        SignUpBtn.layer.masksToBounds = YES;

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568 )
    {
        LogInBtn.layer.cornerRadius = 25;
        LogInBtn.layer.masksToBounds = YES;
        
        SignUpBtn.layer.cornerRadius = 25;
        SignUpBtn.layer.masksToBounds = YES;
        
    }
    else
    {
        LogInBtn.layer.cornerRadius = 30;
        LogInBtn.layer.masksToBounds = YES;
        
        SignUpBtn.layer.cornerRadius = 30;
        SignUpBtn.layer.masksToBounds = YES;

    }
    [[SignUpBtn layer] setBorderWidth:2.0f];
    [[SignUpBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //set navigation bar hidden
    self.navigationController.navigationBarHidden  = YES;
    [self.tabBarController.tabBar setHidden:NO];
}


-(void)viewWillAppear:(BOOL)animated
{    
    [self.tabBarController.tabBar setHidden:YES];
}



#pragma mark - 
#pragma mark - Actions
- (IBAction)Logintap:(id)sender {
    
    LoginVC *LoginVC_ = [[LoginVC alloc]init];
    [self.navigationController pushViewController:LoginVC_ animated:YES];
    
}
- (IBAction)Signuptap:(id)sender {
    
    SignupPreviousVC *SignupPreviousVC_ = [[SignupPreviousVC alloc]init];
    [self.navigationController pushViewController:SignupPreviousVC_ animated:YES];
    
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
