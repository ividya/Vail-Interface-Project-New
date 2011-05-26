//
//  SelectPathViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@class AVAudioPlayer;
@class PathNavigationViewController;

@interface SelectPathViewController : UIViewController <AVAudioPlayerDelegate>{
    NSTimer *voiceTimer;
    PathNavigationViewController *nController;
}

@property (nonatomic, retain) IBOutlet UIView *screenDisplayView;
@property (nonatomic, retain) IBOutlet UIView *voiceDisplayView;
@property (nonatomic, retain) IBOutlet UIView *screenFeedbackView;
@property (nonatomic, retain) IBOutlet UIView *voiceFeedbackView;

@property (nonatomic, retain) IBOutlet UIButton *APathButton;
@property (nonatomic, retain) IBOutlet UIButton *BPathButton;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) AVAudioPlayer *pathPlayer;

- (IBAction)selectPathButton:(id)sender;
//- (void)receiveVoiceFeedback:(NSNotification*) aNotification;
- (void)receiveVoiceFeedback:(id) params;

@end
