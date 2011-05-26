//
//  InterfaceVariableManager.h
//  VailProject
//
//  Created by Jeongjin on 5/4/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VailEvent;
typedef enum
{
    VOICE_DISPLAY,SCREEN_DISPLAY
} DisplayMode;

typedef enum
{
    VOICE_FEEDBACK,SCREEN_FEEDBACK
} FeedbackMode; 

typedef enum
{
    REAL_MODE,SIMUL_MODE,ADMIN_MODE
} TestMode;

typedef enum
{
    EMAIL_MODE,TODO_MODE,NAVIGATION_MODE,CONFIG_MODE, SCENARIO_MODE
} SubTestMode;


#define PATH_SELECTION_ADMIN @"PATH_SELECTION_ADMIN"
#define DESTINATION_SELECTION_ADMIN @"DESTINATION_SELECTION_ADMIN"

#define EMAIL_ADMIN @"EMAIL_ADMIN"
#define CONFIG_ADMIN @"CONFIG_ADMIN"
#define SCENARIO_ADMIN @"SCENARIO_ADMIN"


@interface InterfaceVariableManager : NSObject {
}

@property double distance;
@property double speed;
@property int lane;
@property (retain)  NSString *testId;
@property DisplayMode  displayMode;
@property FeedbackMode  feedbackMode;
@property TestMode testMode;
@property (retain)  NSString *clientIP;
@property (retain)  NSString *clientPort;
@property (retain)  NSMutableDictionary *controllers;

+ (id)sharedManager;
+ (BOOL) isKeyExist:(NSString *)key;

- (void)updateInformationWith:(NSString*)uri params:(NSDictionary*)params;
- (void)saveEvent:(SubTestMode)subTestMode event:(NSString*)event result:(NSString*) result time:(NSDate*)time;
- (VailEvent*)loadEvent:(SubTestMode)subTestMode event:(NSString*)event;
- (void)registerController:(NSString*) key controller:(id)controller ;
@end
