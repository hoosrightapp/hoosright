//
//  NewsFeedDetailVC.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/23/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "NewsFeedDetailVC.h"
#import "Section1CC.h"
#import "Section2CC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TWVideoPlayer.h"
#import "Capture.h"
#import "CommentVC.h"
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsFeedDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITableView *detailTable;
    UILabel *tagtext;
    NSMutableArray *DetailArray;
    UIImage *VThumImage1;
    UIImage *VThumImage2;
    
    TWVideoPlayer *videoPlayer;
    IBOutlet UIView *playerview;
    IBOutlet UIButton *playerviewcancel;
    Section1CC *cell;
    BOOL islike;

    
}

@end

@implementation NewsFeedDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"Detail";
    
    DetailArray = [[NSMutableArray alloc]init];
    detailTable.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
   // [self PostDetail];
    
   // playerviewcancel.layer.cornerRadius = playerviewcancel.frame.size.width/2;
    
    [self performSelector:@selector(PostDetail) withObject:nil afterDelay:0.1];
    
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self.tabBarController.tabBar setHidden:NO];
}
-(void)PostDetail
{
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_details_all.php"]];
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_PostID];
    
    NSLog(@"%@",value);
    
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
    DetailArray = [NSJSONSerialization
                            JSONObjectWithData:urlData //1
                            
                            options:kNilOptions
                            error:&error];
    
    
    
    NSLog(@"%@",DetailArray);
    
    
    detailTable.delegate = self;
    detailTable.dataSource = self;
    
    
    if ([[DetailArray valueForKey:@"isLike"] isEqual:@"Yes"]) {
        islike = YES;
    }
    else
    {
        islike = NO;
    }
    
    
    
    if ([[[DetailArray valueForKey:@"post_details" ]valueForKey:@"file_type"] isEqual:@"V"]) {
        
        
        
        
        VThumImage1 = nil;
        
        NSError *err = NULL;
        CMTime time = CMTimeMake(0, 30);
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file1"]] options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
        VThumImage1 = [[UIImage alloc] initWithCGImage:imgRef] ;
        CGImageRelease(imgRef);
        NSLog(@"%@",VThumImage1);
        
        
        VThumImage2 = nil;
        
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file2"]] options:nil];
        AVAssetImageGenerator *generator1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generator.appliesPreferredTrackTransform = YES;
        CGImageRef imgRef1 = [generator1 copyCGImageAtTime:time actualTime:NULL error:&err];
        VThumImage2 = [[UIImage alloc] initWithCGImage:imgRef1] ;
        CGImageRelease(imgRef1);
        NSLog(@"%@",VThumImage2);
    }
    
    
    
    
    
    
    
    
    
    
    
    [detailTable reloadData];
    
    
}


