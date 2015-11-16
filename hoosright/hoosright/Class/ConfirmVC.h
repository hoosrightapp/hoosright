//
//  ConfirmVC.h
//  hoosright
//
//  Created by rupam on 8/10/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmVC : UIViewController

// Get data from privious screen
@property (nonatomic,retain)UIImage *PassPostImage;
@property (nonatomic,retain)NSURL *PassPostVideoUrl;
@property (nonatomic,retain)NSString *Type;
@property (nonatomic,retain)NSData *passvideodata;

@end
