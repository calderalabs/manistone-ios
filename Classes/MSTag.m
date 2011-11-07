//
//  MSTag.m
//  Manistone
//
//  Created by Eugenio Depalo on 16/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTag.h"
#import <Three20/Three20+Additions.h>

@implementation MSTag

@synthesize name = _name;
@synthesize count = _count;

+ (NSString *)collectionName {
	return @"tags";
}

+ (NSString *)tagListWithTags:(NSArray *)tags {
	NSMutableArray *tagNames = [NSMutableArray array];
	
	for(MSTag *tag in tags)
		[tagNames addObject:tag.name];
	
	return [tagNames componentsJoinedByString:@", "];
}

+ (NSString *)styledTagListWithTags:(NSArray *)tags {
	if(tags.count == 0)
		return [NSString stringWithFormat:@"<b>%@</b>", NSLocalizedString(@"No tags", @"")];
	
	NSMutableArray *tagNames = [NSMutableArray array];
	
	for(MSTag *tag in tags)
		[tagNames addObject:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [tag URLValueWithName:@"show"], tag.name]];
	
	return [tagNames componentsJoinedByString:@", "];
}

- (id)initWithName:(NSString *)name {
	self = [self initWithName:name count:nil];
	
	return self;
}

- (id)initWithName:(NSString *)name count:(NSNumber *)count {
	if(self = [self init]) {
		_name = [name retain];
		_count = [count retain];
	}
	
	return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [self init]) {
		_name = [[attributes valueForKey:@"name"] retain];
		_count = [[attributes valueForKey:@"count"] retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_name);
	TT_RELEASE_SAFELY(_count);
	
	[super dealloc];
}

@end
