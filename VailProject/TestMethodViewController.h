//
//  TestMethodViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/2/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestMethodViewController : UIViewController <UITextFieldDelegate>{
}

@property (nonatomic,retain) IBOutlet UITextField *uniqueTextField;
@property (nonatomic,retain) IBOutlet UISwitch *displaySwitch;
@property (nonatomic,retain) IBOutlet UISwitch *feedbackSwitch;


- (IBAction)goScenario:(id)sender;
- (IBAction)goAdmin:(id)sender;

@property (nonatomic,retain) NSString *subjectId;
@property (nonatomic,retain) NSString *testType;


@end
