//
//  EmailBodyViewController.m
//  VailProject
//
//  Created by Michael Chun on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "EmailBodyViewController.h"
#import "AddCalendarViewController.h"
#import "ReplyViewController.h"
#import "CalendarViewController.h"
#import "CalendarEventModel.h"
#import "EmailModel.h"
#import "EmailManager.h"
#import "ViewEffects.h"

#import "InterfaceVariableManager.h"

@implementation EmailBodyViewController
@synthesize singleTextView;
@synthesize multipleTextView;
@synthesize emailToolView;
@synthesize email;
@synthesize player=_player;
@synthesize toolBox;
@synthesize calendarButton;
@synthesize repeatButton;
@synthesize voiceOnlyView;
@synthesize emailListVC;
@synthesize prevVC;

@synthesize cell1;
@synthesize cell2;
@synthesize cell3;
@synthesize cell4;
@synthesize cell5;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [singleTextView release];
    [multipleTextView release];
    [emailToolView release];
    [toolBox release];
    
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
    
    
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
    
    if([varMan displayMode] == VOICE_DISPLAY) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
    }
    
    if([varMan feedbackMode] == VOICE_FEEDBACK) {
        self.emailToolView.userInteractionEnabled = NO;
    }
    
    if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == VOICE_FEEDBACK) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
        
    self.navigationItem.hidesBackButton = YES;
    deletedEmail = NO;
    
}

- (void)viewDidUnload
{
    
    [self setSingleTextView:nil];
    [self setMultipleTextView:nil];
    [self setEmailToolView:nil];
    [self setToolBox:nil];
    self.prevVC = nil;
    self.emailListVC = nil;
    self.email = nil;
    
    [self.voiceOnlyView removeFromSuperview];
    self.voiceOnlyView = nil;
    
    [self.player stop];
    self.player = nil;
        
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for remote listener
    [[InterfaceVariableManager sharedManager] registerController:EMAIL_ADMIN controller:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    
    [self repeatEmail:nil];
    
    if([[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) 
    {
        if ([EmailManager instance].tutorialMode)
            [self commandList:nil];
    }

    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) {
        cell5.hidden = YES;
    }
    else
    {
        cell5.hidden = NO;
    }
    

    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"start" time:[NSDate date]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) 
        return 0;    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY && [[InterfaceVariableManager sharedManager] feedbackMode] == VOICE_FEEDBACK) 
        return 0;

    // Return the number of rows in the section.
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Multiline text height
    if (indexPath.row == 3){
        float width = self.view.bounds.size.width - 35 * 2;
        
        CGSize labelSize = [email.body sizeWithFont:[UIFont systemFontOfSize:36.0f] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 30 * 2;
        
    }
    
    // Toolbox height
    if (indexPath.row == 4)
        return 405;
    
    // Single input field height
    return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SingleTextField";
    static NSString *BodyCellIdentifier = @"EmailMultipleTextView";
    static NSString *ToolCellIdentifier = @"EmailToolView";
    
    if(indexPath.row < 3) {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"EmailSingleTextView" owner:self options:nil];
            cell = self.singleTextView;     
            self.singleTextView = nil;
        }
        
        switch(indexPath.row){
            case 0:
                ((UILabel *)[cell viewWithTag:1]).text = @"Sender :";
                ((UILabel *)[cell viewWithTag:2]).text = email.sender;
                self.cell1 = cell;
                break;
            case 1:
                ((UILabel *)[cell viewWithTag:1]).text = @"Subject :";
                ((UILabel *)[cell viewWithTag:2]).text = email.subject;
                self.cell2 = cell;
                break;
            case 2:
                ((UILabel *)[cell viewWithTag:1]).text = @"Date :";
                ((UILabel *)[cell viewWithTag:2]).text = email.date;   
                self.cell3 = cell;
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
        if([varMan displayMode] == VOICE_DISPLAY) {
            cell.hidden = YES;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        return cell;
        
    }
    else if(indexPath.row == 3){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BodyCellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"EmailMultipleTextView" owner:self options:nil];
            cell = self.multipleTextView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.multipleTextView = nil;
        }
        
        ((UILabel *)[cell viewWithTag:1]).text = email.body;
        
        InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
        if([varMan displayMode] == VOICE_DISPLAY && [varMan feedbackMode] == SCREEN_FEEDBACK) {
            cell.hidden = YES;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else{
            cell.hidden = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }

        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) {
            cell.hidden = YES;
        }

        self.cell4 = cell;
        return cell;
    }
    else if(indexPath.row == 4){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ToolCellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"EmailToolView" owner:self options:nil];
            cell = self.emailToolView;     
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];
            if([varMan displayMode] == VOICE_DISPLAY) {
                self.repeatButton.hidden = NO;
            }            
        }

//        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) {
//            cell.hidden = YES;
//        }
        
        cell.hidden = YES;
        cell5 = cell;
        return cell;
    }
    return nil;
    // Configure the cell...
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView new] autorelease];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (IBAction)addCalendarAction:(id)sender {
    [self addCalendar:nil];
}

- (IBAction)replyEmailAction:(id)sender {
    [self replyEmail:nil];
}

- (IBAction)deleteEmailAction:(id)sender {
    [self deleteEmail: nil];
}

