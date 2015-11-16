//
//  CustomTabBarViewController.m
//  demo
//
//  Created by rupam on 7/24/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//
#import "CustomTabBarViewController.h"
#import "AVCamViewController.h"


#define SELECTED_VIEW_CONTROLLER_TAG 98456345



@implementation CustomTabBarViewController
@synthesize tabBar,tabBarItems;

- (id)init {
    // Call the init method implemented by the superclass
    self = [super init];
    if(self) {
        
        
    }
    // Return the address of the new object
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    
    
    // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
    
    
    
    NSLog(@"%lu",(unsigned long)tabBarItems.count);
    self.tabBar = [[CustomTabBar alloc] initWithItemCount:tabBarItems.count itemSize:CGSizeMake(self.view.frame.size.width/tabBarItems.count, 64) tag:0 delegate:self];
    
    // Place the tab bar at the bottom of our view
    tabBar.frame = CGRectMake(0,self.view.frame.size.height-64,self.view.frame.size.width, 64);
    tabBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabBar];
    
    // Select the first tab
    [tabBar selectItemAtIndex:0];
    [self touchDownAtItemAtIndex:0];
    
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    NSDictionary* data = [tabBarItems objectAtIndex:0];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    
    viewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
    
    
}

#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:@"image"]];
}
/*
- (UIImage*) backgroundImage
{
    // The tab bar's width is the same as our width
    CGFloat width = self.view.frame.size.width;
    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Create a new image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    [[UIColor blackColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
 */

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
    return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
/*
- (UIImage*) glowImage
{
    UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
    
    // Create a new image using the TabBarGlow image but offset 4 pixels down
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
    
    // Draw the image
    [tabBarGlow drawAtPoint:CGPointZero];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
 */

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    
    CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, 64);
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
    [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:0] drawInRect:CGRectMake(4, 4.0, tabBarItemSize.width-8, tabBarItemSize.height-6.0)];
    
    // Generate a new image
    UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selectedItemImage;
}
/*
 
- (UIImage*) tabBarArrowImage
{
    return [UIImage imageNamed:@"TabBarNipple.png"];
}
 
 */

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    //UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Set the view controller's frame to account for the tab bar
    //viewController.view.frame = CGRectMake(0,self.view.bounds.size.height-64,self.view.bounds.size.width, self.view.bounds.size.height-64);
    
    
    
    
     if (itemIndex == 2) {
         
         
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"from"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpostdata"];
        
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        
                [UIView animateWithDuration:.3
                                      delay:.1
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                    
                                     
                                     //self.view.frame = CGRectMake(0,self.view.frame.size.height,self.view.frame.size.width, self.view.frame.size.height-64);
             
                                     
                                 }
                                 completion:^(BOOL finished){
                                     
                                   
                    [UIView animateWithDuration:.1
                        delay:.1
                        options:UIViewAnimationOptionLayoutSubviews
                            animations:^{
                                
                                
                                //self.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
                                
                                
                                
                                AVCamViewController *AVCamViewController_ = [[AVCamViewController alloc]init];
                                UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:AVCamViewController_];
                            [self presentViewController:nav1 animated:NO completion:nil];
                        }
                        completion:^(BOOL finished){
                            
                        }];
            }];
    }
    else
    {
        UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        [currentView removeFromSuperview];
        
        
        // Get the right view controller
        NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
        NSLog(@"%lu",(unsigned long)itemIndex);
        UIViewController* viewController = [data objectForKey:@"viewController"];
        
        NSLog(@"%lu",(unsigned long)itemIndex);
        
        viewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view insertSubview:viewController.view belowSubview:tabBar];
        //[self.view addSubview:viewController.view];
        tabBar.hidden = NO;
        
    }
    
    
    
    
    
    // Se the tag so we can find it later
    //viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    // Add the new view controller's view
    
    
    // In 1 second glow the selected tab
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
    
}
/*
- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    // Remove the glow from all tab bar items
    for (NSUInteger i = 0 ; i < tabBarItems.count ; i++)
    {
        [tabBar removeGlowAtIndex:i];
    }
    
    // Then add it to this tab bar item
    [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Let the tab bar that we're about to rotate
    [tabBar willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Adjust the current view in prepartion for the new orientation
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    //UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    
    CGFloat width = 0, height = 0;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        width = self.view.window.frame.size.width;
        height = self.view.window.frame.size.height;
    }
    else
    {
        width = self.view.window.frame.size.height;
        height = self.view.window.frame.size.width;
    }
    
    currentView.frame = CGRectMake(0,0,width, height);
}


@end
