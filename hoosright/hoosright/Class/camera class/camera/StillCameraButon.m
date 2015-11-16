//
//  StillCameraButon.m
//  DemoCam
//
//  Created by rupam on 7/6/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import "StillCameraButon.h"
#define LINE_WIDTH 2.0f
#define DEFAULT_FRAME CGRectMake(0.0f, 0.0f, 68.0f, 68.0f)

@interface StillCameraButon()

@property (nonatomic, strong) CALayer *circleLayer;
@end

@implementation StillCameraButon

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:DEFAULT_FRAME]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    _circleLayer = [CALayer layer];
    _circleLayer.backgroundColor = [UIColor redColor].CGColor;
    _circleLayer.bounds = CGRectInset(self.bounds, 8, 8);
    _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    NSLog(@"%f",_circleLayer.bounds.size.width);
    _circleLayer.cornerRadius = _circleLayer.bounds.size.width/2.0f ;
    [self.layer addSublayer:_circleLayer];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGRect insetRect = CGRectInset(rect, LINE_WIDTH / 2.0f, LINE_WIDTH / 2.0f);
    CGContextStrokeEllipseInRect(context, insetRect);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeAnimation.duration = 0.2f;
    if (highlighted) {
        fadeAnimation.toValue = @0.0f;
    } else {
        fadeAnimation.toValue = @1.0f;
    }
    self.circleLayer.opacity = [fadeAnimation.toValue floatValue];
    [self.circleLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [CATransaction disableActions];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    if (selected) {
        scaleAnimation.toValue = @0.6f;
        radiusAnimation.toValue = @(self.circleLayer.bounds.size.width / 4.0f);
    } else {
        scaleAnimation.toValue = @1.0f;
        radiusAnimation.toValue = @(self.circleLayer.bounds.size.width / 2.0f);
    }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, radiusAnimation];
    animationGroup.beginTime = CACurrentMediaTime() + 0.2f;
    animationGroup.duration = 0.35f;
    
    [self.circleLayer setValue:radiusAnimation.toValue forKeyPath:@"cornerRadius"];
    [self.circleLayer setValue:scaleAnimation.toValue forKeyPath:@"transform.scale"];
    
    [self.circleLayer addAnimation:animationGroup forKey:@"scaleAndRadiusAnimation"];
}







@end
