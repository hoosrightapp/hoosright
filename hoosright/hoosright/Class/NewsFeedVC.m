//
//  NewsFeedVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/21/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "NewsFeedVC.h"
#import "SWRevealViewController.h"
#import "NewsFeedCC.h"
#import "NewsFeedDetailVC.h"
#import "HomeVC.h"
#import "BNRPageloader.h"
#import "CommentVC.h"
#import "SearchVC.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface NewsFeedVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITableView *feedtable;
    UILabel *tagtext;
    BNRPageloader *pageLoader;
    int count;
    NSMutableArray *FeedArray;
    NewsFeedCC *cell;
    
    NSString *shareID;
    NSInteger postIndexPath;
    
    
    UIRefreshControl *refreshControl;
   
    
    
   
    
}
@property(nonatomic)BOOL loading;

@end

@implementation NewsFeedVC



- (void)viewDidLoad {
    
    [super viewDidLoad];
    pageLoader = [[BNRPageloader alloc] init];
    count = 0;
    
    /*
     
     UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"TabBarSelection@2x.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
     
    */
    
    
    UIImage *image = [UIImage imageNamed:@"logo_320x64.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    //self.navigationItem.titleView.hidden = YES;
    //set tableview delegate and datasource
    
    
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(GetPost)
             forControlEvents:UIControlEventValueChanged];
    [feedtable addSubview:refreshControl];
    feedtable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}


#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed :(NSString *)path{
    self.loading = YES;
    NSLog(@"%@",path);
    [pageLoader requestUrl:path
         completionHandler:^(id result) {
             {
                 NSLog(@"%@",result);
                 
                 for (NSDictionary *data in [result valueForKey:@"posts"]) {
                     
                     [FeedArray addObject:data];
                 }
                 [feedtable reloadData];
                 self.loading = NO;
                
                 
                 
                
             }
         }];
    
}

