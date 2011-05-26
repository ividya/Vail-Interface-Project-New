//
//  EmailViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailModel.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface EmailViewController : UITableViewController <AVAudioPlayerDelegate>{
    UITableViewCell *listCell;
    
    @private
    UIView *voiceOnlyView;
    UIView *blackView;
    UIButton *firstEmailButton;
    UIButton *secondEmailButton;
    UIButton *repeatButton;
    BOOL transistionAnimation;
    BOOL receivedEmail;
    BOOL stage1complete;
    BOOL stage2complete;
    
    UIView *startView;
    UIView *finishView;
    
    UIView *simpleButtonView;
}

- (void)repeatEmail:(id) param;
- (void)firstEmail:(id) param;
- (void)secondEmail:(id) param;
- (void)closeEmail:(id) param;
- (void)replyEmail:(id) param;
- (void)deleteEmail:(id) param;
- (void)addCalendar:(id) param;
- (void)addNewEmails:(id) param;

- (void)commandList:(id) param;
- (void)yes:(id) param;
- (void)no:(id) param;
- (void) returnToMainMenu: (id) param;

@property (nonatomic, assign) IBOutlet UITableViewCell *listCell;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) UIView *voiceOnlyView;
@property (nonatomic, retain) UIView *simpleButtonView;
@property (nonatomic, retain) IBOutlet UIButton *firstEmailButton;
@property (nonatomic, retain) IBOutlet UIButton *secondEmailButton;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton;
@property (nonatomic, retain) UIView *startView;
@property (nonatomic, retain) UIView *finishView;
- (IBAction)firstEmailAction:(id)sender;
- (IBAction)secondEmailAction:(id)sender;
- (IBAction)repeatEmailList:(id)sender;

@end
