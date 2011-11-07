//
//  MSTableLocalStoneItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 12/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableLocalStoneItem.h"

@implementation MSTableLocalStoneItem

@synthesize stone = _stone;

+ (id)itemWithStone:(MSStone *)stone {
	MSTableLocalStoneItem *item = [[self alloc] init];
	item.stone = stone;
	item.userInfo = [NSDictionary dictionaryWithObject:stone forKey:@"stone"];
	
	return [item autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	
	[super dealloc];
}

@end
