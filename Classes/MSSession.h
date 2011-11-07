//
//  MSSession.h
//  Manistone
//
//  Created by Eugenio Depalo on 19/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"
#import "MSAPIRequest.h"

extern NSString *const MSSessionDidLoginNotification;
extern NSString *const MSSessionLoginDidFailNotification;
extern NSString *const MSSessionDidLogoutNotification;
extern NSString *const MSSessionDidTimeoutNotification;

@interface MSSession : TTURLRequestModel {
	MSUser *_user;
	BOOL _timedOut;
}

+ (MSSession *)applicationSession;

@property (nonatomic, retain) MSUser *user;
@property (nonatomic, assign) BOOL timedOut;

- (void)loginWithEmail:(NSString *)email password:(NSString *)password;
- (void)logout;

@end
