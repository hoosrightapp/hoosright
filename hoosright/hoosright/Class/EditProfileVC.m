//
//  EditProfileVC.m
//  hoosright
//
//  Created by rupam on 8/20/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "EditProfileVC.h"
#import "EditProfile.h"
#import "EditProfile1.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditProfileVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *ProImage;
    EditProfile *_EditProfile;
    EditProfile1 *_EditProfile1;
    IBOutlet UITableView *edittable;
    float Height;
    NSInteger indexpath;
    NSDictionary *json;
    

    IBOutlet UIActivityIndicatorView *indicator;
    UIImagePickerController *imagePicker;
    NSString *imageurl;
    
    
    NSString *name;
    NSString *username;
    NSString *website;
    NSString *bio;
    NSString *address;
    NSString *email;
    
    NSMutableArray *icons;
    BOOL isEnter;
    
}

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    edittable.delegate = self;
    edittable.dataSource = self;
    icons = [[NSMutableArray alloc]initWithObjects:@"aaa_64x64.png",@"profile_64x64.png",@"web_64x64.png",@"info_64x64.png",@"mail_64x64.png",@"situation.png", nil];
    Height = 46.0f;
    indicator.hidden = YES;
    
    ProImage.layer.cornerRadius = ProImage.frame.size.width/2;
    ProImage.layer.masksToBounds = YES;
    [self GetUserData];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


- (void)viewDidDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
-(void)GetUserData
{
    NSString *value = [NSString stringWithFormat:@"user_id=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"]];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/user_edit.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    json = [[NSDictionary alloc]init];
    json = [NSJSONSerialization
                        JSONObjectWithData:urlData //1
                        
                        options:kNilOptions
                        error:&error];
    
    NSLog(@"%@",json);
    
    address = [[json valueForKey:@"userDetails"]valueForKey:@"address"];
    email = [[json valueForKey:@"userDetails"]valueForKey:@"email_id"];
    imageurl = [[json valueForKey:@"userDetails"]valueForKey:@"prof_image"];
    name =[[json valueForKey:@"userDetails"]valueForKey:@"name"];
    website =[[json valueForKey:@"userDetails"]valueForKey:@"website"];
    bio = [[json valueForKey:@"userDetails"]valueForKey:@"bio"];
    username = [[json valueForKey:@"userDetails"]valueForKey:@"user_name"];
    
    NSLog(@"%@",name);
    NSLog(@"%@",website);
    NSLog(@"%@",address);
    NSLog(@"%@",email);
    NSLog(@"%@",bio);
   
    
    CGRect textRect = [bio boundingRectWithSize:CGSizeMake(225, 900)
                                options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                context:nil];
    
    
    
    CGSize size = textRect.size;
    NSLog(@"%f",size.height);
    Height = size.height;
    
    [edittable reloadData];

}

