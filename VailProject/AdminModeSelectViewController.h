//
//  AdminModeSelectViewController.h
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AdminModeSelectViewController : UIViewController {
    UIButton *_voicescreenAction;
    UITextField *_subjectIdField;
}

@property (nonatomic,retain) IBOutlet UITextField *ipTextField;
@property (nonatomic,retain) IBOutlet UITextField *portTextField;
@property (nonatomic, retain) IBOutlet UITextField *subjectIdField;

- (IBAction)screenscreenAction:(id)sender;
- (IBAction)voicescreenAction:(id)sender;
- (IBAction)screenvoiceAction:(id)sender;
- (IBAction)voicevoiceAction:(id)sender;


- (BOOL)saveIP;
@end
