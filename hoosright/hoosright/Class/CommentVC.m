//
//  CommentVC.m
//  hoosright
//
//  Created by rupam on 8/31/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "CommentVC.h"
#import "CommentCC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CommentVC ()<UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *CommentContainerView;
   
    IBOutlet UITextView *CommentTextfield;
    IBOutlet UIButton *Send;
    IBOutlet UITableView *CommentTable;
    
    NSMutableArray *CommentDetail;
    NSString *commenttext;
    float KeyboardHeight;
    
    float height;
    
}

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommentDetail = [[NSMutableArray alloc]init];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    Send.layer.cornerRadius = 4.0f;
    Send.layer.masksToBounds = YES;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    
    CommentTextfield.delegate = self;
    CommentTextfield.layer.cornerRadius = 2.0f;
    CommentTextfield.layer.masksToBounds = YES;
    
    CommentTextfield.layer.borderColor = (__bridge CGColorRef)([UIColor lightGrayColor]);
    CommentTextfield.layer.borderWidth = 1.0f;
    
    
    [self GetComments];
    
    
    CommentTextfield.text = @"Type your comment..";
    CommentTextfield.textColor = [UIColor lightGrayColor];
    
    Send.enabled = NO;
    Send.alpha = 0.5;
    
    
}


-(void)GetComments
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/get_comment.php"]];
    
    NSString *value = [NSString stringWithFormat:@"post_id=%@",_PostID];
    
    NSLog(@"%@",value);
    
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
    CommentDetail = [NSJSONSerialization
                   JSONObjectWithData:urlData //1
                   
                   options:kNilOptions
                   error:&error];
    
    
    
    NSLog(@"%@",CommentDetail);
    
    if ([[CommentDetail valueForKey:@"total_comment"]integerValue] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"No comment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        CommentTable.hidden = YES ;
        
        
    }
    
    else
    {
        CommentTable.hidden = NO ;
        [CommentTable reloadData];
       // [CommentTextfield becomeFirstResponder];
    }
    

    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        NSLog(@"OK");
        //[CommentTextfield becomeFirstResponder];
    }
    
    
}

-(void)PostComments
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://doitte.com/hoosright/post_comment.php"]];
    
    NSString *value = [NSString stringWithFormat:@"post_id=%@&user_id=%@&comment=%@&user_id1=%@&user_id2=%@",_PostID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],commenttext,_user_id1,_user_id2];
    
    NSLog(@"%@",value);
    
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
    
    if ([[json valueForKey:@"msg"] isEqual:@"comment post successfully!"]) {
        
        
        [self GetComments];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Wrong. Try After Sometime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[CommentDetail valueForKey:@"total_comment"] integerValue];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGRect textRect = [[[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"comment"] boundingRectWithSize:CGSizeMake(266, 1000)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                  context:nil];

    CGSize size = textRect.size;
    float height1 = size.height +40.0;
    
    return height1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";

        CommentCC *cell = (CommentCC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
    
    //NSLog(@"%@",)
    
    [cell.ProfileImage setImageWithURL:[[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.size.width/2;
    cell.ProfileImage.layer.masksToBounds = YES;
    
    
    
    
    CGRect textRect = [[[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"comment"]boundingRectWithSize:CGSizeMake(266, 900)
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                       context:nil];
    
    CGSize size = textRect.size;
    float height1 = size.height;
    
    cell.Comment.frame = CGRectMake(46, 25+5, 266, height1);
    
    cell.Comment.text = [[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"comment"];
    
    cell.UserName.text = [[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"user_name"];
    cell.Time.text = [[[CommentDetail  valueForKey:@"post_comment"] objectAtIndex:indexPath.row ] valueForKey:@"added_comment"];
    
    
        
        return cell;
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    
    if ([textView.text isEqual:@"Type your comment.."]) {
        
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    if ([textView.text isEqual:@""]) {
        
        textView.text = @"Type your comment..";
        textView.textColor = [UIColor lightGrayColor];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    commenttext = CommentTextfield.text;
    
    
    if (CommentTextfield.text.length >0) {
        
      
        Send.enabled = YES;
        Send.alpha = 1.0;
    }
    else
    {
        Send.enabled = NO;
        Send.alpha = 0.5;
    }
    
    CGRect textRect = [commenttext boundingRectWithSize:CGSizeMake(250, 1000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                    context:nil];
    
    CGSize size = textRect.size;
    height = size.height;
    
   
    
    
    if (height < 19.0f) {
        
        
        
        CommentContainerView.frame = CGRectMake(0, (self.view.frame.size.height - KeyboardHeight)+27, CommentContainerView.frame.size.width, CommentContainerView.frame.size.height);
    
    }
    else
    {
       
        
//        if (8+height < 65) {
//            
//            CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, 70);
//            
//        }
//        else
//        {
            CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, height+5);
//        }
        
        
    }
    
    
    
}
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    
    KeyboardHeight = keyboardFrame.size.height;
    
    
    if (height < 19.0f) {
        
        
        
        CommentContainerView.frame = CGRectMake(0, (self.view.frame.size.height - KeyboardHeight)+27, CommentContainerView.frame.size.width, CommentContainerView.frame.size.height);
        
    }
    else
    {
        
        
        //        if (8+height < 65) {
        //
        //            CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, 70);
        //
        //        }
        //        else
        //        {
        CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, height+5);
        //        }
        
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if([text isEqualToString:@"\n"]) {
        
        KeyboardHeight =64;
        if (height < 19.0f) {
            
            
            CommentContainerView.frame = CGRectMake(0, self.view.frame.size.height - KeyboardHeight+27, CommentContainerView.frame.size.width, CommentContainerView.frame.size.height);
            
        }
        else
        {
           
            
            if (8+height < 48) {
                
                CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, 48);
                
            }
            else
            {
                CommentContainerView.frame = CGRectMake(0, ((self.view.frame.size.height - KeyboardHeight)-height)+60, CommentContainerView.frame.size.width, height+5);
            }
            
            
        }

        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)SendComment:(id)sender {
    
    CommentTextfield.text = nil;
    
    if ([CommentTextfield.text isEqual:@""]) {
        
        CommentTextfield.text = @"Type your comment..";
        CommentTextfield.textColor = [UIColor lightGrayColor];
    }

    CommentContainerView.frame = CGRectMake(0, self.view.frame.size.height-37, CommentContainerView.frame.size.width, CommentContainerView.frame.size.height);
    [CommentTextfield resignFirstResponder];
    [self PostComments];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
