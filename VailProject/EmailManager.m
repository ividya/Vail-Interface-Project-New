//
//  EmailTestManager.m
//  VailProject
//
//  Created by Michael Chun on 5/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "EmailManager.h"

// Initialize objects for EmailTest
@implementation EmailManager
@synthesize emailModelArray;
@synthesize calendarModelArray;
@synthesize deletedEmailModelArray;
@synthesize tutorialMode;

static EmailManager *sharedSingleton = nil;

+ (EmailManager *)instance
{
    @synchronized(self)
    {
        if (sharedSingleton == NULL)
        {
            sharedSingleton = [[self alloc] init];
            sharedSingleton.emailModelArray = [NSMutableArray array];
            sharedSingleton.deletedEmailModelArray = [NSMutableArray array];
            sharedSingleton.calendarModelArray = [NSMutableArray array];
        }
    }
    return sharedSingleton;
}

- (void) addMoreEmails
{
    if (tutorialMode) return;
    
    [emailModelArray removeAllObjects];
    
    EmailModel *emailModel;
    emailModel = [[[EmailModel alloc] init] autorelease];
    emailModel.sender = @"Kim";
    emailModel.subject = @"Party tonight";
    emailModel.date = @"9:30 AM";
    emailModel.body = @"Mark your calendar. It's going to be the party of the year.  Come to my house at 10:00 pm";
    emailModel.eventHour = @"22";
    emailModel.eventMin = @"00";
    emailModel.eventTitle = @"Party with Kim";
    emailModel.headingSoundFile = @"h3";
    emailModel.contentSoundFile = @"b3";
    emailModel.eventSoundFile = @"e3";
    emailModel.newmail = YES;
    emailModel.undeletable = YES;
    emailModel.emailIndex = 1;
    [emailModelArray insertObject:emailModel atIndex:0];
    
    emailModel = [[[EmailModel alloc] init] autorelease];
    emailModel.sender = @"Sean";
    emailModel.subject = @"Deal of the week";
    emailModel.date = @"9:45 AM";
    emailModel.body = @"This is a spam mail.";
    emailModel.headingSoundFile = @"h4";
    emailModel.contentSoundFile = @"b4";
    emailModel.newmail = YES;
    emailModel.emailIndex = 0;
    [emailModelArray insertObject:emailModel atIndex:0];
}

- (void) dealloc
{
    self.emailModelArray = nil;
    self.calendarModelArray = nil;
    self.deletedEmailModelArray = nil;
    
    [super dealloc];
}

@end
