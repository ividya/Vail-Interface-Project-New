//
//  ScenarioSelectViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/2/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "ScenarioSelectViewController.h"
#import "PathNavigationViewController.h"
#import "EmailViewController.h"
#import "EmailManager.h"
#import "EmailModel.h"
#import "InterfaceVariableManager.h"

@implementation ScenarioSelectViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[InterfaceVariableManager sharedManager] registerController:SCENARIO_ADMIN controller:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)goNavigation:(id)sender{
    
    [[InterfaceVariableManager sharedManager] setDistance:0.0];
    [[InterfaceVariableManager sharedManager] setSpeed:0.0];
    [[InterfaceVariableManager sharedManager] setLane:2];
    

    
    
    PathNavigationViewController *nController =[[PathNavigationViewController alloc] initWithNibName:@"PathNavigationViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release];
    
}

- (IBAction)emailButtonPushed:(id)sender
{
    [[InterfaceVariableManager sharedManager] setDistance:0.0];
    [[InterfaceVariableManager sharedManager] setSpeed:0.0];
    [[InterfaceVariableManager sharedManager] setLane:2];

    // Create test model
    EmailManager *manager = [EmailManager instance];
    manager.tutorialMode = NO;
    
    NSMutableArray *emailModelArray = manager.emailModelArray;
    [emailModelArray removeAllObjects];
    
    EmailModel *emailModel;
    emailModel = [[[EmailModel alloc] init] autorelease];    
    emailModel.sender = @"John";
    emailModel.subject = @"Sanfrancisco News";
    emailModel.date = @"5:30 AM";
    emailModel.body = @"Textbooks are only 99cents. Come visit us.";
    emailModel.headingSoundFile = @"h0";
    emailModel.contentSoundFile = @"b0";
    emailModel.newmail = YES;
    emailModel.mustDelete = YES;
    emailModel.emailIndex = 1;
    [emailModelArray insertObject:emailModel atIndex:0];

    emailModel = [[[EmailModel alloc] init] autorelease];
    emailModel.sender = @"Bob";
    emailModel.subject = @"Plans for today";
    emailModel.date = @"4:30 AM";
    emailModel.body = @"We have a meeting with Charlie at noon.  Can you join us?";
    emailModel.eventHour = @"12";
    emailModel.eventMin = @"00";
    emailModel.eventTitle = @"Meeting with Charlie";
    emailModel.headingSoundFile = @"h2";
    emailModel.contentSoundFile = @"b2";
    emailModel.eventSoundFile = @"e2";
    emailModel.newmail = YES;
    emailModel.undeletable = YES;
    emailModel.emailIndex = 0;
    [emailModelArray insertObject:emailModel atIndex:0];
    
    
    // Create calendar model
//    CalendarEventModel *event = [[CalendarEventModel alloc] init];
//    event.eventTitle = @"Dentist";
//    event.hour = @"9";
//    event.min = @"30";
//    
//    [manager.calendarModelArray addObject:event];

    // Create Email View Controller
    EmailViewController *emailVC = [[EmailViewController alloc] initWithNibName:@"EmailViewController" bundle:nil];
    [self.navigationController pushViewController:emailVC animated:YES];
    
    [emailVC release];
}

- (IBAction)tutorialButtonPushed:(id)sender
{
    [[InterfaceVariableManager sharedManager] setDistance:0.0];
    [[InterfaceVariableManager sharedManager] setSpeed:0.0];
    [[InterfaceVariableManager sharedManager] setLane:2];

    // Create test model
    EmailManager *manager = [EmailManager instance];
    manager.tutorialMode = YES;
    NSMutableArray *emailModelArray = manager.emailModelArray;
    [emailModelArray removeAllObjects];
    
    EmailModel *emailModel;
    emailModel = [[[EmailModel alloc] init] autorelease];
    emailModel.sender = @"Tutorial";
    emailModel.subject = @"Event information";
    emailModel.date = @"1:00 PM";
    emailModel.body = @"This is an event mail. Send a reply message and also add it to calendar.";
    emailModel.eventHour = @"1";
    emailModel.eventMin = @"00";
    emailModel.eventTitle = @"Some Event";
    emailModel.headingSoundFile = @"htest0";
    emailModel.contentSoundFile = @"btest0";
    emailModel.eventSoundFile = @"etest0";
    emailModel.newmail = YES;
    emailModel.undeletable = YES;
    emailModel.emailIndex = 1;
    [emailModelArray insertObject:emailModel atIndex:0];
    
    emailModel = [[[EmailModel alloc] init] autorelease];
    emailModel.sender = @"Sam";
    emailModel.subject = @"Test Email";
    emailModel.date = @"1:15 PM";
    emailModel.body = @"This is a spam mail. Delete this email.";
    emailModel.headingSoundFile = @"htest1";
    emailModel.contentSoundFile = @"btest1";
    emailModel.newmail = YES;
    emailModel.mustDelete = YES;
    emailModel.emailIndex = 0;
    [emailModelArray insertObject:emailModel atIndex:0];    
    
    // Create calendar model
    CalendarEventModel *event = [[CalendarEventModel alloc] init];
    event.eventTitle = @"Mock event";
    event.hour = @"10";
    event.min = @"00";
    
    [manager.calendarModelArray addObject:event];
    
    // Create Email View Controller
    EmailViewController *emailVC = [[EmailViewController alloc] initWithNibName:@"EmailViewController" bundle:nil];
    [self.navigationController pushViewController:emailVC animated:YES];
    
    [emailVC release];
}

@end
