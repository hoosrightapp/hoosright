//
//  CreatePostVC.m
//  hoosright
//
//  Created by rupam on 7/8/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "CreatePostVC.h"
#import "PostSection1CC.h"
#import "PostSection2CC.h"
#import "PostSection3CC.h"
#import "PostSection4CC.h"
#import "capture.h"
#import "ConfirmVC.h"
#import "AVCamViewController.h"
//#import "PostDataStorage.h"
#import "FriendListVC.h"
@interface CreatePostVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UITableView *CreatePostTable;
    
    PostSection1CC *cell1;
    PostSection2CC *cell2;
    PostSection3CC *cell3;
    PostSection4CC *cell4;
    UIButton *tagtext;
    NSMutableArray *tagtextArr;
    NSMutableArray *tagtextbtnArr;
    NSMutableArray *tagtextbtnstatusArr;
    IBOutlet UIButton *VideoDone;
   // PostDataStorage *PostDataStorage_;
    NSMutableArray *tagarr;
    
    NSString *temp_postname;
    NSString *temp_postdescription;
    
    
    
    NSMutableDictionary *postdata; //To store postdata
    
    
    
}

@end

@implementation CreatePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    CreatePostTable.delegate = self;
    CreatePostTable.dataSource = self;
    
     tagtextArr = [[NSMutableArray alloc ]initWithObjects:@"Life",@"Sports",@"City",@"Tech",@"Health",@"Entertainment",@"Politics",@"Relationship",@"News",@"Fashion",@"Food", nil];
     tagtextbtnArr =[[NSMutableArray alloc ]init];
     tagarr =[[NSMutableArray alloc ]init];
     postdata = [[NSMutableDictionary alloc]init];
    
    
    
    VideoDone.layer.cornerRadius = 4.0f;
    VideoDone.layer.masksToBounds = YES;
    [[VideoDone layer] setBorderWidth:1.0f];
    [[VideoDone layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    //PostDataStorage_ = [[PostDataStorage alloc]init];
    
    temp_postname = @"Title your Post Here";
    temp_postdescription = @"Give a Description";
    
    NSLog(@"%@",self.type);
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [CreatePostTable reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    
    if (section == 1 || section == 2) {
        
        UIView *sectionHeaderView;
        sectionHeaderView = [[UIView alloc] initWithFrame:
                             CGRectMake(0, 0, self.view.frame.size.width, 10.0)];
        
        return sectionHeaderView;
        
    }
    
    else
    {
        
        return sectionHeaderView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 1 || section == 2)
    {
        return 10.0f;
    }

    else{
        
        return 0.01f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126.0f;
    }
    else if (indexPath.section == 1)
    {
        
        return ((tagtextArr.count%3 + tagtextArr.count/3)*50)+30;
    }
    else if (indexPath.section == 2)
    {
        
        if ([ [ UIScreen mainScreen ] bounds ].size.height == 480) {
            return 200.0f;
        }
        else
        {
            return 250.0f;
        }
        
    }
    else
    {
        return 146.0f;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    if(indexPath.section == 0 )
    {
        cell1 = (PostSection1CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostSection1CC" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        
        cell1.Contestname.delegate = self;
        if ([self.type isEqual:@"Video"]) {
            
            cell1.play.hidden = NO;
        }
        else
        {
            cell1.play.hidden = YES;
        }
        
        cell1.ContestImage.image = self.PassPostImage;
        cell1.Contestname.text = temp_postname;
        
        long len = cell1.Contestname.text.length;
        cell1.RemainingCharacters.text =[NSString stringWithFormat:@"%li Characters Remaining",70-len];
        
        [cell1.play addTarget:self action:@selector(PlayVideoTap) forControlEvents:UIControlEventTouchUpInside];
        
        return cell1;
    }

    else if(indexPath.section == 1 )
    {
        cell2 = (PostSection2CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell2 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostSection2CC" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
           
            int j = 0;
            int count = 0;
            int y=80;
            int freespace = (self.view.frame.size.width - ((100*3)+(5*2)))/2;
            
            //tagtextbtnArr = [[NSMutableArray alloc]init];
            
            [tagtextbtnArr removeAllObjects];
            
            for(int i = 0; i < tagtextArr.count; i++)
            {
                
                
                if(count%3 == 0)
                {
                    tagtext = [[UIButton alloc]initWithFrame: CGRectMake(freespace, y , 100, 30)];
                }
                else
                {
                    
                    tagtext = [[UIButton alloc]initWithFrame: CGRectMake(((100 + freespace)*(i%3))+5, y, 100, 30)];
                }
                
                [tagtextbtnArr addObject:tagtext];
                
                
               /*
                NSString *status;
                if (tagtext.selected == YES) {
                    status =
                }
                [tagtextbtnstatusArr addObject:status];
                */
                
                
                [tagtext setTitle:[tagtextArr objectAtIndex:i] forState:UIControlStateNormal];
                [tagtext addTarget:self
                            action:@selector(tagtexttap:)
                           forControlEvents:UIControlEventTouchDown];
                
                tagtext.tag = i;
                
                /*
                
                if (tagtext.selected == YES) {
                    
                 
                    tagtext.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
                    [tagtext setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
                    
                 
                    
                    tagtext.backgroundColor =  [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
                    [tagtext setTitleColor :[UIColor whiteColor] forState:UIControlStateNormal];
                    
                }
                else
                {
                 
                     
                    tagtext.backgroundColor =  [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
                    [tagtext setTitleColor :[UIColor whiteColor] forState:UIControlStateNormal];
                     
                 
                    tagtext.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
                    [tagtext setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
                    
                }
            */
                
                tagtext.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
                [tagtext setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
                tagtext.titleLabel.font = [UIFont fontWithName:@"GillSans-Italic" size:13.0f];
                tagtext.layer.cornerRadius = 6;
                tagtext.layer.masksToBounds = YES;
                
                [cell2.contentView addSubview:tagtext];
                
                count = count+1;
                if (count % 3 == 0) {
                    j = j+1;
                    y = 80+(j*40);
                }
            }
        }
        
        return cell2;
    }
    else if(indexPath.section == 2 )
    {
        cell3 = (PostSection3CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell3 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostSection3CC" owner:self options:nil];
            cell3 = [nib objectAtIndex:0];
        }
        
        cell3.DescriptionText.delegate = self;
        cell3.DescriptionText.text = temp_postdescription;
        
        return cell3;
    }
    else
    {
        cell4 = (PostSection4CC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell4 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostSection4CC" owner:self options:nil];
            cell4 = [nib objectAtIndex:0];
        }
        
        [cell4.SubmitToBButtn addTarget:self action:@selector(SubmitToBButtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell4.SendToFriendButtn addTarget:self action:@selector(SubmitToFButtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIColor *Color1 = [UIColor grayColor];
        UIColor *Color2 = [UIColor blackColor];
        
        NSString *Text1 = @"by continuing you are indicating that you have read our";
        NSString *Text2 = @"Privacy Policy";
        NSString *Text3 = @"and agree to the";
        NSString *Text4 = @"Terms & Conditions.";
        
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                          Text1,
                          Text2,
                          Text3,
                          Text4];
        
        
        
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: cell4.GeneralText.textColor
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
        
        NSRange TextRange3 = [text rangeOfString:Text3];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color1}
                                range:TextRange3];
        
        
        NSRange TextRange4 = [text rangeOfString:Text4];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color2}
                                range:TextRange4];
        
        
        
        cell4.GeneralText.attributedText = attributedText;
        
        
        
        cell4.SendToFriendButtn.layer.cornerRadius = 6;
        cell4.SendToFriendButtn.layer.masksToBounds = YES;
        
        
        cell4.SubmitToBButtn.layer.cornerRadius = 6;
        cell4.SubmitToBButtn.layer.masksToBounds = YES;
        
        
        return cell4;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    if (textView == cell1.Contestname) {
        
        
        
        
        if ([cell1.Contestname.text isEqual:@"Title your Post Here"]) {
            cell1.Contestname.text = nil;
        }
        else
        {
            cell1.Contestname.text = temp_postname;
        }
        
        
        long len = textView.text.length;
        NSLog(@"%ld",len);
        
        cell1.RemainingCharacters.text =[NSString stringWithFormat:@"%li Characters Remaining",70-len];
        
        
    }
    
    
    else if (textView == cell3.DescriptionText) {
        
        
        if ([cell3.DescriptionText.text isEqual:@"Give a Description"]) {
            
             cell3.DescriptionText.text = nil;
            
        }
        else
        {
           cell3.DescriptionText.text = temp_postdescription;
        }
        
        
        
        
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView{
    
    
    if (textView == cell1.Contestname) {
        
        
        if ([cell1.Contestname.text isEqual:@""]) {
            
            cell1.Contestname.text = @"Title your Post Here";
        }
        else
        {
            temp_postname = cell1.Contestname.text;
        }
        
       //temp_postname =  cell1.Contestname.text ;
    }
    
    else if (textView == cell3.DescriptionText) {
        
        
        if ([cell3.DescriptionText.text isEqual:@""]) {
            
            cell3.DescriptionText.text = @"Give a Description";
        }
        else
        {
            temp_postdescription = cell3.DescriptionText.text;
        }
        
        
        
        
        
        //temp_postdescription = cell3.DescriptionText.text ;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView == cell3.DescriptionText) {
        
    }
    else
    {
        long len = textView.text.length;
        
        cell1.RemainingCharacters.text =[NSString stringWithFormat:@"%li Characters Remaining",70-len];
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == cell1.Contestname) {
        
        if([text length] == 0)
        {
            if([textView.text length] != 0)
            {
                return YES;
            }
        }
        else if([[textView text] length] > 69)
        {
            return NO;
        }
        
        else if([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            return NO;
        }
        return YES;
        
    }
    else
    {
        if([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            return NO;
        }
        return YES;
    }
    
    
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
   
    [theTextField resignFirstResponder];
    
    return YES;
}

-(IBAction)tagtexttap:(id)sender
{
    //NSLog(@"%ld",(long)[sender tag]);
    
        
    UIButton *btn = [tagtextbtnArr objectAtIndex:[sender tag]];
        if (btn.selected == YES) {
            
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
            [btn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
            
            
            // Remove Deselected tag..
            
            NSInteger anIndex=[tagarr indexOfObject:[tagtextArr objectAtIndex:[sender tag]]]; // Get possition
            [tagarr removeObjectAtIndex:anIndex]; //Remove the object from index
            
           
            
        }
        else
        {
            btn.selected = YES;
            btn.backgroundColor =  [UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0];
            [btn setTitleColor :[UIColor whiteColor] forState:UIControlStateNormal];
            
            // Add selected tag..
            
            [tagarr addObject:[tagtextArr objectAtIndex:[sender tag]]];
        }
   
    
    
}


-(void)PlayVideoTap
{
    
    Capture *Capture_ = [[Capture alloc]init];
    Capture_.from = @"createVC";
    [Capture_ display :self.PassPostVideoUrl :self.PassPostImage :self.type];
    [self.navigationController presentViewController:Capture_ animated:YES completion:nil];
    
}

-(IBAction)SubmitToBButtnTap:(id)sender{
    
    [postdata setValue:temp_postname forKey:@"postname"];
    [postdata setValue:temp_postdescription forKey:@"postdescription"];
    
    if ([self.type isEqual:@"Video"]) {
        
        [postdata setValue:self.PassPostVideoUrl forKey:@"VideoURL"];
        [postdata setValue:self.passvideodata forKey:@"Videodata"];
    }
    else
    {
        [postdata setValue:@"" forKey:@"VideoURL"];
    }
    
    [postdata setObject:self.PassPostImage forKey:@"PostImage"];
    [postdata setObject:tagarr forKey:@"tags"];
    
    
//    [postdata setObject:self.PassPostImage forKey:@"postdescription2"];
    
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:postdata] forKey:@"userpostdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"FromB" forKey:@"from"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    AVCamViewController *AVCamViewController_ = [[AVCamViewController alloc]init];
    [self.navigationController pushViewController:AVCamViewController_ animated:YES];
    
}
-(IBAction)SubmitToFButtnTap:(id)sender{
    
    
    [postdata setValue:temp_postname forKey:@"postname"];
    [postdata setValue:temp_postdescription forKey:@"postdescription"];
    
    if ([self.type isEqual:@"Video"]) {
        
        [postdata setValue:self.PassPostVideoUrl forKey:@"VideoURL"];
        [postdata setValue:self.passvideodata forKey:@"Videodata"];
    }
    else
    {
        [postdata setValue:@"" forKey:@"VideoURL"];
    }
    
    [postdata setObject:self.PassPostImage forKey:@"PostImage"];
    [postdata setObject:tagarr forKey:@"tags"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:postdata] forKey:@"userpostdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FromB" forKey:@"from"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    FriendListVC *_FriendListVC = [[FriendListVC alloc]init];
    _FriendListVC.from = @"Request";
    _FriendListVC.Type = self.type;
    [self.navigationController pushViewController:_FriendListVC animated:YES];
    
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
