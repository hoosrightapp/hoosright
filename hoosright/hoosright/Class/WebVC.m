//
//  WebVC.m
//  hoosright
//
//  Created by rupam on 9/25/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
{
    
    IBOutlet UIWebView *webView;
    
    
}

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
        if ([_From isEqual:@"privacy"]) {
        
        NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://doitte.com/hoosright/privacy_policy.html"]];
        [webView loadRequest:request];
        
        
    }
    
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
