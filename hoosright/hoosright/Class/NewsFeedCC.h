//
//  NewsFeedCC.h
//  hoosright
//
//  Created by Rupam Chakraborty on 5/22/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titel;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *profileimage1;
@property (strong, nonatomic) IBOutlet UIImageView *profileimage2;
@property (strong, nonatomic) IBOutlet UILabel *vs;
@property (strong, nonatomic) IBOutlet UILabel *descriptiontext;

@property (strong, nonatomic) IBOutlet UIButton *favorite;
@property (strong, nonatomic) IBOutlet UIButton *comment;
@property (strong, nonatomic) IBOutlet UIButton *more;
@property (strong, nonatomic) IBOutlet UILabel *user1;
@property (strong, nonatomic) IBOutlet UILabel *user2;







@end
