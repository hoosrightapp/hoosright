//
//  CustomTabBarViewController.h
//  demo
//
//  Created by rupam on 7/24/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface CustomTabBarViewController : UIViewController<CustomTabBarDelegate>
{
    CustomTabBar* tabBar;
}

@property (nonatomic, retain) CustomTabBar* tabBar;
@property (nonatomic, retain)NSArray *tabBarItems;

@end
