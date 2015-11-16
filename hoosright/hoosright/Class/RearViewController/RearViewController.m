
#import "RearViewController.h"

#import "SWRevealViewController.h"
#import "HomeVC.h"
#import "NewsFeedVC.h"
#import "FriendListVC.h"
#import "MyProfileVC.h"
#import "AVCamViewController.h"
#import "SettingsVC.h"
#import <FacebookSDK/FacebookSDK.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface RearViewController()
{
    NSInteger _presentedRow;
    UIImageView *profilePic;
    UILabel *name;
    UIButton *videobtn;
    UIButton *settingsbtn;
    
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
    profilePic = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    name = [[UILabel alloc]initWithFrame:CGRectMake(20+profilePic.frame.size.width+10, 0, 180, 30)];
    videobtn = [[UIButton alloc]initWithFrame:CGRectMake(profilePic.frame.size.width+10, 50, 80, 20)];
    settingsbtn = [[UIButton alloc]initWithFrame:CGRectMake(profilePic.frame.size.width+100, 50, 80, 20)];
    _rearTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [_rearTableView reloadData];
}
#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
	_rearTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSString *text = nil;
    if (row == 0)
    {
        
        NSMutableArray *savedValue = [[NSUserDefaults standardUserDefaults]
                                objectForKey:@"Userdata"]; // retrive user data from userdefault
        NSLog(@"%@",savedValue);
        
        
        
        //setup profile picture
        
        profilePic.layer.cornerRadius = (profilePic.frame.size.width/2);
        profilePic.layer.masksToBounds = YES;
        
        [profilePic removeFromSuperview];
        
        [cell.contentView addSubview:profilePic];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[savedValue valueForKey:@"prof_image"]]]];
        
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
        profilePic.image = destImage;
        
        
        //[profilePic setImageWithURL:[savedValue valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];//set profile picture.
        
        
        

        //setup name
        
        name.font = [UIFont fontWithName:@"Gill Sans" size:24.0f];
        
        [name removeFromSuperview];
        [cell.contentView addSubview:name];
        name.textColor = [UIColor colorWithRed:0.878 green:0.314 blue:0.247 alpha:1.0];
        
        
        name.text = [savedValue valueForKey:@"user_name"]; //set name here.
        
        
        
        
        //my video button setup
        
        [videobtn setImage:[UIImage imageNamed:@"myposts"] forState:UIControlStateNormal];
        [videobtn addTarget:self
                     action:@selector(MyvideoTap:)
           forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:videobtn];
        
        //settings button setup
        
        
        [settingsbtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        [settingsbtn addTarget:self
                     action:@selector(settingsTap:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [settingsbtn removeFromSuperview];

        
        [cell.contentView addSubview:settingsbtn];
        
    }
    else if (row == 1)
    {
        text = @"TIMELINE";
    }
    /*
    else if (row == 2)
    {
        text = @"MY PROFILE";
    }
     
    else if (row == 2)
    {
        text = @"CREATE POST";
    }
     */
    else if (row == 2)
    {
        text = @"MY FRIENDS";
    }
    else if (row == 3)
    {
        text = @"FAVORITE POSTS";
    }
    else if (row == 4)
    {
        text = @"FEATURED POSTS";
    }
    else if (row == 5)
    {
        text = @"LOG OUT";
    }

    cell.textLabel.textColor = [UIColor colorWithRed:0.878 green:0.314 blue:0.247 alpha:1.0];
    cell.textLabel.text = NSLocalizedString( text,nil );
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 110.0f;
        
    }
    else
    {
        return 50.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Reload the selected cell automatically.
    
    NSLog(@" %@ ",indexPath);
    
    if (indexPath.row == 0)
    {
        [_rearTableView reloadData];
    }
    else
    {
        [_rearTableView deselectRowAtIndexPath:indexPath animated:YES];
        [_rearTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
    
    
    SWRevealViewController *revealController = self.revealViewController;
    NSInteger row = indexPath.row;

    if (row == 0)
    {
        
       
        
    }
    
    else if (row == 1)
    {
        NewsFeedVC *NewsFeedVC_ = [[NewsFeedVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        NewsFeedVC_.from = @"Timeline";
        
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    /*
    else if (row == 2)
    {
        UIViewController *newFrontController = [[MyProfileVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
     
    else if (row == 2)
    {
        UIViewController *newFrontController = [[AVCamViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }
     
     */
    else if (row == 2)
    {
        UIViewController *newFrontController = [[FriendListVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else if (row == 3)
    {
        NewsFeedVC *NewsFeedVC_ = [[NewsFeedVC alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        NewsFeedVC_.from = @"Favorite";
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else if (row == 4)
    {
        NewsFeedVC *NewsFeedVC_ = [[NewsFeedVC alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        
        NewsFeedVC_.from = @"Featured";
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else if (row == 5)
    {
        
        
        
        SWRevealViewController *revealController = self.revealViewController;
        
        NewsFeedVC *NewsFeedVC_=[[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        NewsFeedVC_.from = @"logout";
        
       [FBSession.activeSession closeAndClearTokenInformation];
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logOut];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Userdata"];
        [revealController pushFrontViewController:frontNavigationController animated:YES];
        
        
    }
    

}


#pragma mark  - /* Actions */


-(IBAction)MyvideoTap:(id)sender
{
    SWRevealViewController *revealController = self.revealViewController;
    NewsFeedVC *NewsFeedVC_ = [[NewsFeedVC alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
    NewsFeedVC_.from = @"Timeline";
    
    [revealController pushFrontViewController:navigationController animated:YES];
    
}
-(IBAction)settingsTap:(id)sender
{
    
    NSLog(@"settings");
   
    SWRevealViewController *revealController = self.revealViewController;
    
    UIViewController *newFrontController = [[SettingsVC alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
    
}

@end