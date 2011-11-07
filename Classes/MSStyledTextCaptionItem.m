//
//  MSStyledTextCaptionItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStyledTextCaptionItem.h"

@implementation MSStyledTextCaptionItem

@synthesize caption = _caption;

+ (id)itemWithText:(TTStyledText *)text caption:(NSString *)caption {
	MSStyledTextCaptionItem *item = [[self alloc] init];
	item.text = text;
	item.caption = caption;
	
	return [item autorelease];
}

@end
