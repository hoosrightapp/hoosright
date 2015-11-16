//
//  KSHPreviewView.h
//  MosiacCamera
//
//  Created by 金聖輝 on 14/11/30.
//  Copyright (c) 2014年 kimsungwhee.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import "KSHImageTarget.h"


@interface KSHPreviewView : GLKView<KSHImageTarget>


@property (strong, nonatomic) CIContext *coreImageContext;

@end
// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net