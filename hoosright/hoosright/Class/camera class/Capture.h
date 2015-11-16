//
//  Capture.h
//  hoosright
//
//  Created by rupam on 7/10/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Capture : UIViewController
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSString *from;
@property(nonatomic,retain)NSData *passvideodata;
-(void)display :(NSURL *)url :(UIImage *)image :(NSString *)type;
@end