#pragma mark - UITableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    
    
   
    
    if (indexPath.section == 3) {
    
        _EditProfile = (EditProfile *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (_EditProfile == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditProfile" owner:self options:nil];
            _EditProfile = [nib objectAtIndex:0];
        }
        
        [ProImage setImageWithURL:[[json valueForKey:@"userDetails"]valueForKey:@"prof_image"] placeholderImage:[UIImage imageNamed:@"Noimage"]];
    
    
    [_EditProfile.Editicon setImage:[UIImage imageNamed:[icons objectAtIndex:3] ]];
        NSLog(@"%@",[icons objectAtIndex:3]);
        if ([[[json valueForKey:@"userDetails"]valueForKey:@"bio"] isEqual:@""]) {
            
           
            
            _EditProfile.CharacterCount.hidden = YES;
            
            
            if ([bio isEqual: [NSNull null]] || [bio isKindOfClass:[NSNull class]]||[bio isEqual:@"(null)"] || bio.length == 0) {
                
                _EditProfile.EditText.delegate = self;
                _EditProfile.EditText.text = @"Bio";
                _EditProfile.EditText.textColor = [UIColor lightGrayColor];
            }
            else
            {
                _EditProfile1.EditText.text = bio;
            }
            
            
        }
        else
        {
            _EditProfile.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"bio"];
            _EditProfile.EditText.textColor = [UIColor blackColor];
        }
        
        
            _EditProfile.EditText.tag = indexPath.section;
            _EditProfile.EditText.delegate = self;
   
        
        
        return _EditProfile;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"SimpleTableCell1";
        _EditProfile1 = (EditProfile1 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (_EditProfile1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditProfile1" owner:self options:nil];
            _EditProfile1 = [nib objectAtIndex:0];
        }
        
        [_EditProfile1.Editicon setImage:[UIImage imageNamed:[icons objectAtIndex:indexPath.section] ]];
        if (indexPath.section == 0) {
            
            
            _EditProfile1.EditText.userInteractionEnabled = YES;
            _EditProfile1.EditText.delegate = self;
            
            
            if ([[[json valueForKey:@"userDetails"]valueForKey:@"name"] isEqual:@""]) {
                
                //_EditProfile1.EditText.text = @"Full Name";
               
                NSLog(@"%lu",(unsigned long)name.length);
                
                if ([name isEqual: [NSNull null]] || [name isKindOfClass:[NSNull class]]||[name isEqual:@"(null)"] || name.length == 0) {
                     _EditProfile1.EditText.placeholder = @"Full Name";
                }
                else
                {
                     _EditProfile1.EditText.text = name;
                }
            }
            else
            {
                _EditProfile1.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"name"];
            }
            
           
        }
        if (indexPath.section == 1) {
            
            _EditProfile1.EditText.userInteractionEnabled = NO;
            _EditProfile1.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"user_name"];
        }
        if (indexPath.section == 2) {
            
            _EditProfile1.EditText.userInteractionEnabled = YES;
            
            if ([[[json valueForKey:@"userDetails"]valueForKey:@"website"] isEqual:@""]) {
                
                
                
                
                if ([website isEqual: [NSNull null]] || [website isKindOfClass:[NSNull class]]||[website isEqual:@"(null)"] || website.length == 0) {
                    _EditProfile1.EditText.placeholder = @"Website";
                }
                else
                {
                    _EditProfile1.EditText.text = website;
                }
                
                
            }
            else
            {
                _EditProfile1.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"website"];
            }
            
        }
        
        if (indexPath.section == 4) {
            
            _EditProfile1.EditText.userInteractionEnabled = YES;
            _EditProfile1.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"email_id"];
            
            
            
            
            
            
            
        }
        if (indexPath.section == 5) {
            
            _EditProfile1.EditText.userInteractionEnabled = YES;
            
            
            if ([[[json valueForKey:@"userDetails"]valueForKey:@"address"] isEqual:@""]) {
                
                _EditProfile1.EditText.placeholder = @"City / State";
                
                
                if ([address isEqual: [NSNull null]] || [address isKindOfClass:[NSNull class]]||[address isEqual:@"(null)"] || address.length == 0) {
                    _EditProfile1.EditText.placeholder = @"City / State";
                }
                else
                {
                    _EditProfile1.EditText.text = address;
                }
                
               
            }
            else
            {
                _EditProfile1.EditText.text = [[json valueForKey:@"userDetails"]valueForKey:@"address"];
            }
            
            
            
        }
        _EditProfile1.EditText.tag = indexPath.section;
        _EditProfile1.EditText.delegate = self;

        
        
        return _EditProfile1;

        
    }

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
        if(indexPath.section == 3)
        {
            
                if (Height > 46.0f) {
                    
                    return Height+32;
                    
                }
                else
                {
                    return 46.0f;
                }
            
        }
    
    
    else
    {
        return 46.0f;
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    
    else if([text isEqualToString:@"\n"]) {
        
        if ([textView.text isEqual:@""]) {
            
             textView.text = @"Bio";
        }
        [textView resignFirstResponder];
        _EditProfile.CharacterCount.hidden = YES;
        return NO;
        
    }
    
    
    else if([[textView text] length] > 149)
    {
        NSLog(@"%lu",(unsigned long)[[textView text] length]);
        
        return NO;
        
        
        
    }
    
    return YES;
}





-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    
    UITableViewCell * theCell = (UITableViewCell *)[edittable
                                                    cellForRowAtIndexPath:indexPath];
    
    CGPoint tableViewCenter = CGPointMake(0, 205.0f) ;
    
    tableViewCenter.y += edittable.frame.size.height/2;
    
    [edittable setContentOffset:CGPointMake(0,theCell.center.y-40) animated:YES];
    
    if ([textView.text isEqual:@"Bio"]) {
        
        textView.text = @"";
        
        long len = textView.text.length;
        _EditProfile.CharacterCount.text =[NSString stringWithFormat:@"%li",150-len];
        _EditProfile.CharacterCount.hidden = NO;
       
    }
    else
    {
        
        long len = textView.text.length;
        _EditProfile.CharacterCount.text =[NSString stringWithFormat:@"%li",150-len];
        _EditProfile.CharacterCount.hidden = NO;
    }
    

    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:textField.tag];
    
    UITableViewCell * theCell = (UITableViewCell *)[edittable
                                                    cellForRowAtIndexPath:indexPath];
 
    CGPoint tableViewCenter = CGPointMake(0, 205.0f) ;
    
    tableViewCenter.y += edittable.frame.size.height/2;
    
    [edittable setContentOffset:CGPointMake(0,theCell.center.y-65) animated:YES];
    
    
    
}



