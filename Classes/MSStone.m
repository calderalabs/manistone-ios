//
//  MSStone.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"

@implementation MSStone

+ (NSString *)collectionName {
	return @"stones";
}

@synthesize user = _user;

@synthesize tags = _tags;

@synthesize engraving = _engraving;
@synthesize location = _location;

@synthesize likesCount = _likesCount;
@synthesize dislikesCount = _dislikesCount;
@synthesize viewsCount = _viewsCount;
@synthesize commentsCount = _commentsCount;
@synthesize stacksCount = _stacksCount;

@synthesize favorited = _favorited;
@synthesize liked = _liked;
@synthesize disliked = _disliked;
@synthesize viewed = _viewed;
@synthesize flagged = _flagged;
@synthesize unread = _unread;

-(id)copyWithZone:(NSZone*)zone {
	MSStone *newStone = [super copyWithZone:zone];
	
	newStone.user = _user;
	newStone.tags = _tags;
	newStone.engraving = _engraving;
	newStone.location = _location;
	newStone.likesCount = _likesCount;
	newStone.dislikesCount = _dislikesCount;
	newStone.viewsCount = _viewsCount;
	newStone.commentsCount = _commentsCount;
	newStone.stacksCount = _stacksCount;
	newStone.favorited = _favorited;
	newStone.liked = _liked;
	newStone.disliked = _disliked;
	newStone.viewed = _viewed;
	newStone.flagged = _flagged;
	newStone.unread = _unread;
	
	return newStone;
}

- (CLLocationCoordinate2D)coordinate {
	return _location;
}

- (NSString *)title {
	return _engraving;
}

- (id)init {
	if(self = [super init]) {
		_tags = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_user = [[MSUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
		
		for(NSDictionary *rawTag in [attributes valueForKey:@"tags"])
			[_tags addObject:[[[MSTag alloc] initWithName:[rawTag valueForKey:@"name"]] autorelease]];
		
		_engraving = [[attributes valueForKey:@"engraving"] retain];
		_location = CLLocationCoordinate2DMake([[attributes valueForKey:@"latitude"] doubleValue],
											   [[attributes valueForKey:@"longitude"] doubleValue]);
		
		_likesCount = [[attributes valueForKey:@"likes_count"] retain];
		_dislikesCount = [[attributes valueForKey:@"dislikes_count"] retain];
		_viewsCount = [[attributes valueForKey:@"views_count"] retain];
		_commentsCount = [[attributes valueForKey:@"comments_count"] retain];
		_stacksCount = [[attributes valueForKey:@"stacks_count"] retain];
		
		_favorited = [[attributes valueForKey:@"favorited"] boolValue];
		_liked = [[attributes valueForKey:@"liked"] boolValue];
		_disliked = [[attributes valueForKey:@"disliked"] boolValue];
		_viewed = [[attributes valueForKey:@"viewed"] boolValue];
		_flagged = [[attributes valueForKey:@"flagged"] boolValue];
		_unread = [[attributes valueForKey:@"unread"] boolValue];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [self init]) {
		_engraving = [[aDecoder decodeObjectForKey:@"engraving"] retain];
		
		CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
		CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
		_location = CLLocationCoordinate2DMake(latitude, longitude);
		
		_createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_engraving forKey:@"engraving"];
	[aCoder encodeDouble:_location.latitude forKey:@"latitude"];
	[aCoder encodeDouble:_location.longitude forKey:@"longitude"];
	[aCoder encodeObject:_createdAt forKey:@"createdAt"];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_engraving);
	
	TT_RELEASE_SAFELY(_likesCount);
	TT_RELEASE_SAFELY(_dislikesCount);
	TT_RELEASE_SAFELY(_viewsCount);
	TT_RELEASE_SAFELY(_commentsCount);
	TT_RELEASE_SAFELY(_stacksCount);
	
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_tags);
	
	[super dealloc];
}

- (NSDictionary *)attributes {
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

	[attributes setValue:[MSTag tagListWithTags:_tags] forKey:@"tag_list"];			
	[attributes setValue:_engraving forKey:@"engraving"];	
	[attributes setValue:[NSNumber numberWithDouble:_location.latitude] forKey:@"latitude"];	
	[attributes setValue:[NSNumber numberWithDouble:_location.longitude] forKey:@"longitude"];	
	
	[attributes addEntriesFromDictionary:[super attributes]];
	
	return [NSDictionary dictionaryWithDictionary:attributes];
}

@end
