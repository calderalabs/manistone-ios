//
//  MSStoneSearchModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"
#import "MSSearchModel.h"
#import "MSCollectionRequest.h"
#import <Three20Core/NSArrayAdditions.h>

@implementation MSSearchModel

@synthesize parameters = _parameters;
@synthesize results = _results;
@synthesize count = _count;
@synthesize page = _page;
@synthesize pages = _pages;

- (id)initWithResource:(Class)resource collectionName:(NSString *)collectionName parameters:(NSDictionary *)parameters {
	if(self = [self initWithResource:resource parameters:parameters]) {
		_collectionName = [collectionName retain];
	}
	
	return self;
}

- (id)initWithResource:(Class)resource parameters:(NSDictionary *)parameters {
	if (self = [self initWithResource:resource]) {
		_results = [[NSMutableArray alloc] init];
		
		if(parameters)
			_parameters = [parameters mutableCopy];
		else
			_parameters = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_collectionName);
	TT_RELEASE_SAFELY(_parameters);
	TT_RELEASE_SAFELY(_results);
	
	[super dealloc];
}

- (void)search:(NSString*)text {
    [self cancel];
	
	if(TTIsStringWithAnyText(text)) {
		[_parameters setValue:text forKey:@"q"];
		
		[self load:TTURLRequestCachePolicyNone more:NO];
	}
	else {
		[self.delegates perform:@selector(modelDidStartLoad:) withObject:self];
		[self.delegates perform:@selector(modelDidFinishLoad:) withObject:self];
	}
}

- (void)loadPage:(NSUInteger)page {
	[_parameters setValue:[NSNumber numberWithUnsignedInteger:page] forKey:@"page"];
	[self load:TTURLRequestCachePolicyNone more:NO];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading) {
		MSCollectionRequest *request = [[[MSCollectionRequest alloc] initWithResource:_collectionName ? _collectionName : [_resource collectionName]
																			  action:MSCollectionRequestActionList
																		  parameters:_parameters
																			delegate:self] autorelease];
		
		[request send];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	[_results removeAllObjects];
	
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;

	NSArray* rawResults = [result objectForKey:@"results"];

	NSNumber *rawCount = [result objectForKey:@"count"];
	_count = [rawCount intValue];
	
	_pages = [[result objectForKey:@"pages"] unsignedIntegerValue];
	_page = [[result objectForKey:@"page"] unsignedIntegerValue];
	
	for (NSDictionary* rawResult in rawResults) {
		MSRemoteObject* result = [[_resource alloc] initWithAttributes:rawResult];
		
		[_results addObject:result];
		TT_RELEASE_SAFELY(result);
	}
	
	[super requestDidFinishLoad:request];
}

@end