- (IBAction)closeEmailAction:(id)sender {
    [self closeEmail: nil];
}
         
- (IBAction)repeatEmailAction:(id)sender {
    [self repeatEmail: nil];
}

- (void)setModel:(EmailModel *)aModel setEmailListVC:(EmailViewController *)vc
{
    self.email = aModel;
    self.emailListVC = vc;
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

        soundPath = [[NSBundle mainBundle] pathForResource:@"reply" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"delete" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"orclose" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
    }
    
    else if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY) {
        
    }
}


- (void)dismissModalView
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma Remote controllable
- (void)repeatEmail:(id) param
{    
    [self.player stop];
    
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY) {
        
        NSString *soundPath;
        NSString *emailNumber;
        
        if (email.emailIndex == 0)
            emailNumber = @"firstemail";
        if (email.emailIndex == 1)        
            emailNumber = @"secondemail";
        
        soundPath = [[NSBundle mainBundle] pathForResource:emailNumber ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:email.headingSoundFile ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];                        
        [NSThread sleepForTimeInterval:[self.player duration] + 0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"emailcontent" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];                        
        [NSThread sleepForTimeInterval:[self.player duration] + 0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:email.contentSoundFile ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration] +0.5];
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
    [self.player stop];
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContentButton" result:@"close" time:[NSDate date]];
    
    if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"emailclosed" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"returningtoemaillist" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        
        email.newmail = NO;     
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)replyEmail:(id) param
{

    [self.player stop];
    if(email.mustDelete == YES)
    {
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"incorrectTaskReply" time:[NSDate date]];
        
        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"incorrecttask" ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player play];
            [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        }
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY)
        {
            [ViewEffects popupAlertViewWithMsg:@"Incorrect task." targetViewController:self forDuration:3];
        }
        return;
    }
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"replyButton" time:[NSDate date]];

    
    ReplyViewController *replyVC = [[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
    replyVC.delegate = self;
    replyVC.email = self.email;
    
    [self.navigationController pushViewController:replyVC animated:YES];
    
    [replyVC release];
}

- (void)deleteEmail:(id) param
{
    // Double click protection
    if(deletedEmail == YES) return;
    deletedEmail = YES;
        
    InterfaceVariableManager *varMan = [InterfaceVariableManager sharedManager];

    [self.player stop];
    if(email.undeletable == YES)
    {
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"incorrectTaskDelete" time:[NSDate date]];
        
        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"incorrecttask" ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player play];
            [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        }
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY)
        {
            [ViewEffects popupAlertViewWithMsg:@"Incorrect task." targetViewController:self forDuration:3];
        }
        return;
        
    }
    
    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"deletedButton" time:[NSDate date]];
    
    // Add to deleted list
    [[EmailManager instance].deletedEmailModelArray addObject:email];
    
    // Remove from main list
    [[EmailManager instance].emailModelArray removeObject:email];
    [self.emailListVC.tableView reloadData];

    if([varMan displayMode] == SCREEN_DISPLAY) {
        [ViewEffects popupAlertViewWithMsg:@"Email deleted." targetViewController:self forDuration:3];
    }
    
    if([varMan displayMode] == VOICE_DISPLAY) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"emaildeleted" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player stop];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        
        soundPath = [[NSBundle mainBundle] pathForResource:@"returningtoemaillist" ofType:@"mp3"];
        self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        [self.player play];
        [NSThread sleepForTimeInterval:[self.player duration]+0.5];
    }    
        
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCalendar:(id) param
{
    // Don't add unknown emails
    [self.player stop];
    
    if(email.eventHour == nil || email.eventMin == nil)
    {
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"incorrectTaskCalendar" time:[NSDate date]];
        
        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"incorrecttask" ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player play];
            [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        }
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY)
        {
            [ViewEffects popupAlertViewWithMsg:@"Incorrect task." targetViewController:self forDuration:3];
        }
        
        return;
    }
    
    if(email.addedToCalendar == YES)
    {
        if (![EmailManager instance].tutorialMode)
            [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"incorrectTaskDuplicateCalendarEntry" time:[NSDate date]];
        
        if([[InterfaceVariableManager sharedManager] displayMode] == VOICE_DISPLAY)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"eventexists" ofType:@"mp3"];
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
            [self.player play];
            [NSThread sleepForTimeInterval:[self.player duration]+0.5];
        }
        if([[InterfaceVariableManager sharedManager] displayMode] == SCREEN_DISPLAY)
        {
            [ViewEffects popupAlertViewWithMsg:@"Event already added to calendar." targetViewController:self forDuration:3];
        }
        return;
    }

    if (![EmailManager instance].tutorialMode)
        [[InterfaceVariableManager sharedManager] saveEvent:EMAIL_MODE event:@"emailContent" result:@"addCalendarButton" time:[NSDate date]];

    AddCalendarViewController *calendarVC = [[AddCalendarViewController alloc] initWithNibName:@"AddCalendarViewController" bundle:nil];
    
    calendarVC.email = self.email;
    
    [self.navigationController pushViewController:calendarVC animated:YES];
    [calendarVC release];
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
- (void)addNewEmails:(id)param
{
    
}
- (void)addMoreEmails:(id)param
{
    
}

@end
