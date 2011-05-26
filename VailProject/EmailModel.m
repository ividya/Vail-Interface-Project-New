#import "EmailModel.h"

@implementation EmailModel

@synthesize sender;
@synthesize subject;
@synthesize date;
@synthesize body;
@synthesize eventHour;
@synthesize eventMin;
@synthesize eventTitle;
@synthesize headingSoundFile;
@synthesize contentSoundFile;
@synthesize response;
@synthesize eventSoundFile;

@synthesize addedToCalendar;
@synthesize undeletable;
@synthesize newmail;
@synthesize mustDelete;
@synthesize emailIndex;

- (void)dealloc {
    self.sender = nil;
    self.subject = nil;
    self.date = nil;
    self.body = nil;
    self.eventTitle = nil;
    self.eventHour = nil;
    self.eventMin = nil;
    self.headingSoundFile = nil;
    self.contentSoundFile = nil;
    self.response = nil;
    self.eventSoundFile = nil;
	[super dealloc];
}


@end
