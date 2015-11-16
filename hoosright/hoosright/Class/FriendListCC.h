//
//  FriendListCC.h
//  hoosright
//
//  Created by Rupam Chakraborty on 5/23/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilepic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIImageView *status;
@property (strong, nonatomic) IBOutlet UIButton *SendRequest;

@end
