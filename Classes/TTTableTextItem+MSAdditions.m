//
//  TTTableTextItem+MSAdditions.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "TTTableTextItem+MSAdditions.h"

@implementation TTTableTextItem (MSAdditions)

+ (id)itemWithText:(NSString*)text URL:(NSString*)URL userInfo:(id)userInfo {
	TTTableTextItem* item = [[[self alloc] init] autorelease];
	item.userInfo = userInfo;
	item.text = text;
	item.URL = URL;
	return item;
}

@end
