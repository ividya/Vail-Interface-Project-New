//
//  PathNavigationViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAudioPlayer;
@interface PathNavigationViewController : UIViewController {
    NSMutableDictionary *prospectedEvent;
    double lastIndicatedDistance;
    NSString *lastIndicatedDirection;
}

@property (nonatomic, retain) IBOutlet UIImageView *rightView;
@property (nonatomic, retain) IBOutlet UIImageView *leftView;
@property (nonatomic, retain) IBOutlet UIImageView *straightView;
@property (nonatomic, retain) IBOutlet UIImageView *micView;
@property (nonatomic, retain) NSString *pathValue;
@property (nonatomic, retain) AVAudioPlayer *player;

@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *pathLabel;

@property (nonatomic, retain) NSTimer *refreshTimer;

- (void)indicateStraight;
- (void)indicateRight;
- (void)indicateLeft;
- (void)refreshEvent;
- (void)quitNavigation;


@end
