//
//  AddCalendarViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "AddCalendarViewController.h"
#import "CalendarEventModel.h"
#import "EmailManager.h"
#import "InterfaceVariableManager.h"
#import "ViewEffects.h"

@implementation AddCalendarViewController

@synthesize topView;
@synthesize eventTitleUILabel;
@synthesize eventTitle;
@synthesize eventHourUILabel;
@synthesize eventMinUILabel;
@synthesize eventHour;
@synthesize eventMin;
@synthesize player;
@synthesize email;
@synthesize infoView;
@synthesize addCalendarButton;
@synthesize repeatButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [topView release];
    [eventTitleUILabel release];
    [eventTitle release];
    [eventDateUILabel release];
    [addCalendarButton release];
    [infoView release];
    [repeatButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    eventTitleUILabel.text = self.email.eventTitle;
    eventHourUILabel.text = self.email.eventHour;
    eventMinUILabel.text = self.email.eventMin;
    
    self.navigationItem.hidesBackButton = YES;
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    
    if([varMan displayMode] == SCREEN_DISPLAY) {
        self.repeatButton.hidden = YES;
    }    
    
    if([varMan displayMode] == VOICE_DISPLAY) {
        [self.view setBackgroundColor:[UIColor blackColor]];
        self.infoView.hidden = YES;
    }
    
    if([varMan feedbackMode] == VOICE_FEEDBACK) {
        self.addCalendarButton.userInteractionEnabled = NO;
        self.repeatButton.userInteractionEnabled = NO;
    }

    if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == VOICE_FEEDBACK) {
        self.repeatButton.hidden = YES;
        self.addCalendarButton.hidden = YES;
    }    
}

- (void)viewDidUnload
{
    [self setTopView:nil];
    [self setEventTitleUILabel:nil];
    [self setEventHourUILabel:nil];
    [self setEventMinUILabel:nil];
    [self setAddCalendarButton:nil];
    [self setInfoView:nil];
    [self setRepeatButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[InterfaceVariableManager sharedManager] registerController:EMAIL_ADMIN controller:self];
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    if([varMan displayMode] == SCREEN_DISPLAY) {
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:2].hidden = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    [self repeatEmail:nil];
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"calendar" result:@"show" time:[NSDate date]];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)addCalendarAction:(id)sender {
    [self addCalendar:nil];
}

- (IBAction)repeatAction:(id)sender {
    [self repeatEmail:nil];
}

- (void)repeatEmail:(id) param
{
    [self.player stop];
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) 
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"confirmingaddtocalendar" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+1];
        
        soundPath = [[NSBundle mainBundle] pathForResource:email.eventSoundFile ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+1];
    }

    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY &&
            [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sayaddtocalendar" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
    }
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == SCREEN_FEEDBACK) {
        [self.view viewWithTag:2].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
    }
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"calendar" result:@"start" time:[NSDate date]];

}
- (void)firstEmail:(id) param
{
    
}
- (void)secondEmail:(id)param
{
    
}
- (void)closeEmail:(id) param
{
    
}
- (void)replyEmail:(id) param
{
    
}
- (void)deleteEmail:(id) param
{
    
}
- (void)addCalendar:(id) param
{    
    [self.player stop];
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"calendar" result:@"addCalendarButton" time:[NSDate date]];
    
    email.addedToCalendar = YES;
    
    CalendarEventModel *eventModel = [[[CalendarEventModel alloc] init] autorelease];
    eventModel.eventTitle = eventTitleUILabel.text;
    eventModel.hour = self.eventHourUILabel.text;
    eventModel.min =self.eventMinUILabel.text;
    
    [[EmailManager instance].calendarModelArray addObject:eventModel]; 
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) 
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"eventadded" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"returningtoemaillist" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
    }
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY) 
    {
        [ViewEffects popupAlertViewWithMsg:@"Event added to calendar." targetViewController:self forDuration:3];
    }
    
    int vcIndex = [[self.navigationController viewControllers] indexOfObject:self];
    
    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:vcIndex-2];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)commandList:(id) param
{
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY &&
       [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"availablevoicecommands" ofType:@"mp3"];
        
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +1];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"listenagain" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"addtocalendar" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
    }    
}

- (void)yes:(id) param
{


}
- (void)no:(id) param
{
    
}
@end
