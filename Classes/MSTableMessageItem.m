//
//  MSTableMessageItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableMessageItem.h"

@implementation MSTableMessageItem

@synthesize message = _message;

+ (id)itemWithMessage:(MSMessage *)message {
	MSTableMessageItem *item = [self itemWithTitle:message.subject
										   caption:message.user.fullName
											  text:message.text
										 timestamp:message.createdAt
											   URL:[message URLValueWithName:@"show"]];

	item.userInfo = message;
	item.message = message;
	
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_message);
	
	[super dealloc];
}

@end
