//
//  ReplyViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/18/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "ReplyViewController.h"
#import "InterfaceVariableManager.h"
#import "ViewEffects.h"
#import "EmailManager.h"

@implementation ReplyViewController

@synthesize yesButton;
@synthesize noButton;
@synthesize delegate;
@synthesize player;
@synthesize email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction) yesButtonAction:(id) sender
{
    [self yes:nil];
    
}
-(IBAction) noButtonAction:(id) sender
{
    [self no:nil];
}

- (IBAction)repeatAction:(id)sender {
    [self repeatEmail:nil];
}

- (void)repeatEmail:(id) param
{
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"selectreplymessage" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        
        [NSThread sleepForTimeInterval:[self.player duration]+1];

        soundPath = [[NSBundle mainBundle] pathForResource:@"message1" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"message2" ofType:@"mp3"];
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
}

- (void)firstEmail:(id) param
{
}

- (void)secondEmail:(id) param
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
- (void)addCalendar:(id) param{
    
}

- (void)addNewEmails:(id) param
{
    
}

- (void)yes:(id) param
{
    self.email.response = @"yes";
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailReplying" result:@"yesButton" time:[NSDate date]];

    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"replymessagesent" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        
        [NSThread sleepForTimeInterval:[self.player duration]];
        soundPath = [[NSBundle mainBundle] pathForResource:@"returningtoemaillist" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]];
        
    }
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY) {
        [ViewEffects popupAlertViewWithMsg:@"Response sent" targetViewController:self forDuration:3.0];
    }

    int vcIndex = [[self.navigationController viewControllers] indexOfObject:self];
    
    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:vcIndex-2];
    [self.navigationController popToViewController:vc animated:YES];

}
- (void)no:(id) param
{
    self.email.response = @"no"; 
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailReplying" result:@"noButton" time:[NSDate date]];

    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"replymessagesent" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        
        [NSThread sleepForTimeInterval:[self.player duration]];
        soundPath = [[NSBundle mainBundle] pathForResource:@"returningtoemaillist" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]];
    }
    
    if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY) {
        [ViewEffects popupAlertViewWithMsg:@"Response sent" targetViewController:self forDuration:3.0];
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
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"message1" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"message2" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];

    }    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for remote listener
    [[InterfaceVariableManager sharedManager] registerController:EMAIL_ADMIN controller:self];
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    if([varMan displayMode] == SCREEN_DISPLAY) {
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:2].hidden = NO;
        [self.yesButton setTitle:@"Yes, I will be there." forState:UIControlStateNormal];
        [self.noButton setTitle:@"No, I cannot make it." forState:UIControlStateNormal];
    }
    if([varMan feedbackMode] == VOICE_FEEDBACK) {
        self.yesButton.enabled = NO;
        self.noButton.enabled = NO;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self repeatEmail:nil];
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailReplying" result:@"show" time:[NSDate date]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
