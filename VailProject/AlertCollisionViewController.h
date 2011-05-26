//
//  AlertCollisionViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/23/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AlertCollisionViewController : UIViewController <AVAudioPlayerDelegate> {
        NSTimer *refreshTimer;
        AVAudioPlayer *alertPlayer;
        AVAudioPlayer *exitPlayer;
        long startDistance;
        BOOL isRecorded;
}

@property (nonatomic,retain) IBOutlet UIView* rightScreenView;
@property (nonatomic,retain) IBOutlet UIView* leftScreenView;
@property (nonatomic,retain) IBOutlet UIView* voiceView;
@property (nonatomic,retain) IBOutlet UIView* exitView;

@property (nonatomic,retain) IBOutlet UILabel* rLabel;
@property (nonatomic,retain) IBOutlet UILabel* lLabel;



@property BOOL isRight;
@property int currentLane;

- (void)exitCollisionView;

@end
