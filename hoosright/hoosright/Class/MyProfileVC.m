//
//  MyProfileVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/23/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "MyProfileVC.h"
#import "SWRevealViewController.h"
#import "DescriptionCC.h"
#import "MyVideoCC.h"
#import "FriendListVC.h"
#import "EditProfileVC.h"
#import "NewsFeedVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyProfileVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    
    IBOutlet UITableView *MyProfileTable;
    DescriptionCC *DescriptionCC_;
    UILabel * seeall;
    BOOL iscreateindex2;
    BOOL iscreateindex3;
    
    NSMutableArray *ProfileDetailArr;
    
}

@end 

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ProfileDetailArr = [[NSMutableArray alloc]init];
   
    
    
    
    if ([self.from isEqual:@"FriendProfile"]) {
       
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                             style:UIBarButtonItemStylePlain target:self action:@selector(backTap)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
    }
    
    
       MyProfileTable.hidden = YES;
   
    /*
     
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
     */
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    //[self.view setNeedsDisplay];
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self.view setNeedsDisplay];
   // [MyProfileTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    
    if ([self.from isEqual:@"FriendProfile"]) {
        
        MyProfileTable.hidden = YES;
        
        [self ProfileDetail];
        
    }
    else
    {
        self.title = @"My Profile";
       
        [self MyProfile];
        
        /*
         
        SWRevealViewController *revealController = [self revealViewController];
        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        
        
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                             style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
         
         */
        
        
    }
    
    
    // Set my Tableview delegate and datasourse
    
    seeall = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-110, 20, 70, 20)];
    
    iscreateindex2 = NO;
    iscreateindex3 = NO;
}

-(void)MyProfile
{
    
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/user_profile.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
    ProfileDetailArr = [NSJSONSerialization
                        JSONObjectWithData:urlData //1
                        
                        options:kNilOptions
                        error:&error];
    
     NSLog(@"%@",ProfileDetailArr);
   
    
   
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_info"]objectAtIndex:0] forKey:@"Userdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    
    
    MyProfileTable.delegate = self;
    MyProfileTable.dataSource = self;
    MyProfileTable.hidden = NO;
    
    [MyProfileTable reloadData];

}


-(void)ProfileDetail
{
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&friend_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_FriendID];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/friend_details.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
    ProfileDetailArr = [NSJSONSerialization
                            JSONObjectWithData:urlData //1
                            
                            options:kNilOptions
                            error:&error];
    
    NSLog(@"%@",ProfileDetailArr);
    MyProfileTable.delegate = self;
    MyProfileTable.dataSource = self;
    MyProfileTable.hidden = NO;
    
    [MyProfileTable reloadData];
    
    
}

-(void)FollowFriend
{
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&friend_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_FriendID];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/follow_friend.php"]];
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
    
    if ([[json valueForKey:@"msg"] isEqual:@"Friend added successfully!"]) {
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Friend Added Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Going Wrong. Try After Sometime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}