- (void)textViewDidChange:(UITextView *)textView{
    
    
    indexpath = textView.tag;
    
    
    if (indexpath == 3) {
        
        
       
        

        
        
        _EditProfile.EditText.textColor = [UIColor blackColor];
        CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(225, 900)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                      context:nil];
        
        
        
        CGSize size = textRect.size;
        NSLog(@"%f",size.height);
        //Height = size.height;
        
        if (size.height >46) {
            
            Height = size.height+25;
        }
        else
        {
            Height = 46.0f;
        }
       float numberOfLines = size.height / [UIFont systemFontOfSize:14.0f].lineHeight;
        
        
        
        NSLog(@"%f",numberOfLines);
        
        if (numberOfLines == 3) {
            
            if (isEnter == NO) {
                
                [edittable beginUpdates];
                [edittable endUpdates];
                
                isEnter =YES;
            }
            
        }
        
        
        //        else if (numberOfLines == 4)
//        {
//            
//            
//            if (isEnter == NO) {
//                
//                [edittable beginUpdates];
//                [edittable endUpdates];
//                
//                isEnter =YES;
//            }
//            
//
//        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        
        UITableViewCell * theCell = (UITableViewCell *)[edittable
                                                        cellForRowAtIndexPath:indexPath];
        
        CGPoint tableViewCenter = CGPointMake(0, 205.0f) ;
        
        tableViewCenter.y += edittable.frame.size.height/2;
        
        [edittable setContentOffset:CGPointMake(0,theCell.center.y-40) animated:YES];

        
        
        bio = textView.text;
        
       
        
        
        
        long len = textView.text.length;
        
        _EditProfile.CharacterCount.text =[NSString stringWithFormat:@"%li",150-len];
    }
    
    
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0 ) {
        name = textField.text;
    }
    else if (textField.tag == 2 ) {
        website = textField.text;
    }
    else if (textField.tag == 5 ) {
        address = textField.text;
    }
    else if (textField.tag == 4 ) {
        
        email = textField.text;
    }
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}


-(void)Update{
    
    if (name.length == 0) {
        name = @"";
    }
    if (address.length == 0) {
        address = @"";
    }
    if (website.length == 0) {
        website = @"";
    }
    if (bio.length == 0) {
        bio = @"";
    }
    
    
    NSError *error;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"&" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *feedpicStr = [regex1 stringByReplacingMatchesInString:imageurl options:0 range:NSMakeRange(0, [imageurl length]) withTemplate:@"*"];
    
    NSLog(@"%@",feedpicStr);
    
    
    
    NSString *value = [NSString stringWithFormat:@"user_id=%@&name=%@&uname=%@&address=%@&bio=%@&website=%@&email=%@&img_path=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Userdata"]valueForKey:@"id"],name,username,address,bio,website,email,feedpicStr];
    
    NSLog(@"%@",value);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://doitte.com/hoosright/user_update.php"]];
    NSLog(@"my--%@",url);
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    //NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    
    
    NSDictionary *json1 = [NSJSONSerialization
            JSONObjectWithData:urlData //1
            
            options:kNilOptions
            error:&error];
    
    NSLog(@"%@",json1);
    
    if ([[json1 valueForKey:@"msg"] isEqual:@"User updated!"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"HoosRight" message:@"Something Wrong. Try After Sometime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    

    
}




#pragma mark -/* Methods*/


-(void)picFromGallery{
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,nil];
    
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
    
}
-(void)picFromCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    }
    else
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
    
    
}

#pragma  mark- uiimagepicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    ProImage.image = image;
    CGSize imagesize = CGSizeMake(150, 150);
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadimage:image :imagesize];
    
    
    
}


#pragma mark - upload image to server
-(void)uploadimage :(UIImage *)image :(CGSize)imagesize
{
    
    indicator.hidden = NO;
    [indicator startAnimating];
    ProImage.alpha =.5f;
    
    
    
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
    if (result1.length>0) {
        imageurl=[NSString stringWithFormat:@"http://doitte.com/hoosright/%@",returnString];
        NSLog(@"%@",imageurl);
        indicator.hidden = YES;
        [indicator stopAnimating];
        ProImage.alpha =1.0f;
        [ProImage setImageWithURL:[NSURL URLWithString:imageurl]];
        
        
        
    }
    
    
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"From Photo Gallery"]) {
        [self picFromGallery];
        
    }
    if ([buttonTitle isEqualToString:@"Take New Pic"]) {
        [self picFromCamera];
    }
    
    
}

- (IBAction)ChangePic:(id)sender {
    
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc ]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Photo Gallery",@"Take New Pic", nil];
    
    [actionSheet showInView:self.view];
}


- (IBAction)DoneTap:(id)sender {
    
    [self Update];
    
   // [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)CancelTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
