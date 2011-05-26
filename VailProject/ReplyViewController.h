//
//  ReplyViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "EmailBodyViewController.h"
#import "ModalViewDelegate.h"

@interface ReplyViewController : UIViewController {
    UIButton *yesButton, *noButton, *maybeButton, *cancelButton;
    NSObject<ModalViewDelegate> *delegate;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) EmailModel *email;

@property (nonatomic, retain) IBOutlet UIButton *yesButton;
@property (nonatomic, retain) IBOutlet UIButton *noButton;
@property (nonatomic, retain) NSObject<ModalViewDelegate> *delegate;

-(IBAction) yesButtonAction:(id) sender;
-(IBAction) noButtonAction:(id) sender;
- (IBAction)repeatAction:(id)sender;

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

@end
