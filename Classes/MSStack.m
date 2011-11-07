//
//  MSStack.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStack.h"

@implementation MSStack

+ (NSString *)collectionName {
	return @"stacks";
}

@synthesize user = _user;
@synthesize name = _name;
@synthesize stones = _stones;
@synthesize stonesCount = _stonesCount;
@synthesize likesCount = _likesCount;
@synthesize dislikesCount = _dislikesCount;
@synthesize commentsCount = _commentsCount;
@synthesize viewsCount = _viewsCount;
@synthesize favorited = _favorited;
@synthesize liked = _liked;
@synthesize disliked = _disliked;
@synthesize viewed = _viewed;

-(id)copyWithZone:(NSZone*)zone {
	MSStack *newStack = [super copyWithZone:zone];
	
	newStack.user = _user;
	newStack.stones = _stones;
	newStack.stonesCount = _stonesCount;
	newStack.likesCount = _likesCount;
	newStack.dislikesCount = _dislikesCount;
	newStack.commentsCount = _commentsCount;
	newStack.viewsCount = _viewsCount;
	
	newStack.favorited = _favorited;
	newStack.liked = _liked;
	newStack.disliked = _disliked;
	newStack.viewed = _viewed;
	
	newStack.name = _name;
	
	return newStack;
}

- (id)init {
	if(self = [super init]) {
		_stones = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_user = [[MSUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
		
		_name = [[attributes valueForKey:@"name"] retain];
		_stonesCount = [[attributes valueForKey:@"stones_count"] retain];
		
		_likesCount = [[attributes valueForKey:@"likes_count"] retain];
		_dislikesCount = [[attributes valueForKey:@"dislikes_count"] retain];
		_viewsCount = [[attributes valueForKey:@"views_count"] retain];
		_commentsCount = [[attributes valueForKey:@"comments_count"] retain];
		
		_favorited = [[attributes valueForKey:@"favorited"] boolValue];
		_liked = [[attributes valueForKey:@"liked"] boolValue];
		_disliked = [[attributes valueForKey:@"disliked"] boolValue];
		_viewed = [[attributes valueForKey:@"viewed"] boolValue];
		
		for(NSDictionary *rawStone in [attributes valueForKey:@"stones"]) {
			MSStone *stone = [[MSStone alloc] initWithAttributes:rawStone];
			[_stones addObject:stone];
			TT_RELEASE_SAFELY(stone);
		}
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stones);
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_stonesCount);
	TT_RELEASE_SAFELY(_likesCount);
	TT_RELEASE_SAFELY(_dislikesCount);
	TT_RELEASE_SAFELY(_viewsCount);
	TT_RELEASE_SAFELY(_commentsCount);
	TT_RELEASE_SAFELY(_name);
	
	[super dealloc];
}

- (NSDictionary *)attributes {
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	[attributes setValue:_name forKey:@"name"];	
	
	[attributes addEntriesFromDictionary:[super attributes]];
	
	return [NSDictionary dictionaryWithDictionary:attributes];
}

@end
