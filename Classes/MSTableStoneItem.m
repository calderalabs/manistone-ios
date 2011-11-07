//
//  MSTableStoneItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStoneItem.h"

@implementation MSTableStoneItem

@synthesize stone = _stone;

@synthesize markUnread = _markUnread;

+ (id)itemWithStone:(MSStone *)stone {
	MSTableStoneItem *item = [[self alloc] init];
	item.stone = stone;
	item.URL = [stone URLValueWithName:@"show"];
	
	return [item autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	
	[super dealloc];
}

@end
