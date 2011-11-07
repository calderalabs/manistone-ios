//
//  MSDedication.m
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSDedication.h"

@implementation MSDedication

@synthesize stone = _stone;
@synthesize user = _user;
@synthesize unread = _unread;

+ (NSString *)collectionName {
	return @"dedications";
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_stone = [[MSStone alloc] initWithAttributes:[attributes valueForKey:@"stone"]];
		_user = [[MSUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
		_unread = [[attributes valueForKey:@"unread"] boolValue];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stone);
	TT_RELEASE_SAFELY(_user);
	
	[super dealloc];
}

@end
