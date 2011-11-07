//
//  MSGeocoder.m
//  Manistone
//
//  Created by Eugenio Depalo on 18/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSGeocoder.h"
#import "MSGeocoderResult.h"
#import <Three20Core/NSArrayAdditions.h>

static NSString *kGeocoderQueryFormat = @"http://maps.google.com/maps/api/geocode/json?address=%@&language=%@&sensor=true";

@implementation MSGeocoder

@synthesize results = _results;

- (id)initWithQueryString:(NSString *)query {
	if(self = [self init]) {
		_query = [query retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_results);
	TT_RELEASE_SAFELY(_query);
	
	[super dealloc];
}

- (void)search:(NSString *)text {
    [self cancel];
	
	TT_RELEASE_SAFELY(_results);
	
	if(TTIsStringWithAnyText(text)) {
		TT_RELEASE_SAFELY(_query);
		
		_query = [text retain];
		
		[self load:TTURLRequestCachePolicyNone more:NO];
	}
	else {
		[self.delegates perform:@selector(modelDidStartLoad:) withObject:self];
		[self.delegates perform:@selector(modelDidFinishLoad:) withObject:self];
	}
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading) {
		NSString *string = [NSString stringWithFormat:kGeocoderQueryFormat,
							_query,
							[[NSLocale preferredLanguages] objectAtIndex:0]];
		
		TTURLRequest *request = [TTURLRequest requestWithURL:string delegate:self];
		request.response = [[[TTURLJSONResponse alloc] init] autorelease];
		request.cachePolicy = TTURLRequestCachePolicyNone;
		
		[request send];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;
	
	NSArray* rawResults = [result objectForKey:@"results"];
	
	NSMutableArray *results = [[NSMutableArray alloc] init];
	
	for(NSDictionary *resultDictionary in rawResults) {
		MSGeocoderResult *result = [[MSGeocoderResult alloc] init];
		result.address = [resultDictionary objectForKey:@"formatted_address"];
		
		NSDictionary *geometry = [resultDictionary objectForKey:@"geometry"];
		NSDictionary *viewport = [geometry objectForKey:@"viewport"];
		
		NSDictionary *northEastCoordinate = [viewport objectForKey:@"northeast"];
		
		CLLocationCoordinate2D northEast = { [[northEastCoordinate objectForKey:@"lat"] floatValue],
			[[northEastCoordinate objectForKey:@"lng"] floatValue] };
		result.northEast = northEast;
		
		NSDictionary *southWestCoordinate = [viewport objectForKey:@"southwest"];
		
		CLLocationCoordinate2D southWest = { [[southWestCoordinate objectForKey:@"lat"] floatValue],
			[[southWestCoordinate objectForKey:@"lng"] floatValue] };
		result.southWest = southWest;
		
		[results addObject:result];
		TT_RELEASE_SAFELY(result);
	}
	
	TT_RELEASE_SAFELY(_results);
	_results = results;
	
	[super requestDidFinishLoad:request];
}


@end
