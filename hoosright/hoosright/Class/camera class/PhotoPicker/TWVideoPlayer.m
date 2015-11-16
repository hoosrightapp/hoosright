//
//  TWVideoPlayer.m
//  hoosright
//
//  Created by rupam on 7/7/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "TWVideoPlayer.h"


@interface TWVideoPlayer ()
@property(nonatomic,retain)MPMoviePlayerController *VideoPlayer;
@end

@implementation TWVideoPlayer

- (id)initWithContentURL:(NSURL *)url {
    self = [super initWithContentURL:url];
    if (self) {
        
        
    }
    return self;
}
@end