#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.from isEqual:@"FriendProfile"]) {
        
        return 1;
    }
    else
    {
        return 4;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 339;
    }
    else if(indexPath.row == 1)
    {
        
        if ([[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"] isEqual:@""]) {
            
            return 80.0f;
        }
        else if ([[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"] count]<5)
        {
            return 120.0f;
        }
        else
        {
            return 200.0f;
        }
        
        
    }
    else if(indexPath.row == 2)
    {
        return 60;
    }
    else
    {
        if ([[[ProfileDetailArr valueForKey:@"userProfile" ] valueForKey:@"total_friend"] isEqual:@"0"]) {
            
             return 60;
        }
        else{
            
             return 195;
        }
        
        
       
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    if (indexPath.row == 0) {
      
        DescriptionCC_ = (DescriptionCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (DescriptionCC_ == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionCC" owner:self options:nil];
            DescriptionCC_ = [nib objectAtIndex:0];
        }
        
        
        // Profile Pic setup
        
        DescriptionCC_.ProfilePic.layer.cornerRadius = DescriptionCC_.ProfilePic.frame.size.width/2;
        DescriptionCC_.ProfilePic.layer.masksToBounds = YES;
        
        
        
        
        
        if ([self.from isEqual:@"FriendProfile"]) {
            
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"prof_image"]]]];
            
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
            DescriptionCC_.ProfilePic.image = destImage;

            
            //[DescriptionCC_.ProfilePic setImageWithURL:[[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage" ]];
            
            
            // Follow button setup
            
            if ([[ProfileDetailArr valueForKey:@"isfriend"] isEqual:@"Yes"]) {
                
                
                
                //DescriptionCC_.AddFriend.hidden = YES;
                [DescriptionCC_.AddFriend setTitle:@"-" forState:UIControlStateNormal];
                DescriptionCC_.AddFriend.titleLabel.font = [UIFont systemFontOfSize:30.0f];
                
                [ DescriptionCC_.AddFriend addTarget:self
                                              action:@selector(UnFriendTap:)
                                    forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                
                [ DescriptionCC_.AddFriend addTarget:self
                                              action:@selector(AddFriendTap:)
                                    forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            
          
            
            
         //   NSLog(@"%@",[[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"bio"]);
            
            
            if ([[[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"bio"]  isEqual:@""]) {
                
                DescriptionCC_.DescriptionLeb.text = @"No Description/Bio Available";
                DescriptionCC_.DescriptionLeb.textAlignment = NSTextAlignmentCenter;
            }
            else
            {
                DescriptionCC_.DescriptionLeb.text = [[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"bio"];
                
                DescriptionCC_.DescriptionLeb.textAlignment = NSTextAlignmentCenter;
            }
            
            
            // User Address
            
            if ([[[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"address"] isEqual:@""]) {
                
                DescriptionCC_.Address.text = @"No Address Available";
            }
            else
            {
                DescriptionCC_.Address.text = [[ProfileDetailArr valueForKey:@"friend_details"]valueForKey:@"address"];
            }
            
            
            
            DescriptionCC_.accessoryType = UITableViewCellAccessoryNone;
            
            return DescriptionCC_;
            
        }
        else
        {
           
            
            
            // Profile Pic setup
            
            NSLog(@"%@",[[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0]valueForKey:@"prof_image"] );
            
            [DescriptionCC_.ProfilePic setImageWithURL:[[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage" ]];
            
            
            
            
            // Follow button setup
            
            [DescriptionCC_.AddFriend setTitle:@"Edit" forState:UIControlStateNormal];
            DescriptionCC_.AddFriend.titleLabel.font = [UIFont systemFontOfSize:17.0f];
            [ DescriptionCC_.AddFriend addTarget:self
                                          action:@selector(EditProfileTap:)
                                forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        // Description/Bio setup
        
        if ([[[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0] valueForKey:@"bio"] isEqual:@""]) {
            
            DescriptionCC_.DescriptionLeb.text = @"No Description/Bio Available";
            DescriptionCC_.DescriptionLeb.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            DescriptionCC_.DescriptionLeb.text = [[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0] valueForKey:@"bio"];
            
            DescriptionCC_.DescriptionLeb.textAlignment = NSTextAlignmentCenter;
        }
        
        
        // User Address
        
        if ([[[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0] valueForKey:@"address"] isEqual:@""]) {
            
             DescriptionCC_.Address.text = @"No Address Available";
        }
        else
        {
            DescriptionCC_.Address.text = [[[[ProfileDetailArr valueForKey:@"userProfile"] valueForKey:@"user_info" ]objectAtIndex:0] valueForKey:@"address"];
        }
        
        
        
        DescriptionCC_.accessoryType = UITableViewCellAccessoryNone;
        
        
        return DescriptionCC_;
        
        
        
        
    }
    
    else if (indexPath.row == 1){
        
        MyVideoCC *MyVideoCC_ = (MyVideoCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (MyVideoCC_ == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyVideoCC" owner:self options:nil];
            MyVideoCC_ = [nib objectAtIndex:0];
        }
        
        
        
        //NSLog(@"%lu",(unsigned long)[[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"] count]);
        
        if ([[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"] isEqual:@""]) {
            
            
            
            UILabel *novideo = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
            
            novideo.text = @"No Post Available";
            novideo.textColor = [UIColor lightGrayColor];
            novideo.font = [UIFont systemFontOfSize:13.0f];
            novideo.textAlignment = NSTextAlignmentCenter;
            [MyVideoCC_ addSubview:novideo];
            
        }
        else
        {
            
            UIImageView *tImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            tImage.image =[UIImage imageNamed:@"myposts"];
            [MyVideoCC_.contentView addSubview:tImage];
            
            
            UITapGestureRecognizer *tImageAction=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tImageTap:)];
            
            tImageAction.delegate = self;
            [tImage addGestureRecognizer:tImageAction];
            //Enable the image to be clicked
            tImage.userInteractionEnabled = YES;

            
            
            
            
            float h = 0.0;
            float w = 0.0;
            float dx = 0.0;
            
            NSLog(@"%f",self.view.frame.size.width);
            
            if ([[UIScreen mainScreen] bounds].size.width == 320 )
            {
                h = 70;
                w = 70;
                dx = 12.0;
                
            }
            else if ([[UIScreen mainScreen] bounds].size.width == 375 )
            {
                
                w = 110;
                h = 105;
                dx = 118;
                
            }
            else if ([[UIScreen mainScreen] bounds].size.width ==  414 )
            {
                
                w = 110;
                h = 105;
                dx = 118;
                
            }
            
            
            
            NSInteger Loop;
            
            if ([[ProfileDetailArr valueForKey:@"user_video"] count] <9) {
                
                Loop = [[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"] count];
            }
            else
            {
                Loop = 8;
            }
            
            
            int x= 5;
            int y = 0;
            int c = 0;
            
            for (int i=0;i < Loop;i++){
                
                
                
                UIImageView *ImgVW = [[UIImageView alloc] init];
                
                //ImgVW.frame =CGRectMake(df+(i%3*dx)+5, b*dy+45, w, h);
                
                
                
                
                if (i%4 == 0 && i/4 != 0 ) {
                    
                    x = 0;
                    y = h+10;
                    c=0;
                }
                else
                {
                    
                    if (i == 0) {
                        x = 0;
                    }
                    else
                    {
                        x = w*c+5*c;
                    }
                    
                    c=c+1;
                }
                
                ImgVW.frame = CGRectMake(x+dx,y+40, w, h);
                [ImgVW setBackgroundColor:[UIColor lightGrayColor]];
                [ImgVW setImageWithURL:[[[[ProfileDetailArr valueForKey:@"userProfile"]valueForKey:@"user_post"]objectAtIndex:i]valueForKey:@"user_file"] placeholderImage:nil];
                
                
                [MyVideoCC_.contentView addSubview:ImgVW];
                ImgVW.tag =i;
                
                
                
                /*
                 
                 
                 UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                 
                 tap.delegate = self;
                 [ImgVW addGestureRecognizer:tap];
                 //Enable the image to be clicked
                 ImgVW.userInteractionEnabled = YES;
                 
                 */
                
            }

            
        }
        
        
        MyVideoCC_.accessoryType = UITableViewCellAccessoryNone;
        
        return MyVideoCC_;
    }
    
    else if (indexPath.row == 2)
    {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        if (iscreateindex2 == YES) {
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ FRIENDS",[[ProfileDetailArr valueForKey:@"userProfile" ] valueForKey:@"total_friend"]];
            
            seeall.text = @"SEE ALL";
            seeall.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:seeall];
            iscreateindex2 = YES;
            
        }
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        float h = 0.0;
        float w = 0.0;
        float dx = 0.0;
        float dy = 0.0;
        float df = 0.0;
        int Nc = 0;
        
        if ([[[ProfileDetailArr valueForKey:@"userProfile" ] valueForKey:@"total_friend"] isEqual:@"0"]) {
            
            
            UILabel *nofriend = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 50)];
            
            nofriend.text = @"No Friend Available";
            nofriend.textColor = [UIColor lightGrayColor];
            nofriend.font = [UIFont systemFontOfSize:13.0f];
            nofriend.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:nofriend];
            
        }
        else
        {
            NSInteger Loop = [[[ProfileDetailArr valueForKey:@"userProfile" ] valueForKey:@"total_friend"]integerValue ];
            
            
            if (Loop > 8) {
                
                Loop = 8;
            }
            
            
            
            if ([[UIScreen mainScreen] bounds].size.width == 320 )
            {
                h = 70;
                w = 70;
                dx = 75;
                dy = 75;
                df= 5;
                Nc = 4;
            }
            else if ([[UIScreen mainScreen] bounds].size.width == 375 )
            {
                
                w = 75;
                h = 75;
                dx = 80;
                dy = 80;
                df = 25;
                Nc = 4;
            }
            else if ([[UIScreen mainScreen] bounds].size.width ==  414 )
            {
                
                w = 70;
                h = 70;
                dx = 75;
                dy = 75;
                df = 15;
                Nc = 5;
            }
            
            float count=0;
            int a =0,b =0;
            if (iscreateindex3 == YES) {
                
                
            }
            else
            {
                for (int i=0;i<Loop;i++){
                    
                    UIImageView *ProImgVW = [[UIImageView alloc] init];
                    ProImgVW.frame =CGRectMake(df+(i%Nc*dx)+5, b*dy+25, w, h);
                    
                    a=a+1;
                    
                    if (a==Nc  )
                    {
                        b =b+1;
                        a=0;
                        
                    }
                    count=i/Nc+1;
                    
                   
                    //[ProImgVW setBackgroundColor:[UIColor redColor]];
                    [ProImgVW removeFromSuperview];
                    
                    
                    [ProImgVW setImageWithURL:[[[[ProfileDetailArr valueForKey:@"userProfile" ] valueForKey:@"user_friend"] objectAtIndex:i]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
                     ProImgVW.layer.cornerRadius = ProImgVW.frame.size.width/2;
                    ProImgVW.layer.masksToBounds = YES;
                    
                    [cell.contentView addSubview:ProImgVW];
                    ProImgVW.tag =i;
                    
                    iscreateindex3 = YES;
                }
                
            }

        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2)
    {
        
         if ([self.from isEqual:@"FriendProfile"]) {
             
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You Cannot Send Request any Friends of Friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             
         }
        else
        {
            FriendListVC *FriendListVC_ = [[FriendListVC alloc]init];
            FriendListVC_.from = @"Friend";
            [self.navigationController pushViewController:FriendListVC_ animated:YES];
            
        }
        
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - /* Actions */

-(IBAction)AddFriendTap:(id)sender{
    
    // DescriptionCC_.AddFriend.hidden = YES;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Your Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Start following",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
   
    
    
    
}

-(IBAction)UnFriendTap:(id)sender{
    
    // DescriptionCC_.AddFriend.hidden = YES;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Your Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Stop following",
                            nil];
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
    
}


-(IBAction)EditProfileTap:(id)sender{
    
    EditProfileVC *_EditProfileVC = [[EditProfileVC alloc]init];
    [self presentViewController:_EditProfileVC animated:YES completion:nil];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
    if (actionSheet.tag == 1) {
        
        switch (buttonIndex)
        {
            case 0:
            {
                NSLog(@"0");
                
                [self FollowFriend];
                DescriptionCC_.AddFriend.hidden = YES;
            }
                break;
            case 1:
            {
                NSLog(@"1");
                DescriptionCC_.AddFriend.hidden = NO;
            }
                break;
            default:
                break;
        }

    }
    else
    {
        switch (buttonIndex)
        {
            case 0:
            {
                NSLog(@"0");
                
                [self UnFollowFriend];
                DescriptionCC_.AddFriend.hidden = YES;
            }
                break;
            case 1:
            {
                NSLog(@"1");
                DescriptionCC_.AddFriend.hidden = NO;
            }
                break;
            default:
                break;
        }

    }
    
}

-(void)UnFollowFriend
{
    NSString *value = [NSString stringWithFormat:@"user_id=%@&friend_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_FriendID];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/unfollow_friend.php"]];
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
    
    if ([[json valueForKey:@"msg"] isEqual:@"Unfollowed successfully!"]) {
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Friend Deleted Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Going Wrong. Try After Sometime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}

-(void)backTap
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)tImageTap:(id)sender
{
    /*
    NewsFeedVC *NewsFeedVC_ = [[NewsFeedVC alloc]init];
    NewsFeedVC_.from = @"Timeline";
    [self.navigationController pushViewController:NewsFeedVC_ animated:YES];
     
     */
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
