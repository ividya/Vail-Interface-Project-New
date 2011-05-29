//
//  TestMethodViewController.m
//  VailProject
//
//  Created by Jeongjin on 5/2/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "TestMethodViewController.h"
#import "ScenarioSelectViewController.h"
#import "InterfaceVariableManager.h"
#import "ViewEffects.h"
#import "AdminModeSelectViewController.h"


@implementation TestMethodViewController

@synthesize uniqueTextField = _uniqueTextField;
@synthesize displaySwitch = _displaySwitch;
@synthesize feedbackSwitch = _feedbackSwitch;
@synthesize subjectId;
@synthesize testType;

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
    _uniqueTextField.delegate = self;
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _uniqueTextField.delegate = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[InterfaceVariableManager sharedManager] registerController:CONFIG_ADMIN controller:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)goScenario:(id)sender
{   
    if(_uniqueTextField.text == nil || [_uniqueTextField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please insert unique test code!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil]; 
        [alert show];
        [alert release];
        return;
    }
    
    if([InterfaceVariableManager isKeyExist:_uniqueTextField.text]){
        [ViewEffects popupAlertViewWithMsg:@"Warning\n\n Key Already Exists." targetViewController:self forDuration:1.5];
    }
    
    
    [[InterfaceVariableManager sharedManager] setTestId:_uniqueTextField.text];
    
    if(_displaySwitch.on){
        [[InterfaceVariableManager sharedManager] setDisplayMode:SCREEN_DISPLAY];
    }else{
        [[InterfaceVariableManager sharedManager] setDisplayMode:VOICE_DISPLAY];
    }
    
    if(_feedbackSwitch.on){
        [[InterfaceVariableManager sharedManager] setFeedbackMode:SCREEN_FEEDBACK];
    }else{
        [[InterfaceVariableManager sharedManager] setFeedbackMode:VOICE_FEEDBACK];
    }

    ScenarioSelectViewController *nController =[[ScenarioSelectViewController alloc] initWithNibName:@"ScenarioSelectViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goScenario:nil];
    return YES;
}

- (void)setSubjectId:(NSString *)aSubjectId
{
    self.uniqueTextField.text = aSubjectId;
}

- (void)setTestType:(NSString *)aTestType
{
    if ([@"1" isEqualToString:aTestType])
    {
        _displaySwitch.on = YES;
        _feedbackSwitch.on = YES;
    }
    if ([@"2" isEqualToString:aTestType])
    {
        _displaySwitch.on = NO;
        _feedbackSwitch.on = YES;
    }
    if ([@"3" isEqualToString:aTestType])
    {
        _displaySwitch.on = YES;
        _feedbackSwitch.on = NO;
    }
    if ([@"4" isEqualToString:aTestType])
    {
        _displaySwitch.on = NO;
        _feedbackSwitch.on = NO;
    }
    
    if (self.uniqueTextField.text != nil)
        [self goScenario:nil];

}

- (IBAction)goAdmin:(id)sender
{
    [[InterfaceVariableManager sharedManager] setTestMode:ADMIN_MODE];
    
    AdminModeSelectViewController *nController =[[AdminModeSelectViewController alloc] initWithNibName:@"AdminModeSelectViewController" bundle:nil];
    [self.navigationController pushViewController:nController animated:YES];
    [nController release]; 
}


@end
