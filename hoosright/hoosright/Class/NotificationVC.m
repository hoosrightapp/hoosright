//
//  NotificationVC.m
//  hoosright
//
//  Created by rupam on 7/16/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "NotificationVC.h"
#import "NotificationCC.h"
#import "RequestConfirmVC.h"
#import "MyProfileVC.h"
#import "NewsFeedDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface NotificationVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NotificationCC *_NotificationCC;
    IBOutlet UITableView *NotificationTable;
    NSMutableArray *notificationArr;
    
    UIRefreshControl *refreshControl;
    
    
}

@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title =@"Notifications";
    
    
    
    
    //[self GetNotifications];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"abcd");
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(GetNotifications)
             forControlEvents:UIControlEventValueChanged];
    [NotificationTable addSubview:refreshControl];

    
    
    
    NotificationTable.hidden = YES;
    notificationArr = [[NSMutableArray alloc]init];
    [self GetNotifications];
    
}



-(void)GetNotifications
{
    NSString *value = [NSString stringWithFormat:@"user_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/get_notification.php"]];
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
    
   // NSLog(@"%@",json);
    
   // NSLog(@"%@",[json objectForKey:@"userNotifications"]);
    
    if ([[json objectForKey:@"userNotifications"] isEqual:@""]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"No Notification Yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        
        [notificationArr removeAllObjects];
        for (NSMutableArray *data in [json  objectForKey:@"userNotifications"]) {
            
            
            NSLog(@"%@",data );
            [notificationArr addObject:data ];
            
        }
        
        NSLog(@"%@",[[notificationArr valueForKey:@"sender_name"]objectAtIndex:0]);
        NSLog(@"%lu",(unsigned long)notificationArr.count);
        
        
        NotificationTable.delegate = self;
        NotificationTable.dataSource = self;
        NotificationTable.hidden = NO;
        
        [NotificationTable reloadData];

    }
    
    [refreshControl endRefreshing];
    
}


#pragma mark - UITableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notificationArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    
        
        _NotificationCC = (NotificationCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (_NotificationCC == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCC" owner:self options:nil];
            _NotificationCC = [nib objectAtIndex:0];
        }
    
    NSLog(@"%@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"read_status"]);
    if ([[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"read_status"] isEqual:@"U"]) {
        
        _NotificationCC.backgroundColor = [UIColor whiteColor];
    }
    else
    {
         _NotificationCC.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0  blue:225.0/255.0  alpha:1];
    }
    UIColor *Color1 = [UIColor blueColor];
    UIColor *Color2 = [UIColor grayColor];
    
    NSString *Text1 = [NSString stringWithFormat:@"@%@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"sender_name"]];
    NSString *Text2 = [NSString stringWithFormat:@"%@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"action_type"]];
    
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ ",
                      Text1,
                      Text2];
    
    
    
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: _NotificationCC.UseActionLabel.textColor
                              };
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attribs];
    
    
    
    NSRange TextRange1 = [text rangeOfString:Text1];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:Color1}
                            range:TextRange1];
    
    
    NSRange TextRange2 = [text rangeOfString:Text2];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:Color2}
                            range:TextRange2];
    
    _NotificationCC.UseActionLabel.attributedText = attributedText;
    
    [_NotificationCC.UserImage setImageWithURL:[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    _NotificationCC.UserImage.layer.cornerRadius = _NotificationCC.UserImage.frame.size.width/2;
    _NotificationCC.UserImage.layer.masksToBounds = YES;
    
    
    if ([[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_title"]isEqual:@""]) {
        
        _NotificationCC.PostEventName.text = [NSString stringWithFormat:@"%@ %@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"sender_name"],[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"action_type"]];
    }
    else
    {
        _NotificationCC.PostEventName.text =[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_title"];
    }
    
    return _NotificationCC;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_type_is"]);
    
    if ([[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_type_is"] isEqual:@"post"]) {
        
        
        NSLog(@"%@",[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"read_status"]);
        if ([[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"read_status"] isEqual:@"U"]) {
            RequestConfirmVC *_RequestConfirmVC = [[RequestConfirmVC alloc]init];
            
            _RequestConfirmVC.PostId = [[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_id"];
            _RequestConfirmVC.NotificationMasterId = [[notificationArr objectAtIndex:indexPath.row]valueForKey:@"id"];
            [self.navigationController pushViewController:_RequestConfirmVC animated:YES];
            //[self presentViewController:_RequestConfirmVC animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have already contributed to this post" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        
        
        
    }
    
    
    else if ([[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_type_is"] isEqual:@"comment"]||[[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_type_is"] isEqual:@"like"]){
        
        
        NSLog(@"%@",[notificationArr objectAtIndex:indexPath.row]);
        
        //post_id
        
        NewsFeedDetailVC *_NewsFeedDetailVC = [[NewsFeedDetailVC alloc]init];
        _NewsFeedDetailVC.PostID = [[notificationArr objectAtIndex:indexPath.row]valueForKey:@"post_id"];
        [self.navigationController pushViewController:_NewsFeedDetailVC animated:YES];
        
        
    }
    
    else
    {
        MyProfileVC *MyProfileVC_ = [[MyProfileVC alloc]init];
        MyProfileVC_.from = @"FriendProfile";
        MyProfileVC_.FriendID = [[notificationArr objectAtIndex:indexPath.row]valueForKey:@"poster_id"];
        [self.navigationController pushViewController:MyProfileVC_ animated:YES];
        
        [self notificationstatus:[[notificationArr objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
    }
}


-(void)notificationstatus :(NSString *)id_str
{
    
    NSString *value = [NSString stringWithFormat:@"notification_id=%@",id_str];
    
    //NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/notification_status.php"]];
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
     
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
