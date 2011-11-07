//
//  MSMemberRequest.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSMemberRequest.h"

@implementation MSMemberRequest

- (id)initWithResource:(NSString *)resource
				member:(NSString *)member
				action:(MSMemberRequestAction)action
			parameters:(NSDictionary *)parameters
			  delegate:(id<TTURLRequestDelegate>)delegate {
	switch(action) {
		case MSMemberRequestActionRead:
			self = [self initWithController:resource
									 action:member
									 method:@"GET"
								 parameters:parameters
								   delegate:delegate];
			
			break;
			
		case MSMemberRequestActionUpdate:
			self = [self initWithController:resource
									 action:member
									 method:@"PUT"
								 parameters:parameters
								   delegate:delegate];
			
			break;
			
		case MSMemberRequestActionDelete:
			self = [self initWithController:resource
									 action:member
									 method:@"DELETE"
								 parameters:parameters
								   delegate:delegate];
			
			break;
	}
	
	return self;
}

@end
