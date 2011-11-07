//
//  MSRemoteObjectModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObjectModel.h"
#import "MSMemberRequest.h"

@implementation MSRemoteObjectModel

@synthesize remoteObject = _remoteObject;
@synthesize parameters = _parameters;

- (id)initWithResource:(Class)resource uid:(NSUInteger)uid {
	self = [self initWithResource:resource uid:uid parameters:nil];
	
	return self;
}

- (id)initWithResource:(Class)resource uid:(NSUInteger)uid parameters:(NSDictionary *)parameters {
	if(self = [self initWithResource:resource]) {
		_uid = uid;
		_parameters = !parameters ? [[NSMutableDictionary alloc] init] : [parameters mutableCopy];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_remoteObject);
	TT_RELEASE_SAFELY(_parameters);
	
	[super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if(!self.isLoading) {
		MSMemberRequest *request = [[[MSMemberRequest alloc] initWithResource:[_resource collectionName]
																	   member:[NSString stringWithFormat:@"%lu", _uid]
																	   action:MSMemberRequestActionRead parameters:_parameters delegate:self] autorelease];
		
		[request send];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;
	
	TT_RELEASE_SAFELY(_remoteObject);
	_remoteObject = [[_resource alloc] initWithAttributes:result];

	[super requestDidFinishLoad:request];
}

@end
