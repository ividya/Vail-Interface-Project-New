//
//  EmailViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/3/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "EmailViewController.h"
#import "EmailBodyViewController.h"
#import "EmailModel.h"
#import "InterfaceVariableManager.h"
#import "EmailManager.h"
#import "ViewEffects.h"

@implementation EmailViewController

@synthesize listCell;
@synthesize voiceOnlyView;
@synthesize firstEmailButton;
@synthesize secondEmailButton;
@synthesize repeatButton;
@synthesize simpleButtonView;
@synthesize player=_player;
@synthesize startView;
@synthesize finishView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Vehicle Email Interface";
        transistionAnimation = YES;
        receivedEmail = NO;
        stage1complete = NO;
        stage2complete = NO;
                
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"experimentBegin" result:@"" time:[NSDate date]];
    }    
    return self;
}

- (void)addNewEmails:(id) param
{
    receivedEmail = YES;
    [self.tableView reloadData];
    [blackView removeFromSuperview];
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    
    // Do notification
    if([varMan displayMode] == SCREEN_DISPLAY) {
        [ViewEffects blink:[UIApplication sharedApplication].keyWindow];
        [ViewEffects popupAlertViewWithMsg:@"New Email!!!" targetViewController:self forDuration:5];
    }
    else if([varMan displayMode] == VOICE_DISPLAY) {
        // Play new email sound
        NSString *soundFileName = @"newemail";
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [_player play];

        [NSThread sleepForTimeInterval:[self.player duration]+1];

    }
    

    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"selectoneofthefollowing" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
    }

    
    [self repeatEmail:nil];
    

    if (![EmailManager instance].tutorialMode)
    {
        if([varMan displayMode] == SCREEN_DISPLAY) {
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emaillist" result:@"start" time:[[NSDate date] dateByAddingTimeInterval:5]];
        }
        else
        {
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emaillist" result:@"start" time:[NSDate date]];            
        }
    }

}



- (BOOL) checkTaskCompletion
{
    NSArray *mainEmails = [EmailManager instance].emailModelArray;
    
    BOOL taskCompleted = YES;
    
    for (EmailModel *element in mainEmails) {
        if (element.undeletable) {
            if (element.response == nil)
                taskCompleted = NO;
            
            if (!element.addedToCalendar)
                taskCompleted = NO;
            
            if (element.mustDelete)
                taskCompleted = NO;
        }
        else
        {
            taskCompleted = NO;
        }
    }
    
    return taskCompleted;
}


- (void)dealloc
{    
    [firstEmailButton release];
    [secondEmailButton release];
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
    
    blackView = [[UIView alloc] initWithFrame:[self.view frame]];
    [blackView setBackgroundColor:[UIColor blackColor]];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EmailSimpleView" owner:self options:nil];
    id obj = [topLevelObjects objectAtIndex:0];
    self.simpleButtonView = obj;

    // Do not remove selection highlight when displaying via voice command
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];

    if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == SCREEN_FEEDBACK) {
        [self.tableView addSubview:self.simpleButtonView];
    }
    
    if([varMan feedbackMode] == VOICE_FEEDBACK) {
        self.tableView.userInteractionEnabled = NO;
    }
    
    if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == VOICE_FEEDBACK) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
    }

    self.startView = [[[NSBundle mainBundle] loadNibNamed:@"StartView" owner:self options:nil] objectAtIndex:0];
    self.finishView = [[[NSBundle mainBundle] loadNibNamed:@"FinishView" owner:self options:nil] objectAtIndex:0]; 

    if (![EmailManager instance].tutorialMode)
    {
        [ViewEffects showView:self.startView targetView:self.tableView];
        [ViewEffects hideView:self.startView delay:7];
    }
        
    // Hide both buttons until email is received
    self.firstEmailButton.hidden = YES;
    self.secondEmailButton.hidden = YES;
    
    if ([EmailManager instance].tutorialMode){
        [ViewEffects popupAlertViewWithMsg:@"Your goal is to delete spam mails and respond to other emails.\n\n Email containing event information must be added to calendar as well." targetViewController:self forDuration:10];
        
        [self performSelector:@selector(addNewEmails:) withObject:nil afterDelay:12];
    }
    else
        [self performSelector:@selector(addNewEmails:) withObject:nil afterDelay:20];
}

