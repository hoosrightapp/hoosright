//
//  SettingsVC.m
//  hoosright
//
//  Created by rupam on 8/4/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "SettingsVC.h"
#import "NewsFeedVC.h"
#import "HomeVC.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "RearViewController.h"
#import "SettingsCC.h"
#import "FriendListVC.h"
#import "EditProfileVC.h"
#import "WebVC.h"
#import "ChangePasswordVC.h"
#import <MessageUI/MessageUI.h>



@interface SettingsVC ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *SettingsTable;
    NSMutableArray *TableListArray1;
    NSMutableArray *TableListArray2;
    NSMutableArray *TableListArray3;
    NSMutableArray *TableListArray4;
    int count;
    SettingsCC *SettingsCC_ ;
   
   
}

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //mySwitch = [[UISwitch alloc] init];
    
    
    
    
    
    UIBarButtonItem *backBtn= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered target:self action:@selector(BackTap)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
    
   // NSLog(@"%f",self.view.)
    
    
    self.title = @"Settings";
    
    SettingsTable.delegate = self;
    SettingsTable.dataSource = self;
    
    TableListArray1 = [NSMutableArray arrayWithObjects:@"Friends On Facebook",@"Your Contacts",@"Invite New Friends",nil];
    
    TableListArray2 = [NSMutableArray arrayWithObjects:@"Edit Profile",@"Change Password",@"Post's You've Liked",@"Private Account",nil];
    
    TableListArray3 = [NSMutableArray arrayWithObjects:@"Push Notification Settings",@"Save Original Photos/Videos",nil];
    
    TableListArray4 = [NSMutableArray arrayWithObjects:@"Report a Problem",@"Privacy Policy",nil];
    [SettingsTable reloadData];
    
}
-(void)BackTap
{
    SWRevealViewController *revealController = self.revealViewController;
    
    NewsFeedVC *NewsFeedVC_=[[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
   
    
    [revealController setFrontViewController:frontNavigationController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    else if(section == 1)
    {
        return 4;
    }
    else if(section == 2){
        return 2;
    }
    else if(section == 3){
        return 2;
    }
    else if(section == 4){
        return 1;
    }
    else
    {
        return 0;
    }
    
    
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // UIView *sectionHeaderView;
    
    if (section == 0) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, tableView.frame.size.width, 35.0)];
        
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 5, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text = @"START FOLLOWING";
        
        return sectionHeaderView;
        
    }
    else if (section == 1) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, tableView.frame.size.width, 35.0)];
        
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 5, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text = @"MY ACCOUNT";
        
        return sectionHeaderView;
        
    }
    else if (section == 2) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, tableView.frame.size.width, 35.0)];
        
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 5, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text = @"SETTINGS";
        
        return sectionHeaderView;
        
    }
    else if (section == 3) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, tableView.frame.size.width, 80.0)];
        
        
        
        
        
        UILabel *headerLabeltext = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 5, sectionHeaderView.frame.size.width-30, 40.0)];
        
        headerLabeltext.backgroundColor = [UIColor clearColor];
        headerLabeltext.textAlignment = NSTextAlignmentLeft;
        headerLabeltext.textColor = [UIColor grayColor];
        headerLabeltext.numberOfLines = 0;
        headerLabeltext.font = [UIFont systemFontOfSize:11.0f];
        [sectionHeaderView addSubview:headerLabeltext];
        headerLabeltext.text = @"Making your account private will prevent anyone that in not your friend from viewing your posts. Your existing friends will not be affected by this. ";
        
        
        
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 50, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text = @"SUPPORT";
        
        return sectionHeaderView;
        
    }
    else
    {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
        
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 5, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text = @"";
        
        return sectionHeaderView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 0 || section == 1 ||section == 2 || section == 4)
    {
        return 35.0f;
    }
    else{
        
        return 80.0f;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        
        
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        
        SettingsCC_ = (SettingsCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (SettingsCC_ == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCC" owner:self options:nil];
            SettingsCC_ = [nib objectAtIndex:0];
        }
        SettingsCC_.textLabel.font = [UIFont systemFontOfSize:12.0f];
        SettingsCC_.textLabel.text = [TableListArray2 objectAtIndex:indexPath.row];
        
        if (indexPath.row == 2) {
            
            SettingsCC_.mySwitch.hidden = NO;
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryNone];
            SettingsCC_.mySwitch.tag = 1;
            [SettingsCC_.mySwitch setOn:YES animated:NO];
            [SettingsCC_.mySwitch setOnTintColor:[UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0]];
            [SettingsCC_.mySwitch addTarget: self action: @selector(SwitchAction:) forControlEvents:UIControlEventValueChanged];
           
            
        }
        
        else
        {
            SettingsCC_.mySwitch.hidden = YES;
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryNone];
        }
        
         return SettingsCC_;
    }

    else if (indexPath.section == 2 ) {
        
       
        static NSString *simpleTableIdentifier = @"SimpleTableCell";
        
       SettingsCC_ = (SettingsCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (SettingsCC_ == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCC" owner:self options:nil];
            SettingsCC_ = [nib objectAtIndex:0];
        }
        
        SettingsCC_.textLabel.font = [UIFont systemFontOfSize:12.0f];
        SettingsCC_.textLabel.text = [TableListArray3 objectAtIndex:indexPath.row];
        
        if (indexPath.row == 1) {
            
            
            SettingsCC_.mySwitch.hidden = NO;
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryNone];
            SettingsCC_.mySwitch.tag = 2;
           [SettingsCC_.mySwitch setOn:YES animated:NO];
            [SettingsCC_.mySwitch setOnTintColor:[UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0]];
            [SettingsCC_.mySwitch addTarget: self action: @selector(SwitchAction:) forControlEvents:UIControlEventValueChanged];
            
           
        }
        
        else
        {
            SettingsCC_.mySwitch.hidden = YES;
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
           // SettingsCC_.textLabel.text = [TableListArray2 objectAtIndex:indexPath.row];
            [SettingsCC_ setAccessoryType:UITableViewCellAccessoryNone];
        }
        
         return SettingsCC_;
        
    }
    
    else
    {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        if (indexPath.section == 0 ) {
            
            cell.textLabel.text = [TableListArray1 objectAtIndex:indexPath.row];
        }
       
        else if (indexPath.section == 3 ) {
            
            cell.textLabel.text = [TableListArray4 objectAtIndex:indexPath.row];
        }
        else
        {
            cell.textLabel.text = @"Log Out";
        }
        
        
        
        return cell;

        
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ( indexPath.section ==0) {
        
      
        
        if (indexPath.row == 0) {
            
            NSMutableArray *savedValue = [[NSUserDefaults standardUserDefaults]
                                          objectForKey:@"Userdata"]; // retrive user data from userdefault
           // NSLog(@"%@",savedValue);
            
            
            if ([[savedValue valueForKey:@"facebook_id"] isEqual:@""]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@" You are not connected with Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                FriendListVC *FriendListVC_ = [[FriendListVC alloc]init];
                FriendListVC_.from = @"FB";
                
                [self.navigationController pushViewController:FriendListVC_ animated:YES];
            }
            
        }
        
        else if (indexPath.row == 1) {
            
          
            
            NSString *textToShare = @"Look At This Awesome App";
            NSURL *myWebsite = [NSURL URLWithString:@"http://www.google.com/"];
            
            NSArray *objectsToShare = @[textToShare, myWebsite];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            [self presentViewController:activityVC animated:YES completion:nil];
            
            
            
        }
        
        
        else if (indexPath.row == 2) { // Invite Friend
            
            
            NSString *textToShare = @"Look At This Awesome App";
            NSURL *myWebsite = [NSURL URLWithString:@"http://www.google.com/"];
            
            NSArray *objectsToShare = @[textToShare, myWebsite];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            /*
            NSArray *excludeActivities = @[UIActivityTypePostToFacebook,
                                           UIActivityTypePostToTwitter,
                                           UIActivityTypePostToWeibo,
                                           UIActivityTypeMessage,
                                           UIActivityTypeMail,
                                           UIActivityTypePrint,
                                           UIActivityTypeCopyToPasteboard,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToFlickr,
                                           UIActivityTypePostToVimeo,
                                           UIActivityTypePostToTencentWeibo,
                                           UIActivityTypeAirDrop];*/
            
            
            
            
            //activityVC.excludedActivityTypes = excludeActivities;
            
            [self presentViewController:activityVC animated:YES completion:nil];
        }
        
        
    }
    
    else if (indexPath.section ==1)
    {
        
        if (indexPath.row == 0) {   //Edit Profile
            
            EditProfileVC *EditProfileVC_ = [[EditProfileVC alloc]init];
            
            
            [self presentViewController:EditProfileVC_ animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1) { // Change Password
            
            ChangePasswordVC *ChangePasswordVC_ = [[ChangePasswordVC alloc]init];
            [self.navigationController pushViewController:ChangePasswordVC_ animated:YES];
                       
            
        }
        
        
    }
    
    
    else if (indexPath.section ==3)
    {
        
        
        
        if (indexPath.row == 0) { //Report as a mail
            
            NSString *emailTitle = @"Report"; // Email Title
            
            NSString *messageBody = @"  "; // Email Content
           
            NSArray *toRecipents = [NSArray arrayWithObject:@"Info@hoosrightapp.com"];  // To address
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
            
            
        }
        else if (indexPath.row == 1) //privacy policy
        {
            WebVC *WebVC_ = [[WebVC alloc]init];
            WebVC_.From = @"privacy";
            
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(didDismissSecondViewController)
//                                                         name:@"SecondViewControllerDismissed"
//                                                       object:nil];
            [self presentViewController:WebVC_ animated:YES completion:nil];
            
        }
    }
    
    if (indexPath.section == 4) {
        
        
        
        
        
        SWRevealViewController *revealController = self.revealViewController;
        
        NewsFeedVC *NewsFeedVC_=[[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        NewsFeedVC_.from = @"settings";
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 64);
        [revealController setFrontViewController:frontNavigationController];
        
        
        
        
        
        
        
    }
    
}

- (IBAction)SwitchAction:(id)sender {
    
    if ([sender tag] == 1) {
        
        
        BOOL state = [sender isOn];
//        NSString *rez = state == YES ? @"YES" : @"NO";
//        NSLog(@"%@",rez);
        if (state == YES)
        {
            NSLog(@"On");
        }
        else
        {
            
            NSLog(@"Off");
        }
    }
    else
    {
        BOOL state = [sender isOn];
        
        //        NSString *rez = state == YES ? @"YES" : @"NO";
        //        NSLog(@"%@",rez);
        if (state == YES)
        {
            NSLog(@"On");
        }
        else
        {
            
            NSLog(@"Off");
        }
    }
    
    
}




#pragma mark - 
#pragma mark - Email  delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    SettingsTable.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 180);
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent");
            
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"We Recieved Your E-mail. We Will Get Back to You" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [Alert show];
        }
            
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [Alert show];
        }
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