#pragma UIScrollView Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.loading == NO) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            
            NSString *path;
            
            
                count = count + 1;
            
            if ([_from isEqual:@"Timeline"]) {
                
                path = [NSString stringWithFormat:@"http://doitte.com/hoosright/user_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count];
                
                [self loadDataDelayed:path];
                NSLog(@"%@",path);
            }
            else if ([_from isEqual:@"Favorite"])
            {
                path = [NSString stringWithFormat:@"http://doitte.com/hoosright/favorite_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count];
                
                [self loadDataDelayed:path];
                NSLog(@"%@",path);
            }
            else if ([_from isEqual:@"Featured"])
            {
                
                if (count > 1) {
                    
                   
                }
                else
                {
                    path = [NSString stringWithFormat:@"http://doitte.com/hoosright/featured_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count];
                    
                    [self loadDataDelayed:path];
                    NSLog(@"%@",path);

                }
            }
            
            else
            {
                path = [NSString stringWithFormat:@"http://doitte.com/hoosright/favorite_all_user_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count];
                
                [self loadDataDelayed:path];
                NSLog(@"%@",path);

            }
            
            
            /*
                path = [NSString stringWithFormat:@"http://doitte.com/hoosright/user_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count];
             
             */
            
            
        }
    }
}



-(void)viewWillAppear:(BOOL)animated
{
   
    count = 0;
    
    if ([self.from isEqual:@""]) {
        self.from = [[NSUserDefaults standardUserDefaults]
                     objectForKey:@"from"];
    }
    NSLog(@"%@",self.from);
    NSLog(@"%ld",(long)[[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"] integerValue]);
    
    
    
    
    
    
    if ([self.from isEqual:@"settings"] || [self.from isEqual:@"logout"] ) {
       
        [[NSUserDefaults standardUserDefaults] setObject:@"Logout" forKey:@"Loginstatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController *newFrontController = [[HomeVC alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        self.from = @"";
        
        
  
    }
    else
    {
        self.navigationController.navigationBarHidden  = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self.tabBarController.tabBar setHidden:NO];
        
       
        
        // Set Left Bar Button
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationItem.hidesBackButton = YES;
        [UIApplication sharedApplication].
        statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
        
        SWRevealViewController *revealController = [self revealViewController];
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        
        
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                             style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(searchTap:)];
        self.navigationItem.rightBarButtonItem = search;
        
        
        
        
        
        /*********************************/
        
        
        if (![[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"] integerValue] == 0) {
            
            [self GetPost];
        }
       /**********************************/
        
        
    }
    
    
    
    
    
}

-(void)GetPost
{
    
    //NSLog(@"%@",_from);
    
    //NSLog(@"%@",refreshControl);
    
    
    
    if (refreshControl) {
        
        count = 0;
    }
    
    
  
    NSURL *url;
    
    if ([_from isEqual:@"Timeline"]) {
        
         url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/user_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count]];
    }
    else if ([_from isEqual:@"Favorite"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/favorite_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count]];
    }
    else if ([_from isEqual:@"Featured"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/featured_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count]];
    }
    
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/favorite_all_user_post.php?user_id=%@&limit=%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],count]];
    }
    
   
    
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    FeedArray = [[NSMutableArray alloc]init];
    NSMutableArray *json = [NSJSONSerialization
                            JSONObjectWithData:urlData //1
                            
                            options:kNilOptions
                            error:&error];
    
   
    NSLog(@"%@",json );
    if([[json valueForKey:@"msg"] isEqual:@"No More Records Available!"] || [[json valueForKey:@"msg"] isEqual:@"No record(s) are available!"] )
    {
        
        
        feedtable.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"No Post Yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        feedtable.delegate = self;
        feedtable.dataSource = self;
        
        for (NSDictionary *data in [json valueForKey:@"posts"]) {
            
            [FeedArray addObject:data];
        }
        [feedtable reloadData];
        self.loading = NO;

        
    }
   
    [refreshControl endRefreshing];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return FeedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    cell = (NewsFeedCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsFeedCC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
   
    
    NSArray *components = [[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"post_tags"]
                           componentsSeparatedByString:@","];
    
    
    
    
    //tag lable set

    for(int i = 0; i < components.count; i++)
    {
        if(i == 0)
        {
          tagtext = [[UILabel alloc]initWithFrame: CGRectMake(5, 10, 60, 20)];
        }
        else
        {
          tagtext = [[UILabel alloc]initWithFrame: CGRectMake(70*i- (5*(i-1)), 10, 60, 20)];
        }
        
        NSString *temp_tag = [components objectAtIndex:i];
        
        if (i < components.count) {
            
            tagtext.text = [components objectAtIndex:i];
        }
        else
        {
            tagtext.text = [temp_tag substringToIndex:[temp_tag length]-1];
        }
        
        
        tagtext.backgroundColor = [UIColor lightGrayColor];
        tagtext.textAlignment = NSTextAlignmentCenter;
        tagtext.textColor = [UIColor whiteColor];
        tagtext.font = [UIFont fontWithName:@"GillSans-Italic" size:10.0f];
        tagtext.layer.cornerRadius = 6;
        tagtext.layer.masksToBounds = YES;
        [cell.contentView addSubview:tagtext];
    }
    
  //  NSLog(@"%@",[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"post_name"]);
    cell.titel.text = [[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"post_name"];
 
    
    cell.date.text = [NSString stringWithFormat:@"Started %@ by @%@",[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"added_post"],[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"first_user"]];
    
    
    
    
    
    cell.vs.frame = CGRectMake(cell.vs.frame.origin.x, cell.vs.frame.origin.y, 30, 30);
    cell.vs.layer.cornerRadius = cell.vs.frame.size.width/2;
    cell.vs.layer.masksToBounds = YES;
    
    
    cell.profileimage1.layer.cornerRadius = cell.profileimage1.frame.size.width/2;
    cell.profileimage1.layer.masksToBounds = YES;
    [cell.profileimage1 setImageWithURL:[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"first_prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    cell.profileimage2.layer.cornerRadius = cell.profileimage2.frame.size.width/2;
    cell.profileimage2.layer.masksToBounds = YES;
    [cell.profileimage2 setImageWithURL:[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"second_prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    
    
    
    
    cell.user1.text = [NSString stringWithFormat:@"@%@",[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"first_user"]];
    cell.user2.text = [NSString stringWithFormat:@"@%@",[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"second_user"]];
    
    cell.descriptiontext.text = [[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"description"];
    
    
    
    //fevorite button setup
    
    [cell.favorite addTarget:self
                 action:@selector(favoriteTap:)
       forControlEvents:UIControlEventTouchUpInside];
    cell.favorite.tag = indexPath.row;
    
    if ([[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"isLike"] isEqual:@"N"]) {
        
        [cell.favorite setImage:[UIImage imageNamed:@"star-N"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.favorite setImage:[UIImage imageNamed:@"star-Y"] forState:UIControlStateNormal];
    }
    
    
    
    
    
    
    
    //fevorite comment setup
    
    [cell.comment addTarget:self
                      action:@selector(commentTap:)
            forControlEvents:UIControlEventTouchUpInside];
    cell.comment.tag = indexPath.row;
    
    
    
    
    //fevorite more setup
    
    [cell.more addTarget:self
                     action:@selector(moreTap:)
           forControlEvents:UIControlEventTouchUpInside];
    cell.more.tag = indexPath.row;

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedDetailVC *NewsFeedDetailVC_ = [[NewsFeedDetailVC alloc]init];
    
    
    //NSLog(@"%@",[[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"id"]);
    NewsFeedDetailVC_.PostID = [[FeedArray objectAtIndex:indexPath.row ]valueForKey:@"id"];
    
    [self.navigationController pushViewController:NewsFeedDetailVC_ animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}







#pragma mark - 
#pragma mark - Actions

-(IBAction)favoriteTap:(id)sender
{
    
    NSURL *url;
    if ([[[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"isLike"] isEqual:@"N"]) {
        
        [cell.favorite setImage:[UIImage imageNamed:@"star-Y"] forState:UIControlStateNormal];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_like.php"]];
    }
    else
    {
        [cell.favorite setImage:[UIImage imageNamed:@"star-N"] forState:UIControlStateNormal];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_unlike.php"]];
        
    }

    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&friend_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"id"],[[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"second_user_id"]];
    
    //NSLog(@"%@",value);
    
   // NSLog(@"my--%@",url);
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
    
    
   
    
    [FeedArray replaceObjectAtIndex:[sender tag] withObject:[json valueForKey:@"post_details"]];
    
    
    [feedtable beginUpdates];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [feedtable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [feedtable endUpdates];
    
    
    //NSLog(@"%@",json);
    
    
    
}




-(IBAction)commentTap:(id)sender
{
    CommentVC *CommentVC_ = [[CommentVC alloc]init];
    CommentVC_.PostID = [[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"id"];
    CommentVC_.user_id1 = [[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"user_id"];
    CommentVC_.user_id2 = [[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"second_user_id"];
    
    [self.navigationController pushViewController:CommentVC_ animated:YES];
}
-(IBAction)moreTap:(id)sender
{
    
    postIndexPath = [sender tag];
    
    shareID = [[FeedArray objectAtIndex:[sender tag] ]valueForKey:@"id"];
    
    
    UIActionSheet *actionsheet;
    if ([[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]
        ||[[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]) {
        
        //condition for delete my post.
        
        
        actionsheet = [[UIActionSheet alloc]initWithTitle:@"Select your option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete",@"Report as Inappropriate", nil];
    }
    
    else
    {
        actionsheet = [[UIActionSheet alloc]initWithTitle:@"Select your option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report as Inappropriate", nil];
    }
    
    
    // If need add ',@"Copy Share URL"' . For it need backend
    
    actionsheet.tag = 1;
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
}


-(IBAction)searchTap:(UIBarButtonItem *)sender
{
    SearchVC *SearchVC_ = [[SearchVC alloc]init];
    [self.navigationController pushViewController:SearchVC_ animated:YES];
}


#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    NSLog(@"%@",[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"second_user_id"]);
    NSLog(@"%@",[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"user_id"]);
    
    
    if ([[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]
        ||[[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]) {
        
        
        
        switch (popup.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                       
                        [self DeletePost];
                        
                        break;
                    case 1:
                        
                        [self Report];
                        
                        break;
                        
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }

        
    }
    
    else
    {
        switch (popup.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                        
                        [self Report];
                        
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }

    }
    
    }


#pragma mark - Action Sheet methods

#pragma mark - Report
-(void)Report
{
    
        NSString *temp = [NSString stringWithFormat:@"\n\n\n\n\n==== Please Do Not Delete====== \n Post Name: %@\n Post Description: %@\n==========================",[[FeedArray objectAtIndex:postIndexPath] valueForKey:@"post_name"],[[FeedArray objectAtIndex:postIndexPath] valueForKey:@"description"]];
    
        NSString *emailTitle = @"Report"; // Email Title
        
        NSString *messageBody = temp; // Email Content
        
        NSArray *toRecipents = [NSArray arrayWithObject:@"Info@hoosrightapp.com"];  // To address
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    
    
    
}

#pragma mark - Share to FB
-(void)ShareFB
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        

        NSString *value = [NSString stringWithFormat:@"post_id=%@",shareID];
        //NSLog(@"%@",value );
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/fb_share_link.php"]];
      //  NSLog(@"my--%@",url);
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
        
       // NSLog(@"%@",json);
        
        NSString *tempURL = [json valueForKey:@"fb_link"];
        [controller addURL:[NSURL URLWithString:tempURL]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}



#pragma mark - Copy URL

-(void)CopyURL
{
    NSString *value = [NSString stringWithFormat:@"post_id=%@",shareID];
    //NSLog(@"%@",value );
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/fb_share_link.php"]];
    //NSLog(@"my--%@",url);
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
    
    //NSLog(@"%@",json);
    
    NSString *tempURL = [json valueForKey:@"fb_link"];
    
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:tempURL];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have sucessfully copied the link." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

#pragma mark - Delete Post
-(void)DeletePost
{
    
    
    
    NSString *value = [NSString stringWithFormat:@"post_id=%@",shareID];
    NSLog(@"%@",value );
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_delete.php"]];
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
    
    
    if ([[json valueForKey:@"msg"] isEqual:@"Post Deleted Successfully!"] ) {
        
        
        [self GetPost];
    }
    
    
    
    
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have sucessfully copied the link." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];

    
}
@end
