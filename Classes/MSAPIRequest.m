//
//  MSAPIRequest.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "extThree20JSON/JSON.h"
#import "MSSession.h"
#import "MSAPIRequest.h"

#ifdef DEBUG
static const NSString *kAPIServerRoot = @"http://192.168.1.201:3000";
#else
static const NSString *kAPIServerRoot = @"http://manistone.heroku.com";
#endif

@implementation MSAPIRequest

@synthesize controller = _controller;
@synthesize action = _action;

+ (NSString *)serverRoot {
	return [NSString stringWithString:(NSString *)kAPIServerRoot];
}

- (id)initWithController:(NSString *)controller
				  action:(NSString *)action
				  method:(NSString *)method
			  parameters:(NSDictionary *)parameters
				delegate:(id<TTURLRequestDelegate>)delegate {
	BOOL isGET = [method isEqualToString:@"GET"];
	
	NSMutableString *completeURL = [kAPIServerRoot mutableCopy];
	
	if(TTIsStringWithAnyText(controller))
		[completeURL appendFormat:@"/%@", controller];
	
	if(TTIsStringWithAnyText(action))
		[completeURL appendFormat:@"/%@", action];
	
	[completeURL appendString:@".json"];
	
	if(isGET && [parameters isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *escapedParameters = [parameters mutableCopy];
		
		for(NSString *key in parameters) {
			if([[parameters valueForKey:key] isKindOfClass:[NSString class]])
				[escapedParameters setValue:[[parameters valueForKey:key] stringByReplacingOccurrencesOfString:@" " withString:@"+"] forKey:key];
			else
				[escapedParameters setValue:[[parameters valueForKey:key] description] forKey:key];
		}
		
		[completeURL appendString:[@"" stringByAddingQueryDictionary:escapedParameters]];
		
		TT_RELEASE_SAFELY(escapedParameters);
	}
	
	if(self = [self initWithURL:completeURL delegate:delegate]) {
		[self.delegates addObject:self];
		
		_controller = [controller retain];
		_action = [action retain];
		
		self.response = [[[TTURLJSONResponse alloc] init] autorelease];
		self.httpMethod = method;
		self.contentType = @"application/json";
		self.cachePolicy = TTURLRequestCachePolicyNone;
		
		if(!isGET) {
			self.httpBody = [[parameters JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
		}
	}
	
	TT_RELEASE_SAFELY(completeURL);
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_controller);
	TT_RELEASE_SAFELY(_action);
	
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES] applyQuery:
											[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"session_timeout"]]];
	
	[self release];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	if(error.code == 401) {
		if([MSSession applicationSession].user != nil) {
			[MSSession applicationSession].user = nil;
			[MSSession applicationSession].timedOut = YES;
			
			[[TTURLRequestQueue mainQueue] cancelAllRequests];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Session timed out", @"")
															message:NSLocalizedString(@"Your session has timed out. Please login again.", @"")
														   delegate:nil
												  cancelButtonTitle:nil
												  otherButtonTitles:@"OK", nil];
			alert.delegate = [self retain];
			
			[alert show];
			TT_RELEASE_SAFELY(alert);
		}
	} else if(error.code != 422) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", @"")
														message:NSLocalizedString(@"There was an error contacting the server. Please check your internet connection.", @"")
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
}

@end