- (void)viewDidUnload
{
    [self setFirstEmailButton:nil];
    [self setSecondEmailButton:nil];
    [self setRepeatButton:nil];
    [blackView release];
    [self.player stop];
    self.player = nil;

    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        [ViewEffects hideVoiceView:1 enableTableView:nil];
    }

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (receivedEmail)
    {
        if ([[EmailManager instance].emailModelArray count] == 1){
            firstEmailButton.hidden = YES;
            secondEmailButton.hidden = NO; 
            repeatButton.hidden = NO;
        }
        else if ([[EmailManager instance].emailModelArray count] == 2){
            firstEmailButton.hidden = NO;
            secondEmailButton.hidden = NO;        
            repeatButton.hidden = NO;
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Register current view as the EMAIL_ADMIN listener
    [[InterfaceVariableManager sharedManager] registerController:EMAIL_ADMIN controller:self];
    
    if([self checkTaskCompletion] && !stage1complete){
        
        if ([EmailManager instance].tutorialMode)
        {
            UILabel *label = (id)[self.finishView viewWithTag:1];
            label.text = @"Tutorial Complete";
            
            label = (id)[self.finishView viewWithTag:2];
            label.text = @"";
            
            [ViewEffects showView:self.finishView targetView:self.tableView];
            [ViewEffects hideView:self.finishView delay:10];
            [self performSelector:@selector(returnToMainMenu:) withObject:nil afterDelay:10];
            return;
        }
        
        stage1complete = YES;
        
        [self.view addSubview:blackView];
        
        [[EmailManager instance] addMoreEmails];
        
        [self performSelector:@selector(addNewEmails:) withObject:nil afterDelay:20];
        return;

    }
    if([self checkTaskCompletion] && stage1complete){
        
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"experimentEnd" result:@"" time:[NSDate date]];
        
        
        [ViewEffects showView:self.finishView targetView:self.tableView];
        [ViewEffects hideView:self.finishView delay:30];
        
        [self performSelector:@selector(returnToMainMenu:) withObject:nil afterDelay:30];
        return;
    }
        
    // For display feedback
    if (receivedEmail)
    {   
        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            
            NSString *soundPath;/* = [[NSBundle mainBundle] pathForResource:@"emaillist" ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player stop];
            [self.player play];
            [NSThread sleepForTimeInterval:[self.player duration]+0.5];*/

            if([[EmailManager instance].emailModelArray count] == 2){
                soundPath = [[NSBundle mainBundle] pathForResource:@"selectoneofthefollowing" ofType:@"mp3"];
                self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [self.player stop];
                [self.player play];
                [NSThread sleepForTimeInterval:[self.player duration]+0.5];

                soundPath = [[NSBundle mainBundle] pathForResource:@"firstemail" ofType:@"mp3"];
                self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [self.player stop];
                [self.player play];
                [NSThread sleepForTimeInterval:[self.player duration]+0.5];
                
                soundPath = [[NSBundle mainBundle] pathForResource:@"secondemail" ofType:@"mp3"];
                self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [self.player stop];
                [self.player play];
                [NSThread sleepForTimeInterval:[self.player duration]+0.5];
            }

            if([[EmailManager instance].emailModelArray count] == 1){
                soundPath = [[NSBundle mainBundle] pathForResource:@"selectoneofthefollowing" ofType:@"mp3"];
                self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [self.player stop];
                [self.player play];
                [NSThread sleepForTimeInterval:[self.player duration]+0.5];
                                
                soundPath = [[NSBundle mainBundle] pathForResource:@"secondemail" ofType:@"mp3"];
                self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                [self.player stop];
                [self.player play];
                [NSThread sleepForTimeInterval:[self.player duration]+0.5];
            }

        }
        
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emaillist" result:@"start" time:[NSDate date]];
    }
    return;

}

