//
//  EmailTestManager.h
//  VailProject
//
//  Created by Michael Chun on 5/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmailModel.h"
#import "CalendarEventModel.h"

// Stores models that can be accessed from multiple view controllers
@interface EmailManager : NSObject {

}
@property (nonatomic, retain) NSMutableArray *emailModelArray;
@property (nonatomic, retain) NSMutableArray *deletedEmailModelArray;
@property (nonatomic, retain) NSMutableArray *calendarModelArray;

@property (nonatomic, assign) BOOL tutorialMode;

+ (EmailManager *)instance;

- (void) addMoreEmails;
@end
