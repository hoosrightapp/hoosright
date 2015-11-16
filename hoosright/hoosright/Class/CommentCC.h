//
//  CommentCC.h
//  hoosright
//
//  Created by rupam on 9/1/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *Comment;
@property (strong, nonatomic) IBOutlet UILabel *Time;

@end
