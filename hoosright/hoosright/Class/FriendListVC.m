//
//  FriendListVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/23/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "FriendListVC.h"
#import "FriendListCC.h"
#import "SWRevealViewController.h"
#import "MyProfileVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface FriendListVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UISearchBar *Searchbar;
    IBOutlet UITableView *FriendTable;
    IBOutlet UILabel *NoofFriend;
    
    
    NSMutableArray *FriendArray; //friend array
    
    
    //
    NSString *videourl1;
    NSString *imageurl1;
    NSMutableDictionary *postDic;
    NSString *FriendID;
    
    
}

@end

@implementation FriendListVC

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    self.title = @"Friends";
    
    //array allocation
    
    FriendArray = [[NSMutableArray alloc]init];
    postDic = [[NSMutableDictionary alloc]init];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpostdata"];
    postDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
   // NSLog(@"%@",postDic);
    
    
    
    // Set Left Bar Button
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.view.userInteractionEnabled = YES;
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    if ([self.from isEqual:@"Friend"] || [self.from isEqual:@"Request"] ) {
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                             style:UIBarButtonItemStylePlain target:self action:@selector(backTap)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;

    }
    else
    {
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                             style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;

    }
    
    
    
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"search"]
                                    forSearchBarIcon:UISearchBarIconSearch
                                               state:UIControlStateNormal];
    
    // set Search Bar textfield background image
    [Searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Searchbar"]
                                                   forState:UIControlStateNormal];
    
    [Searchbar setPositionAdjustment:UIOffsetMake(15, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    [Searchbar setImage:[UIImage imageNamed:@"blank"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    
    //searchbar delegare
    Searchbar.delegate = self;
    
    //tableView delecate and datasource
    FriendTable.delegate = self;
    FriendTable.dataSource = self;
    
    
    
    /*
     
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
  //  [self.view addGestureRecognizer:tap];
    
    */
    
    
    
    FriendTable.hidden = YES; // initially friend table hidden.
    NoofFriend.hidden = YES; // initially No of friend lable hidden.
    
    [self performSelector:@selector(Myfriends) withObject:nil afterDelay:.1]; // fetch friend after .1 sec delay.
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleDefault;  //make status bar default.
    
   // [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - 
#pragma mark - dismissKeyboard
- (void) dismissKeyboard
{
    // add self
    [Searchbar resignFirstResponder];
}

#pragma mark -
#pragma mark - searchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self SearchFriend:Searchbar.text];
    searchBar.text = nil;
    
    [searchBar resignFirstResponder];
}

#pragma mark - 
#pragma mark - User Friends

-(void)Myfriends
{
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/my_friends.php"]];
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
    
     NSLog(@"%@",json);
    
    if ([[json valueForKey:@"msg"]isEqual:@"No friend(s) are found!"]) {
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You Have No Friend Yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        FriendTable.hidden = YES;
        NoofFriend.hidden = NO;
        NoofFriend.text = [NSString stringWithFormat:@"0 Friend"];
        
        
    }
    else
    {
        
        for (NSDictionary *data in [json valueForKey:@"friends"]) {
            
            [FriendArray addObject:data];
        }
        FriendTable.hidden = NO;
        NoofFriend.hidden = NO;
        NoofFriend.text = [NSString stringWithFormat:@"%lu Friends",(unsigned long)[FriendArray count]];
        
        [FriendTable reloadData];
        
    }
    
   
    
}


#pragma mark -
#pragma mark - Search Friends

-(void)SearchFriend :(NSString *)searchword
{
    NSString *value = [NSString stringWithFormat:@"sname=%@&user_id=%@",searchword,[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/friend_search.php"]];
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
    
    NSLog(@"%@",json);
    
    [FriendArray removeAllObjects];
    
    if ([[json valueForKey:@"availability"]isEqual:@"No"]) {
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"No Friend Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        FriendTable.hidden = YES;
        NoofFriend.hidden = NO;
        NoofFriend.text = [NSString stringWithFormat:@"0 Friend Found"];
        
        
    }
    else
    {
        
        for (NSDictionary *data in [json valueForKey:@"data"]) {
            
            [FriendArray addObject:data];
        }
        FriendTable.hidden = NO;
        NoofFriend.hidden = NO;
        NoofFriend.text = [NSString stringWithFormat:@"%lu Friends Found",(unsigned long)[FriendArray count]];
        
        [FriendTable reloadData];
        
    }
   
    
}



#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return FriendArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    FriendListCC *cell = (FriendListCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendListCC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [[FriendArray valueForKey:@"user_name"]objectAtIndex:indexPath.row];
    cell.location.text = [[FriendArray valueForKey:@"name"]objectAtIndex:indexPath.row];
    
    cell.profilepic.layer.cornerRadius = cell.profilepic.frame.size.width/2;
    cell.profilepic.layer.masksToBounds = YES;
    
    
    //NSLog(@"%@",[FriendArray valueForKey:@"prof_image"]);
    
    [cell.profilepic setImageWithURL:[[FriendArray valueForKey:@"prof_image"]objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    /*********************------First Backend then Implement ---------********************/
    
        cell.status.hidden = YES;
        cell.status.layer.cornerRadius = cell.status.frame.size.width/2;
        cell.status.layer.masksToBounds = YES;
        [cell.status.layer setBorderWidth:2.0f];
        [cell.status.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    
    /****************************------------End-----------**********************************/
    
    
    cell.SendRequest.layer.cornerRadius = 4.0f;
    cell.SendRequest.layer.masksToBounds = YES;
    
    
    
    if ([self.from isEqual:@"Request"]) {
        
        NSLog(@"%@",[[FriendArray valueForKey:@"isfriend"]objectAtIndex:indexPath.row ]);
        
        if ([[[FriendArray valueForKey:@"isfriend"]objectAtIndex:indexPath.row ] isEqual:@"Yes"]) {
            
            cell.SendRequest.hidden = NO;
            [ cell.SendRequest addTarget:self
                                          action:@selector(SendRequestTap:)
                        forControlEvents:UIControlEventTouchUpInside];
            
            cell.SendRequest.tag = indexPath.row;
            
        }
        else
        {
            cell.SendRequest.hidden = YES;
        }
       
    }
    else
    {
        cell.SendRequest.hidden = YES;
    }
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.from isEqual:@"Request"]) {
    }
    else
    {
        
        NSLog(@"%@",FriendArray);
        [FriendTable deselectRowAtIndexPath:indexPath animated:YES];
        [FriendTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        MyProfileVC *MyProfileVC_ = [[MyProfileVC alloc]init];
        MyProfileVC_.from = @"FriendProfile";
        MyProfileVC_.title = [[FriendArray valueForKey:@"user_name"]objectAtIndex:indexPath.row];
        
        MyProfileVC_.FriendID = [[FriendArray valueForKey:@"id"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:MyProfileVC_ animated:YES];
    }
    
    
    
    
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

    
    if (result1.length >0) {
        
        
        
        imageurl1=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
        
        
        
        
       // NSString *aValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_details"];
        
        
        //NSLog(@"Value from standardUserDefaults: %@", aValue);
        
        
        NSString *tagtext = @"" ;
        
        for (int i=0; i<[[postDic valueForKey:@"tags"]count] ;i++) {
            
            NSString *list =[NSString stringWithFormat:@"%@,%@",[[postDic valueForKey:@"tags"] objectAtIndex:i],tagtext] ;
            
            tagtext =  list;
            
            NSLog(@"%@",tagtext);
        }
        if (tagtext.length>1) {
            tagtext = [tagtext substringToIndex:[tagtext length]-1];
        }
        
        
        
        NSString *value = [NSString stringWithFormat:@"user_id=%@&friend_id=%@&post_name=%@&post_desc=%@&post_tag=%@&image1=%@&video1=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],FriendID,[postDic valueForKey:@"postname"],[postDic valueForKey:@"postdescription"],tagtext,imageurl1,@""];
        
        NSLog(@"%@",value);
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_to_friend.php"]];
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
         self.view.userInteractionEnabled = YES;
        if ([[json valueForKey:@"msg"] isEqual:@"Done post added and request sent to friend."]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Sent to Your Friend." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
           
            
        }
        
    }

     else
     {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Failed! Try After Sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
     }
  
}


-(void)UploadVideoRequest :( NSData *)mediaData
{
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        
        NSData *videoData = mediaData;
        long videoSize = [videoData length]/1024/1024;
        NSLog(@"%ld",videoSize);
        
        
        
        if(videoSize < 20) // check size of video
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
            
            
            if (result1.length >0) {
                
                
                
                    videourl1=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
               
                
                
                
                    //NSString *aValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_details"];
                    
                    
                    //NSLog(@"Value from standardUserDefaults: %@", aValue);
                    
                    
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
                    
                    
                    
                    NSString *value = [NSString stringWithFormat:@"user_id=%@&friend_id=%@&post_name=%@&post_desc=%@&post_tag=%@&image1=%@&video1=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],FriendID,[postDic valueForKey:@"postname"],[postDic valueForKey:@"postdescription"],tagtext,@"",videourl1];
                    
                    NSLog(@"%@",value);
                    
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/post_submit_to_friend.php"]];
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
                    
                    if ([[json valueForKey:@"msg"] isEqual:@"Done post added and request sent to friend."]) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Your Post Successfully Sent to Your Friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        else
        {
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Video must be less than 20 MB" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [al show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
        });
    });
    
    
    
}


#pragma mark  -
#pragma mark  - Actions

-(IBAction)SendRequestTap:(id)sender
{
    
    NSLog(@"%ld",(long)[sender tag]);
    NSLog(@"%@",FriendArray);
    
    FriendID = [[FriendArray valueForKey:@"id"]objectAtIndex:[sender tag] ];
    NSLog(@"%@",FriendID);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
    
   // NSLog(@"%@",postDic);
    UIImage *image = [postDic valueForKey:@"PostImage"];
    CGSize imagesize = CGSizeMake(image.size.height, image.size.width);
    
    NSString *demo = [NSString stringWithFormat:@"%@",[postDic valueForKey:@"VideoURL"]];
    NSLog(@"%lu",(unsigned long)demo.length);
    
    if ([self.Type isEqual:@"Video"]) {
        
        self.view.userInteractionEnabled = NO;
        [self UploadVideoRequest:[postDic valueForKey:@"Videodata"]];
        
    }
    else
    {
        NSLog(@"abc");
        [self uploadimage:[postDic valueForKey:@"PostImage"]:imagesize];
    }

}


#pragma mark - Fetch FB Friends
/*
- (void)getFriendsdetails {
    
    [HUD showUIBlockingIndicatorWithText:@"Loading.."];
    
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:[ NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name",@"fields",nil]
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
 
                              
                              NSLog(@"%@",result);
                              for (NSDictionary *data in [[result objectForKey:@"data"] valueForKey:@"picture"]) {
                                  
                                  
                                  [friendspic addObject: [[data valueForKey:@"data" ]valueForKey:@"url"]];
                                  NSLog(@"%@",friendspic );
                              }
                              
                              for (int i =0; i<friendspic.count; i++) {
                                  // NSLog(@"%@",[resultData valueForKey:@"name"]);
                                  NSLog(@"%@",[friendspic objectAtIndex:i]);
                              }
                              
                              
                              for (NSDictionary *data in [result objectForKey:@"data"])
                              {
                                  NSLog(@"%@",data);
                                  [friendsname addObject: [data objectForKey:@"name" ]];
                                  [friendsid addObject: [data objectForKey:@"id" ]];
                                  NSLog(@"%@",friendsid);
                              }
                              [HUD hideUIBlockingIndicator];
                              [friendstable reloadData];
                          }];
    
    
}
*/








-(void)backTap
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
