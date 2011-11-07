//
//  MSTableStackItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStackItem.h"

@implementation MSTableStackItem

@synthesize stack = _stack;

+ (id)itemWithStack:(MSStack *)stack {
	MSTableStackItem *item = [[self alloc] init];
	item.stack = stack;
	item.URL = [stack URLValueWithName:@"show"];
	
	return [item autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stack);
	
	[super dealloc];
}

@end
