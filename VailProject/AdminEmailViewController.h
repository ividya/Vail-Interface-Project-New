//
//  AdminEmailViewController.h
//  VailProject
//
//  Created by Michael Chun on 5/5/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminEmailViewController : UIViewController {
    
}

- (IBAction)receiveNewEmail:(id)sender;
- (IBAction)helpMenu:(id)sender;

- (IBAction)repeatEmail:(id)sender;
- (IBAction)firstEmail:(id)sender;
- (IBAction)secondEmail:(id)sender;
- (IBAction)closeEmail:(id)sender;

- (IBAction)replyEmail:(id)sender;
- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

- (IBAction)addCalendar:(id)sender;
- (IBAction)deleteEmail:(id)sender;
@end
