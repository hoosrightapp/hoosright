//
//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "TWPhotoPickerController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWImageScrollView.h"
#import "TWVideoPlayer.h"
#import "CreatePostVC.h"

#import "ConfirmVC.h"


@interface TWPhotoPickerController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat beginOriginY;
    CreatePostVC *CreatePostVC_;
    //PostDataStorage *PostDataStorage_;
    ConfirmVC *ConfirmVC_;

   
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *maskView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;
@property (strong, nonatomic) TWVideoPlayer *videoPlayer;

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) UICollectionView *collectionView;


@end

@implementation TWPhotoPickerController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.collectionView belowSubview:self.topView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden  = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
   
    [self.videoPlayer play];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.videoPlayer stop];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CreatePostVC_ = [[CreatePostVC alloc]init];
    ConfirmVC_ = [[ConfirmVC alloc]init];
    
    
    
    //PostDataStorage_ = [[PostDataStorage alloc]init];
    if ([self.Type isEqual:@"Image"]) {
        [self loadPhotos];
        CreatePostVC_.type = @"Image";
    }
    else
    {
        [self loadVideos];
        CreatePostVC_.type = @"Video";
    }
    
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}
-(void)loadVideos{
    
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        
        
        
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allVideos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (self.assets.count) {
                
                
                
                UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:0] defaultRepresentation] fullResolutionImage]];
                [self.imageScrollView displayImage:image];
                
               // NSURL *url = [[[self.assets objectAtIndex:0] defaultRepresentation] url];
                //[self.imageScrollView displayImage:image];
                ALAssetRepresentation *representation = [[self.assets objectAtIndex:0] defaultRepresentation];
                NSURL *url = [representation url];
                [self.videoPlayer.view removeFromSuperview];
                self.videoPlayer = [[TWVideoPlayer alloc]
                                    initWithContentURL:url];
                //self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
                [self.videoPlayer prepareToPlay];
                
                
                CGRect videoRect = (CGRect) {
                    .size.width = self.view.frame.size.width,
                    .size.height = self.view.frame.size.height -260,
                    .origin.x =0, //roundf((CGRectGetWidth(self.view.bounds) - 300) / 2),
                    .origin.y = 50 //roundf((CGRectGetHeight(self.view.bounds) - 169) / 2)
                };
                [self.topView addSubview:self.videoPlayer.view];
                self.videoPlayer.view.frame = videoRect;
                 self.videoPlayer.controlStyle = MPMovieControlStyleNone;
                
                
            }
            [self.collectionView reloadData];
        }
        
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];

}
- (void)loadPhotos {
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (self.assets.count) {
                UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:0] defaultRepresentation] fullResolutionImage]];
                [self.imageScrollView displayImage:image];
            }
            [self.collectionView reloadData];
        }
        
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIView *)topView {
    if (_topView == nil) {
        CGFloat handleHeight = 44.0f;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)+handleHeight*2);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor clearColor];
        self.topView.clipsToBounds = YES;
        
        rect = CGRectMake(0, 0, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *navView = [[UIView alloc] initWithFrame:rect];//26 29 33
        navView.backgroundColor = [[UIColor colorWithRed:26.0/255 green:29.0/255 blue:33.0/255 alpha:1] colorWithAlphaComponent:.8f];
        [self.topView addSubview:navView];
        
        rect = CGRectMake(0, 0, 60, CGRectGetHeight(navView.bounds));
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = rect;
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:backBtn];
        
        rect = CGRectMake((CGRectGetWidth(navView.bounds)-100)/2, 0, 100, CGRectGetHeight(navView.bounds));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.text = @"SELECT";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [navView addSubview:titleLabel];
        
        rect = CGRectMake(CGRectGetWidth(navView.bounds)-80, 0, 80, CGRectGetHeight(navView.bounds));
        UIButton *cropBtn = [[UIButton alloc] initWithFrame:rect];
        [cropBtn setTitle:@"Next" forState:UIControlStateNormal];
        [cropBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cropBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [cropBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:cropBtn];
        
        rect = CGRectMake(0, CGRectGetHeight(self.topView.bounds)-handleHeight, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *dragView = [[UIView alloc] initWithFrame:rect];
        dragView.backgroundColor = navView.backgroundColor;
        dragView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.topView addSubview:dragView];
        
        UIImage *img = [UIImage imageNamed:@"cameraroll-picker-grip"];
        rect = CGRectMake((CGRectGetWidth(dragView.bounds)-img.size.width)/2, (CGRectGetHeight(dragView.bounds)-img.size.height)/2, img.size.width, img.size.height);
        UIImageView *gripView = [[UIImageView alloc] initWithFrame:rect];
        gripView.image = img;
        [dragView addSubview:gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        rect = CGRectMake(0, handleHeight, CGRectGetWidth(self.topView.bounds), CGRectGetHeight(self.topView.bounds)-handleHeight*2);
        /*
         
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
        
        self.maskView = [[UIImageView alloc] initWithFrame:rect];
        self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
        [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
         
        */
        
        if ([self.Type isEqual:@"Image"]) {
            self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
            [self.topView addSubview:self.imageScrollView];
            [self.topView sendSubviewToBack:self.imageScrollView];
            
            self.maskView = [[UIImageView alloc] initWithFrame:rect];
            self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
            [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
            
        }
        else
        {
            /*
             
           // self.videoPlayer = [[suman alloc] init];
            CGRect videoRect = (CGRect) {
                .size.width = 300,
                .size.height = 169,
                .origin.x =0, //roundf((CGRectGetWidth(self.view.bounds) - 300) / 2),
                .origin.y = 20 //roundf((CGRectGetHeight(self.view.bounds) - 169) / 2)
            };
            [self.topView addSubview:self.videoPlayer.view];
            self.videoPlayer.view.frame = videoRect;
            //[self.topView sendSubviewToBack:self.videoPlayer];
            
           // self.maskView = [[UIImageView alloc] initWithFrame:rect];
            //self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
           // [self.topView insertSubview:self.maskView aboveSubview:self.videoPlayer];
             
             */
        }
        
        
    }
    return _topView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat colum = 4.0, spacing = 2.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.topView.bounds));
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[TWPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCell"];
        
//        rect = CGRectMake(0, 0, 60, layout.sectionInset.top);
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = rect;
//        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        [_collectionView addSubview:backBtn];
//        
//        rect = CGRectMake((CGRectGetWidth(_collectionView.bounds)-140)/2, 0, 140, layout.sectionInset.top);
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
//        titleLabel.text = @"CAMERA ROLL";
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//        [_collectionView addSubview:titleLabel];
        
    }
    return _collectionView;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)cropAction {
    /*
    if (self.cropBlock) {
        self.cropBlock(self.imageScrollView.capture);
    }
    [self backAction];
     */
    
    [self.videoPlayer stop];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]
                 stringForKey:@"from"]);
    
    
    
     if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"FromB"] || [[[NSUserDefaults standardUserDefaults]stringForKey:@"from"] isEqual:@"AcceptFriend"]) {
        
        [self.navigationController pushViewController:ConfirmVC_ animated:YES];
        
    }
    else
    {
       [self.navigationController pushViewController:CreatePostVC_ animated:YES];
    }
    
    
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -(CGRectGetHeight(self.topView.bounds)-20-44);
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
            }
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)-20-44))) {
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
    
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame);
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.collectionView.frame = collectionFrame;
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TWPhotoCollectionViewCell";
    
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:[[self.assets objectAtIndex:indexPath.row] thumbnail]];
    CreatePostVC_.PassPostImage = [UIImage imageWithCGImage:[[self.assets objectAtIndex:0] thumbnail]];
    
    ConfirmVC_.PassPostImage = [UIImage imageWithCGImage:[[self.assets objectAtIndex:0] thumbnail]];
    
    
        ALAssetRepresentation *representation = [[self.assets objectAtIndex:indexPath.row] defaultRepresentation];
    NSURL *url = [representation url];
    
    
    
    
    if ([self.Type isEqual:@"Image"]) {
        
        CreatePostVC_.PassPostVideoUrl = [NSURL URLWithString:@""];
        ConfirmVC_.PassPostVideoUrl = [NSURL URLWithString:@""];
        
        
    }
    
    else
    {
        
        ALAssetRepresentation *rep = [[self.assets objectAtIndex:0] defaultRepresentation];
        Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        CreatePostVC_.PassPostVideoUrl = url;
        CreatePostVC_.passvideodata = data;
        
        ConfirmVC_.PassPostVideoUrl = url;
        ConfirmVC_.passvideodata = data;
        
        
    }
    
   // NSLog(@"%@",CreatePostVC_.PassPostImage);
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // ALAssetRepresentation *representation = [self.assets defaultRepresentation];
//    NSURL *url = [representation url];
    
    if ([self.Type isEqual:@"Image"]) {
        
        UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
        [self.imageScrollView displayImage:image];
        CreatePostVC_.PassPostImage = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
        
        ConfirmVC_.PassPostImage = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
        
        if (self.topView.frame.origin.y != 0) {
            [self tapGestureAction:nil];
        }
    }
    else
    {
        ALAssetRepresentation *representation = [[self.assets objectAtIndex:indexPath.row] defaultRepresentation];
            NSURL *url = [representation url];
        
        CreatePostVC_.PassPostImage =[UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
        CreatePostVC_.PassPostVideoUrl = url;
        
        
        ALAssetRepresentation *rep = [[self.assets objectAtIndex:indexPath.row] defaultRepresentation];
        Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        
        CreatePostVC_.passvideodata = data;
        
        ConfirmVC_.PassPostImage =[UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
        ConfirmVC_.PassPostVideoUrl = url;
        
        ConfirmVC_.passvideodata = data;
        
        
        
        
        
        self.videoPlayer = [[TWVideoPlayer alloc]
                            initWithContentURL:url];
        
        //self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin ;
        
        
        [self.videoPlayer prepareToPlay];
        [self.videoPlayer.view removeFromSuperview];
        
        
        CGRect videoRect = (CGRect) {
            .size.width = self.view.frame.size.width,
            .size.height = self.view.frame.size.height -260,
            .origin.x =0, //roundf((CGRectGetWidth(self.view.bounds) - 300) / 2),
            .origin.y = 50 //roundf((CGRectGetHeight(self.view.bounds) - 169) / 2)
        };
        [self.topView addSubview:self.videoPlayer.view];
        self.videoPlayer.view.frame = videoRect;
        self.videoPlayer.controlStyle = MPMovieControlStyleNone;
        
        if (self.topView.frame.origin.y != 0) {
            [self tapGestureAction:nil];
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //NSLog(@"velocity:%f", velocity.y);
    if (velocity.y >= 2.0 && self.topView.frame.origin.y == 0) {
        [self tapGestureAction:nil];
    }
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
