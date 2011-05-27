
@interface EmailModel : NSObject {
}

@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *eventHour;
@property (nonatomic, retain) NSString *eventMin;
@property (nonatomic, retain) NSString *eventTitle;
@property (nonatomic, retain) NSString *headingSoundFile;
@property (nonatomic, retain) NSString *contentSoundFile;
@property (nonatomic, retain) NSString *response;
@property (nonatomic, retain) NSString *eventSoundFile;
@property (nonatomic) NSUInteger emailIndex;
@property bool addedToCalendar;
@property bool undeletable;
@property bool newmail;
@property bool mustDelete;
@property bool readContent;
@end
