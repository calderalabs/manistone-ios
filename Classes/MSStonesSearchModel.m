//
//  MSStonesSearchModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 30/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStonesSearchModel.h"
#import "MSTag.h"
#import "MSStone.h"

@implementation MSStonesSearchModel

@synthesize relatedStones = _relatedStones;
@synthesize relatedTags = _relatedTags;

- (id)initWithParameters:(NSDictionary *)parameters {
	self = [self initWithResource:[MSStone class] parameters:parameters];
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_relatedStones);
	TT_RELEASE_SAFELY(_relatedTags);
	
	[super dealloc];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* result = response.rootObject;

	NSArray *rawRelatedStones = [result objectForKey:@"related_stones"];
	NSArray *rawRelatedTags = [result objectForKey:@"related_tags"];

	TT_RELEASE_SAFELY(_relatedStones);
	TT_RELEASE_SAFELY(_relatedTags);
	
	NSMutableArray *relatedStones = [[NSMutableArray alloc] init];
	NSMutableArray *relatedTags = [[NSMutableArray alloc] init];
	
	for (NSDictionary* rawRelatedStone in rawRelatedStones) {
		MSStone* relatedStone = [[MSStone alloc] initWithAttributes:rawRelatedStone];
		
		[relatedStones addObject:relatedStone];
		TT_RELEASE_SAFELY(relatedStone);
	}
	
	_relatedStones = relatedStones;
	
	for (NSDictionary* rawRelatedTag in rawRelatedTags) {
		MSTag* relatedTag = [[MSTag alloc] initWithAttributes:rawRelatedTag];
		
		[relatedTags addObject:relatedTag];
		TT_RELEASE_SAFELY(relatedTag);
	}
	
	_relatedTags = relatedTags;
	
	[super requestDidFinishLoad:request];
}

@end
