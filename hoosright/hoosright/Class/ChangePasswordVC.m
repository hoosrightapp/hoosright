//
//  ChangePasswordVC.m
//  hoosright
//
//  Created by rupam on 9/25/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>
{
    IBOutlet UITextField *CurrentPasstext;
    IBOutlet UITextField *NewPasstext;
    IBOutlet UITextField *ConfirmPasstext;
    
}

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Password";
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
    NewPasstext.delegate = self;
    CurrentPasstext.delegate = self;
    ConfirmPasstext.delegate = self;
    
    [CurrentPasstext becomeFirstResponder];
    
    
    
}

#pragma mark - Change Password Method

-(void)ChangePassword
{
    
    if (CurrentPasstext.text.length >0 && NewPasstext.text.length >0 && ConfirmPasstext.text.length >0) {
        
        if ([NewPasstext.text isEqual:ConfirmPasstext.text]) {
            
            NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]);
            NSString *value = [NSString stringWithFormat:@"user_name=%@&cur_pass=%@&pass=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"user_name"],CurrentPasstext.text,NewPasstext.text];
            
            NSLog(@"%@",value);
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/change_password.php"]];
            NSLog(@"my--%@",url);
            NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
            NSError *error;
            NSURLResponse *response;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
            
            
            
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:urlData //1
                                  
                                  options:kNilOptions
                                  error:&error];
            
            NSLog(@"%@",json );
            
            if ([[json valueForKey:@"status"]integerValue] == 1 ) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HoosRight" message:@"Password changed successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HoosRight" message:@"Try With Different Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HoosRight" message:@"Password Doesnot Not Matched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HoosRight" message:@"Please Fill All Field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField  resignFirstResponder];
    return YES;
}



#pragma mark - Back Butto Press
- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Change Password Action
- (IBAction)changePasswordTap:(id)sender {
    
    
    [self ChangePassword];
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
