//
//  MSComment.m
//  Manistone
//
//  Created by Eugenio Depalo on 28/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSComment.h"
#import "MSStone.h"
#import "MSStack.h"

@implementation MSComment

@synthesize resource = _resource;
@synthesize resourceType = _resourceType;
@synthesize user = _user;
@synthesize text = _text;

+ (NSString *)collectionName {
	return @"comments";
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_user = [[MSUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
		_text = [[attributes valueForKey:@"text"] retain];
		_resourceType = [[attributes valueForKey:@"resource_type"] retain];
		
		if([_resourceType isEqualToString:@"Stone"]) {
			_resource = [[MSStone alloc] initWithAttributes:[attributes valueForKey:@"resource"]];
		}
		else if([_resourceType isEqualToString:@"Stack"]) {
			_resource = [[MSStack alloc] initWithAttributes:[attributes valueForKey:@"resource"]];
		}
	}
	
	return self;
}

- (NSDictionary *)attributes {
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	[attributes setValue:_text forKey:@"text"];			

	[attributes addEntriesFromDictionary:[super attributes]];
	
	return [NSDictionary dictionaryWithDictionary:attributes];
}


- (void)dealloc {
	TT_RELEASE_SAFELY(_resource);
	TT_RELEASE_SAFELY(_resourceType);
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_text);
	
	[super dealloc];
}

@end
