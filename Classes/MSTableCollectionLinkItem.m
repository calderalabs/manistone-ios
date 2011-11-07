//
//  MSTableCollectionLinkItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 03/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableCollectionLinkItem.h"

@implementation MSTableCollectionLinkItem

@synthesize imageURL = _imageURL;
@synthesize count = _count;

+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count userInfo:(NSDictionary *)userInfo {
	MSTableCollectionLinkItem *item = [[[self alloc] init] autorelease];
	
	item.text = text;
	item.imageURL = imageURL;
	item.count = count;
	item.userInfo = userInfo;
	
	return item;
}

+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count URL:(NSString *)URL userInfo:(NSDictionary *)userInfo {
	MSTableCollectionLinkItem *item = [[[self alloc] init] autorelease];
	
	item.text = text;
	item.imageURL = imageURL;
	item.count = count;
	item.URL = URL;
	item.userInfo = userInfo;
	
	return item;
}

+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL userInfo:(NSDictionary *)userInfo {
	MSTableCollectionLinkItem *item = [[[self alloc] init] autorelease];
	
	item.text = text;
	item.imageURL = imageURL;
	item.count = count;
	item.URL = URL;
	item.accessoryURL = accessoryURL;
	item.userInfo = userInfo;
	
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageURL);
	
	[super dealloc];
}

@end