-(void)viewWillDisappear:(BOOL)animated{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma Remote controlled commands

- (void)repeatEmail:(id) param
{    
    [self.player stop];

    for (int i = 0; i < [[EmailManager instance].emailModelArray count]; i++)
    {        
        EmailModel *email = [[EmailManager instance].emailModelArray objectAtIndex:i];
        NSString *soundPath;
        
        if ([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            switch (email.emailIndex)
            {
                case 0:
                    soundPath = [[NSBundle mainBundle] pathForResource:@"firstemail" ofType:@"mp3"];
                    self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                    [self.player play];
                    [NSThread sleepForTimeInterval:[self.player duration]+0.5];
                    break;
                case 1:
                    soundPath = [[NSBundle mainBundle] pathForResource:@"secondemail" ofType:@"mp3"];
                    self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
                    [self.player play];
                    [NSThread sleepForTimeInterval:[self.player duration]+0.5];
                    self.secondEmailButton.enabled = YES;
                    break;
                default:
                    break;
            }
            
            soundPath = [[NSBundle mainBundle] pathForResource:email.headingSoundFile ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player play];                        
            [NSThread sleepForTimeInterval:[self.player duration] + 0.5];
        }   
        email.newmail = NO;
    }
    
    // Show both buttons
    [self viewWillAppear:NO];
}

- (void)firstEmail:(id) param
{
    [self.player stop];

    if ([self.tableView numberOfRowsInSection:0] < 1)
        return;
    
    if (receivedEmail && ![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailList" result:@"selectFirst" time:[NSDate date]];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];        
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)secondEmail:(id) param
{
    [self.player stop];
    
    if ([self.tableView numberOfRowsInSection:0] < 1)
        return;
    
    if (receivedEmail && ![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailList" result:@"selectSecond" time:[NSDate date]];

    NSIndexPath *indexPath;
    if ([self.tableView numberOfRowsInSection:0] == 1)
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    else
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];        
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];

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
    
}

- (void)commandList:(id) param
{
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY &&
       [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"availablevoicecommands" ofType:@"mp3"];
        
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"listenagain" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"firstEmail" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"secondEmail" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];        
    }
    
    else if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY) {
        
    }
}

- (void)yes:(id) param
{
    
}
- (void)no:(id) param
{
    
}
- (void)maybe:(id) param
{
    
}
- (void)cancel:(id) param
{
    
}

- (void) returnToMainMenu: (id) param
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!receivedEmail) {
        return 0;
    }
    return [[[EmailManager instance] emailModelArray] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        return nil;
    }

    if (!receivedEmail) {
        return @"No Emails";
    }
    return @"New Emails";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmailListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EmailListCell" owner:self options:nil];
        cell = listCell;
        self.listCell = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    
    EmailModel *email = [[[EmailManager instance] emailModelArray] objectAtIndex:indexPath.row];
    ((UILabel *)[cell viewWithTag:1]).text = email.sender;
    ((UILabel *)[cell viewWithTag:2]).text = email.subject;
    ((UILabel *)[cell viewWithTag:3]).text = email.date;
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        cell.hidden = YES;
    }
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView new] autorelease];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EmailBodyViewController *bodyViewController = [[EmailBodyViewController alloc] initWithNibName:@"EmailBodyViewController" bundle:nil];

    EmailModel *email = [[[EmailManager instance] emailModelArray] objectAtIndex:indexPath.row];
    [bodyViewController setModel:email setEmailListVC:self];
    [self.navigationController pushViewController:bodyViewController animated:transistionAnimation];
    [bodyViewController release];
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //[voiceOnlyView removeFromSuperview];
}
- (IBAction)firstEmailAction:(id)sender {
    [self firstEmail:nil];
}

- (IBAction)secondEmailAction:(id)sender {
    [self secondEmail:nil];
}

- (IBAction)repeatEmailList:(id)sender {
    [self repeatEmail:nil];
}
@end
