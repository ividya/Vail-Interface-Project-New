//
//  AddCalendarViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "EmailModel.h"

@interface AddCalendarViewController : UIViewController {
    
    UIView *topView;
    UILabel *eventTitleUILabel;
    NSString *eventTitle;
    NSString *eventHour;
    NSString *eventMin;
    UILabel *eventDateUILabel;
    UIButton *addCalendarButton;
    UIButton *repeatButton;
    UIView *infoView;
}

@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UILabel *eventTitleUILabel;
@property (nonatomic, retain) IBOutlet UILabel *eventHourUILabel;
@property (nonatomic, retain) IBOutlet UILabel *eventMinUILabel;
@property (nonatomic, retain) NSString *eventTitle;
@property (nonatomic, retain) NSString *eventHour;
@property (nonatomic, retain) NSString *eventMin;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) EmailModel *email;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIButton *addCalendarButton;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton;

- (IBAction)addCalendarAction:(id)sender;
- (IBAction)repeatAction:(id)sender;

- (void)repeatEmail:(id) param;
- (void)firstEmail:(id) param;
- (void)secondEmail:(id) param;
- (void)closeEmail:(id) param;
- (void)replyEmail:(id) param;
- (void)deleteEmail:(id) param;
- (void)addCalendar:(id) param;

- (void)addNewEmails:(id) param;
- (void)addMoreEmails:(id) param;

- (void)yes:(id) param;
- (void)no:(id) param;
@end
