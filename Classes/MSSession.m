//
//  MSSession.m
//  Manistone
//
//  Created by Eugenio Depalo on 19/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSSession.h"

NSString *const MSSessionDidLoginNotification  = @"MSSessionDidLoginNotification";
NSString *const MSSessionLoginDidFailNotification  = @"MSSessionLoginDidFailNotification";
NSString *const MSSessionDidLogoutNotification = @"MSSessionDidLogoutNotification";
NSString *const MSSessionDidTimeoutNotification = @"MSSessionDidTimeoutNotification";

@implementation MSSession

@synthesize user = _user;
@synthesize timedOut = _timedOut;

static MSSession *session = nil;

+ (MSSession*)applicationSession
{
    if (session == nil) {
        session = [[super allocWithZone:NULL] init];
    }
    return session;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self applicationSession] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
	
}

- (id)autorelease
{
    return self;
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
	MSAPIRequest *request = [[[MSAPIRequest alloc] initWithController:@"session"
															   action:nil
															   method:@"POST"
														   parameters:[NSDictionary dictionaryWithObject:
																	   [NSDictionary dictionaryWithObjectsAndKeys:
																		email, @"email",
																		password, @"password", nil] forKey:@"user_session"]
															 delegate:self] autorelease];
	
	[request send];
}

- (void)logout {
	MSAPIRequest *request = [[[MSAPIRequest alloc] initWithController:@"session"
															   action:nil
															   method:@"DELETE"
														   parameters:nil
															 delegate:self] autorelease];
	
	[request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	if([request.httpMethod isEqualToString:@"POST"]) {
		_timedOut = NO;
		
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		TT_RELEASE_SAFELY(_user);
		_user = [[MSUser alloc] initWithAttributes:response.rootObject];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MSSessionDidLoginNotification object:self];
	}
	else if([request.httpMethod isEqualToString:@"DELETE"]) {
		TT_RELEASE_SAFELY(_user);
		[[NSNotificationCenter defaultCenter] postNotificationName:MSSessionDidLogoutNotification object:self];
	}
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	TT_RELEASE_SAFELY(_user);
	
	switch (error.code) {
		case 401:
			[[NSNotificationCenter defaultCenter] postNotificationName:MSSessionLoginDidFailNotification object:self];
			break;
		default:
			[[NSNotificationCenter defaultCenter] postNotificationName:MSSessionDidTimeoutNotification object:self];
			break;
	}
}

@end
