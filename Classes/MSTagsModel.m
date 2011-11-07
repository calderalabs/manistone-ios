//
//  MSTagsModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 16/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTagsModel.h"
#import "MSTag.h"
#import "MSCollectionRequest.h"

@implementation MSTagsModel

@synthesize tags = _tags;

- (id)init {
	if(self = [super init])
		_tags = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_tags);

    [super dealloc];
}

- (void)search:(NSString*)text {
    [self cancel];
	
	[_tags removeAllObjects];
	
	if(TTIsStringWithAnyText(text)) {
		[_tags addObject:[[[MSTag alloc] initWithName:text] autorelease]];
		
		[self.delegates perform:@selector(modelDidStartLoad:) withObject:self];
		[self.delegates perform:@selector(modelDidFinishLoad:) withObject:self];
		
		MSCollectionRequest *request = [[[MSCollectionRequest alloc] initWithResource:@"tags"
																			  action:MSCollectionRequestActionList
																		  parameters:[NSDictionary dictionaryWithObjectsAndKeys:text, @"q", nil]
																			delegate:self] autorelease];
		
		[request send];
	}
	else {
		[self.delegates perform:@selector(modelDidStartLoad:) withObject:self];
		[self.delegates perform:@selector(modelDidFinishLoad:) withObject:self];
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;
	
	NSArray* rawResults = [result objectForKey:@"results"];
	
	BOOL shouldDisplayNewTag = YES;
	
	for (NSDictionary* rawResult in rawResults) {
		if ([[rawResult valueForKey:@"name"] isEqualToString:((MSTag *)[_tags objectAtIndex:0]).name])
			shouldDisplayNewTag = NO;

		[_tags addObject:[[[MSTag alloc] initWithName:[rawResult valueForKey:@"name"] count:[rawResult valueForKey:@"count"]] autorelease]];
	}
	
	if(!shouldDisplayNewTag)
		[_tags removeObjectAtIndex:0];
	
	[super requestDidFinishLoad:request];
}

@end
