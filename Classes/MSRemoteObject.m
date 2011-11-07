//
//  MSRemoteObject.m
//  Manistone
//
//  Created by Eugenio Depalo on 13/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "NSDateFormatter+MSAdditions.h"
#import <objc/runtime.h>

@implementation MSRemoteObject

@synthesize uid = _uid;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;

-(id)copyWithZone:(NSZone*)zone {
	MSRemoteObject *newObject = [[[self class] allocWithZone:zone] init];
	
	newObject.uid = _uid;
	newObject.createdAt = _createdAt;
	newObject.updatedAt = _updatedAt;
	
	return newObject;
}

+ (NSString *)collectionName {
	return nil;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if (self = [self init]) {
		_uid = [[attributes valueForKey:@"id"] retain];
		
		_createdAt = [[NSDateFormatter dateFromJSONString:[attributes valueForKey:@"created_at"]] retain];
		_updatedAt = [[NSDateFormatter dateFromJSONString:[attributes valueForKey:@"updated_at"]] retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_uid);
	TT_RELEASE_SAFELY(_createdAt);
	TT_RELEASE_SAFELY(_updatedAt);
	
	[super dealloc];
}

- (NSDictionary *)attributes {
	return [NSDictionary dictionary];
}

@end