#pragma mark - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
       return 1;
    }
    else if(section == 1)
    {
        
        if (![[DetailArray valueForKey:@"isVote"] isEqual:@"No"]) {
            
            return [[DetailArray valueForKey:@"total_comment"] integerValue];
        }
        else
        {
            return 0;
        }
        
    }
    else{
        return 0;
    }
        
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    if (section == 1) {
        sectionHeaderView = [[UIView alloc] initWithFrame:
                                     CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
       
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(15, 15, sectionHeaderView.frame.size.width, 25.0)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor lightGrayColor];
        [sectionHeaderView addSubview:headerLabel];
        headerLabel.text =[NSString stringWithFormat:@"%@ Comments",[DetailArray valueForKey:@"total_comment"]] ;
        
        return sectionHeaderView;

    }
    else
    {
     
        return sectionHeaderView;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"%ld",(long)section);
    
     if (section == 1)
    {
        return 50.0f;
    }
    
    else {
        
        return 0.01f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    if(indexPath.section == 0 )
    {
        cell = (Section1CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Section1CC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        
        //demo tag array
        NSArray *components = [[[DetailArray valueForKey:@"post_details" ]valueForKey:@"post_tags"]
                               componentsSeparatedByString:@","];

        
        
        
        
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
            tagtext.font = [UIFont fontWithName:@"GillSans-Italic" size:9.0f];
            tagtext.layer.cornerRadius = 10;
            tagtext.layer.masksToBounds = YES;
            [cell.contentView addSubview:tagtext];
        }
        
        
        cell.postname.text = [[DetailArray valueForKey:@"post_details" ]valueForKey:@"post_name"];
        
        /*
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
        
        NSDate *date1 = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
        
        NSDate *date2 = [dateFormatter dateFromString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"added_date"]];
        
        
        NSTimeInterval secondsBetween = [date1 timeIntervalSinceDate:date2];
        
        int numberOfDays = secondsBetween / 86400;
        
        NSLog(@"There are %d days in between the two dates.", numberOfDays);
         */
        
        
        cell.date.text = [NSString stringWithFormat:@"Started %@ by @%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"added_post"],[[DetailArray valueForKey:@"post_details" ]valueForKey:@"first_user"]];
        
        
        
        cell.VS.layer.cornerRadius = cell.VS.frame.size.width/2;
        cell.VS.layer.masksToBounds = YES;
        
        
        cell.user1watchvideo.layer.cornerRadius = 4;
        cell.user2watchvideo.layer.cornerRadius = 4;
        
        
        if ([[[DetailArray valueForKey:@"post_details" ]valueForKey:@"file_type"] isEqual:@"I"]) {
            
            
            
            //UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file1"]]];
            
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file1"]]]];
            
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
            
            
            [cell.video1 setImage:destImage];
            
            
            
            
            UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file2"]]]];
            
            
            
            float actualHeight1 = image1.size.height;
            float actualWidth1 = image1.size.width;
            float imgRatio1 = actualWidth1/actualHeight1;
            float maxRatio1 = 320.0/480.0;
            
            if(imgRatio1!=maxRatio1){
                if(imgRatio1 < maxRatio1){
                    imgRatio1 = 480.0 / actualHeight1;
                    actualWidth1 = imgRatio1 * actualWidth1;
                    actualHeight1 = 480.0;
                }
                else{
                    imgRatio1 = 320.0 / actualWidth1;
                    actualHeight1 = imgRatio1 * actualHeight1;
                    actualWidth1 = 320.0;
                }
            }
            CGRect rect1 = CGRectMake(0.0, 0.0, actualWidth1, actualHeight1);
            UIGraphicsBeginImageContext(rect1.size);
            
            [image1 drawInRect:rect1];
            UIImage *destImage1 = UIGraphicsGetImageFromCurrentImageContext();
            
            
            
            
            [cell.video2 setImage:destImage1];
            
            cell.user1watchvideo.hidden = YES;
            cell.user2watchvideo.hidden = YES;
        }
        else
        {
            
            
            UIImage *image = VThumImage1;
            
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
            [cell.video1 setImage:destImage];
            
            
            
            UIImage *image1 = VThumImage2;
            
            float actualHeight1 = image1.size.height;
            float actualWidth1 = image1.size.width;
            float imgRatio1 = actualWidth1/actualHeight1;
            float maxRatio1 = 320.0/480.0;
            
            if(imgRatio1!=maxRatio1){
                if(imgRatio1 < maxRatio1){
                    imgRatio1 = 480.0 / actualHeight1;
                    actualWidth1 = imgRatio1 * actualWidth1;
                    actualHeight1 = 480.0;
                }
                else{
                    imgRatio1 = 320.0 / actualWidth1;
                    actualHeight1 = imgRatio1 * actualHeight1;
                    actualWidth1 = 320.0;
                }
            }
            CGRect rect1 = CGRectMake(0.0, 0.0, actualWidth1, actualHeight1);
            UIGraphicsBeginImageContext(rect1.size);
            
            [image1 drawInRect:rect1];
            UIImage *destImage1 = UIGraphicsGetImageFromCurrentImageContext();
            [cell.video2 setImage:destImage1];
            
            cell.user1watchvideo.hidden = NO;
            cell.user2watchvideo.hidden = NO;
        }
        
        
        
        
        cell.user1.layer.cornerRadius = cell.user1.frame.size.width/2;
        cell.user1.layer.masksToBounds = YES;
        cell.user2.layer.cornerRadius = cell.user2.frame.size.width/2;
        cell.user2.layer.masksToBounds = YES;
        
        
        [cell.user1 setImageWithURL:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"first_user_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
        [cell.user2 setImageWithURL:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
        
        
        
        
        cell.user1name.text = [NSString stringWithFormat:@"@%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"first_user"]];
        cell.user2name.text = [NSString stringWithFormat:@"@%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user"]];
        cell.VoteUser1.layer.cornerRadius = 8;
        cell.VoteUser2.layer.cornerRadius = 8;
        

        [cell.VoteUser1 addTarget:self
                           action:@selector(VoteUser1Tap:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [cell.VoteUser2 addTarget:self
                           action:@selector(VoteUser2Tap:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [cell.user1watchvideo addTarget:self
                           action:@selector(user1watchvideoTap:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [cell.user2watchvideo addTarget:self
                                 action:@selector(user2watchvideoTap:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.like addTarget:self
                           action:@selector(LikeTap:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [cell.moreBtn addTarget:self
                      action:@selector(moreBtnTap:)
            forControlEvents:UIControlEventTouchUpInside];
        
        
        if (islike == NO) {
            
            [cell.like setImage:[UIImage imageNamed:@"star-N"] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
           [cell.like setImage:[UIImage imageNamed:@"star-Y"] forState:UIControlStateNormal]; 
            
            
        }
        
        [cell.comment addTarget:self
                      action:@selector(CommentTap:)
            forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        //description1 font and text
        
        cell.descriptiontext.text = [[DetailArray valueForKey:@"post_details" ]valueForKey:@"description"];
        cell.descriptiontext.font = [UIFont fontWithName:@"GillSans-Light" size:12.0f];
        
        //description2 font and text
        
        cell.descriptionText1.text = [[DetailArray valueForKey:@"post_details" ]valueForKey:@"description2"];
        cell.descriptionText1.font = [UIFont fontWithName:@"GillSans-Light" size:12.0f];
        
        
        //Description
        cell.DescriptionLeb1.text = [NSString stringWithFormat:@"SIDE A - @%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"first_user"]];
        cell.DescriptionLeb2.text = [NSString stringWithFormat:@"SIDE B - @%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user"]];
        
        
        
        
        
        
        
        
        [cell.VoteUser1 setTitle:[NSString stringWithFormat:@"@%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"first_user"]] forState:UIControlStateNormal];
        
        [cell.VoteUser2 setTitle:[NSString stringWithFormat:@"@%@",[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user"]] forState:UIControlStateNormal];
        
        if (![[DetailArray valueForKey:@"isVote"] isEqual:@"No"]) {
            
            cell.user1persent.text = [NSString stringWithFormat:@"%@%@",[[DetailArray valueForKey:@"vote" ]valueForKey:@"first_user_vote"],@"%"];
            cell.user2persent.text = [NSString stringWithFormat:@"%@%@",[[DetailArray valueForKey:@"vote" ]valueForKey:@"second_user_vote"],@"%"];
        }
        
        
        
        
        
        cell.user1vote.hidden = YES;
        cell.user2vote.hidden = YES;
        
        /*
        
            
        cell.user1vote.text = [NSString stringWithFormat:@"+%@Vote",[[DetailArray valueForKey:@"vote" ]valueForKey:@"first_user_vote_count"]];
        cell.user2vote.text = [NSString stringWithFormat:@"+%@Vote",[[DetailArray valueForKey:@"vote" ]valueForKey:@"second_user_vote_count"]];
        
        */
        
        
        
        
        
        
        return cell;
    }
    
    
    else
    {
        
        
        Section2CC *cell1 = (Section2CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Section2CC" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@ says:",[[[DetailArray valueForKey:@"post_comment" ] objectAtIndex:indexPath.row]valueForKey:@"user_name"]]);
        
        cell1.ProfilePic.layer.cornerRadius = cell1.ProfilePic.frame.size.width/2;
        cell1.ProfilePic.layer.masksToBounds = YES;
        [cell1.ProfilePic setImageWithURL:[[[DetailArray valueForKey:@"post_comment" ] objectAtIndex:indexPath.row]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
        
        cell1.Name.text = [NSString stringWithFormat:@"%@ says:",[[[DetailArray valueForKey:@"post_comment" ] objectAtIndex:indexPath.row]valueForKey:@"user_name"]];
        
        cell1.Description.text = [[[DetailArray valueForKey:@"post_comment" ] objectAtIndex:indexPath.row]valueForKey:@"comment"];
        
        
        return cell1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 913;
    }
    else
    {
        CGRect textRect = [[[[DetailArray valueForKey:@"post_comment" ] objectAtIndex:indexPath.row]valueForKey:@"comment"] boundingRectWithSize:CGSizeMake(284, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}
                                                        context:nil];
        
        CGSize size = textRect.size;
        float height1 = size.height +68.0;
        
        
        return height1;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [detailTable deselectRowAtIndexPath:indexPath animated:YES];
    [detailTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(IBAction)VoteUser1Tap:(id)sender{
    
    
    NSLog(@"%@",[DetailArray valueForKey:@"isVote"]);
    
    
    if ([[DetailArray valueForKey:@"isVote"] isEqual:@"No"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/user_vote.php"]];
        
        NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&voting_user_id=%@&post_mat=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_PostID,[[DetailArray valueForKey:@"vote" ]valueForKey:@"first_user_id"],[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file1"]];
        
        NSLog(@"%@",value);
        
        
        NSLog(@"my--%@",url);
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        
        [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        
        
        
        DetailArray = [[NSMutableArray alloc]init];
        
        DetailArray = [NSJSONSerialization
                       JSONObjectWithData:urlData //1
                       
                       options:kNilOptions
                       error:&error];
        
        
         NSLog(@"%@",DetailArray);
        [detailTable reloadData];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have already submitted your vote for this post.  Feel free to comment below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    
}
-(IBAction)VoteUser2Tap:(id)sender{
    
    //isVote
    
    NSLog(@"%@",[DetailArray valueForKey:@"isVote"]);
    
    if ([[DetailArray valueForKey:@"isVote"] isEqual:@"No"]) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/user_vote.php"]];
        
        NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@&voting_user_id=%@&post_mat=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],_PostID,[[DetailArray valueForKey:@"vote" ]valueForKey:@"second_user_id"],[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file2"]];
        
        NSLog(@"%@",value);
        
        
        NSLog(@"my--%@",url);
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        
        [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        
        DetailArray = [[NSMutableArray alloc]init];
        
        DetailArray = [NSJSONSerialization
                       JSONObjectWithData:urlData //1
                       
                       options:kNilOptions
                       error:&error];
        
        
        NSLog(@"%@",DetailArray);
        [detailTable reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have already submitted your vote for this post.  Feel free to comment below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    

    
}
-(IBAction)user1watchvideoTap:(id)sender{
    

    
    
    NSURL *url = [NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file1"]];
    NSLog(@"%@",url);

    
    Capture *_Capture = [[Capture alloc]init];
    _Capture.url = url;
    _Capture.image=[UIImage imageNamed:@"Noimage"];
    _Capture.type = @"Video";
    _Capture.from = @"NewsFeed";
    [self presentViewController:_Capture animated:YES completion:nil];
    
    
    
    
}
-(IBAction)user2watchvideoTap:(id)sender{
    
    NSURL *url = [NSURL URLWithString:[[DetailArray valueForKey:@"post_details" ]valueForKey:@"upload_file2"]];
    NSLog(@"%@",url);
    
    
    Capture *_Capture = [[Capture alloc]init];
    _Capture.url = url;
    _Capture.image=[UIImage imageNamed:@"Noimage"];
    _Capture.type = @"Video";
    _Capture.from = @"NewsFeed";
    [self presentViewController:_Capture animated:YES completion:nil];

    
}



- (IBAction)LikeTap:(id)sender {
    
    NSURL *url;
    if (islike == NO) {
        
        islike = YES;
        
        [cell.like setImage:[UIImage imageNamed:@"star-Y"] forState:UIControlStateNormal];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_like.php"]];
    }
    else
    {
        islike = NO;
        [cell.like setImage:[UIImage imageNamed:@"star-N"] forState:UIControlStateNormal];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_unlike.php"]];
        
    }
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&post_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],[[DetailArray valueForKey:@"post_details"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
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

    
    
    
}

#pragma mark - 
#pragma mark - Actions

#pragma mark - More Button Action

- (IBAction)moreBtnTap:(id)sender {
    
    
    UIActionSheet *actionsheet;
    if ([[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]
        ||[[[DetailArray valueForKey:@"user_id" ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]) {
        
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

- (IBAction)CommentTap:(id)sender {
    
    
    CommentVC *CommentVC_ = [[CommentVC alloc]init];
    CommentVC_.PostID = [[DetailArray valueForKey:@"post_details" ]valueForKey:@"id"];
    [self.navigationController pushViewController:CommentVC_ animated:YES];
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
//    NSLog(@"%@",[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"second_user_id"]);
//    NSLog(@"%@",[[FeedArray objectAtIndex:postIndexPath ]valueForKey:@"user_id"]);
    
    
    if ([[[DetailArray valueForKey:@"post_details" ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]
        ||[[[DetailArray valueForKey:@"user_id" ]valueForKey:@"second_user_id"] isEqual:[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]]) {
        
        
        
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
    
    NSString *temp = [NSString stringWithFormat:@"\n\n\n\n\n==== Please Do Not Delete====== \n Post Name: %@\n Post Description: %@\n==========================",[[DetailArray valueForKey:@"post_details" ] valueForKey:@"post_name"],[[DetailArray valueForKey:@"post_details" ] valueForKey:@"description"]];
    
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



#pragma mark - Delete Post
-(void)DeletePost
{
    
    
    
    NSString *value = [NSString stringWithFormat:@"post_id=%@",[[DetailArray valueForKey:@"post_details" ] valueForKey:@"id"]];
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"You have sucessfully copied the link." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //    [alert show];
    
    
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
