//
//  EmailBodyViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailModel.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "ModalViewDelegate.h"
#import "EmailViewController.h"

@interface EmailBodyViewController : UITableViewController <ModalViewDelegate> {
    
    UITableViewCell *singleTextView;
    UITableViewCell *multipleTextView;
    UITableViewCell *emailToolView;
    
    @private
    EmailModel *email;
    UITableViewCell *toolBox;
    BOOL animation;
    BOOL deletedEmail;
    UIViewController *prevVC;
    BOOL readBody;
}
@property (nonatomic, retain) IBOutlet UITableViewCell *singleTextView;
@property (nonatomic, retain) IBOutlet UITableViewCell *multipleTextView;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailToolView;
@property (nonatomic, retain) IBOutlet UITableViewCell *toolBox;
@property (nonatomic, retain) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton;

@property (nonatomic, retain) EmailModel *email;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) EmailViewController *emailListVC;
@property (nonatomic, retain) UIViewController *prevVC;

@property (nonatomic, retain) UITableViewCell *cell1;
@property (nonatomic, retain) UITableViewCell *cell2;
@property (nonatomic, retain) UITableViewCell *cell3;
@property (nonatomic, retain) UITableViewCell *cell4;
@property (nonatomic, retain) UITableViewCell *cell5;

@property (nonatomic, retain) UIView *voiceOnlyView;
- (IBAction)addCalendarAction:(id)sender;
- (IBAction)replyEmailAction:(id)sender;
- (IBAction)deleteEmailAction:(id)sender;
- (IBAction)closeEmailAction:(id)sender;
- (IBAction)repeatAction:(id)sender;



- (void)repeatEmail:(id) param;
- (void)firstEmail:(id) param;
- (void)secondEmail:(id) param;

- (void)addNewEmails:(id) param;
- (void)addMoreEmails:(id) param;

- (void)commandList:(id) param;
- (void)yes:(id) param;
- (void)no:(id) param;
- (void)maybe:(id) param;
- (void)cancel:(id) param;

-(void) addCalendar:(id) param;
-(void) replyEmail:(id) param;
-(void) deleteEmail:(id) param;
-(void) closeEmail:(id) param;

- (void)setModel:(EmailModel *)aModel setEmailListVC:(EmailViewController *)vc;

- (void)dismissModalView;
@end
