//
//  MSLocalStonesManager.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSLocalStonesManager.h"

@implementation MSLocalStonesManager

@synthesize stones = _stones;

+ (NSString *)archivePath {
	static NSString *kArchivePath = nil;
	
	if(!kArchivePath) {
		NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		kArchivePath = [[documentsPath stringByAppendingPathComponent:@"LocalStones"] retain];
	}
	
	return kArchivePath;
}

+ (MSLocalStonesManager *)defaultManager {
	static MSLocalStonesManager *manager = nil;
	
	if(manager == nil) {
		manager = [[super allocWithZone:NULL] init];
	}
	
	return manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self defaultManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
	
}

- (id)autorelease
{
    return self;
}

- (id)init {
	if(self = [super init]) {
		_stones = [[NSMutableArray alloc] init];
		
		[self read];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_stones);
	
	[super dealloc];
}

- (BOOL)save {
	return [NSKeyedArchiver archiveRootObject:_stones toFile:[MSLocalStonesManager archivePath]];
}

- (void)read {
	NSMutableArray *stones = [NSKeyedUnarchiver unarchiveObjectWithFile:[MSLocalStonesManager archivePath]];
	
	if(stones) {
		TT_RELEASE_SAFELY(_stones);
		_stones = [stones retain];
	}
}

@end
