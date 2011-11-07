//
//  MSFavoritesModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 04/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSFavoritesModel.h"
#import "MSMemberRequest.h"

@implementation MSFavoritesModel

@synthesize stonesCount = _stonesCount;
@synthesize authorsCount = _authorsCount;
@synthesize stacksCount = _stacksCount;

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
	}
	
	return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading) {
		MSMemberRequest *request = [[[MSMemberRequest alloc] initWithResource:@"favorites"
																	   member:[NSString stringWithFormat:@"%d/counts", _uid]
																	   action:MSMemberRequestActionRead
																   parameters:nil
																	 delegate:self] autorelease];
		
		[request send];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;
	
	_stonesCount = [[result valueForKey:@"stones_count"] unsignedIntegerValue];
	_stacksCount = [[result valueForKey:@"stacks_count"] unsignedIntegerValue];
	_authorsCount = [[result valueForKey:@"users_count"] unsignedIntegerValue];
	
	[super requestDidFinishLoad:request];
}

@end
