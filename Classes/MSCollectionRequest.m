//
//  MSCollectionRequest.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSCollectionRequest.h"

@implementation MSCollectionRequest

- (id)initWithResource:(NSString *)resource
				action:(MSCollectionRequestAction)action
			parameters:(NSDictionary *)parameters
			  delegate:(id<TTURLRequestDelegate>)delegate {
	switch(action) {
		case MSCollectionRequestActionCreate:
			self = [self initWithController:resource
									 action:nil
									 method:@"POST"
								 parameters:parameters
								   delegate:delegate];
			
			break;

		case MSCollectionRequestActionList:
			self = [self initWithController:resource
									 action:nil
									 method:@"GET"
								 parameters:parameters
								   delegate:delegate];
			
			break;
	}
	
	return self;
}

@end
