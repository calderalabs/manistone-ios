//
//  MSTableSubItemsItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableSubItemsItem.h"

@implementation MSTableSubItemsItem

@synthesize subItems = _subItems;
@synthesize shown = _shown;
@synthesize imageURL = _imageURL;

+ (id)itemWithText:(NSString*)text subItems:(NSArray *)subItems {
	MSTableSubItemsItem* item = [[[self alloc] init] autorelease];
	item.text = text;
	item.subItems = subItems;
	return item;
}

+ (id)itemWithText:(NSString*)text subItems:(NSArray *)subItems imageURL:(NSString *)imageURL {
	MSTableSubItemsItem* item = [[[self alloc] init] autorelease];
	item.text = text;
	item.subItems = subItems;
	item.imageURL = imageURL;
	
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_subItems);
	TT_RELEASE_SAFELY(_imageURL);
	
	[super dealloc];
}
					
@end
