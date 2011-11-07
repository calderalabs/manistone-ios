//
//  MSTableCommentItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 13/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableCommentItem.h"

@implementation MSTableCommentItem

@synthesize comment = _comment;

+ (id)itemWithComment:(MSComment *)comment {
	MSTableCommentItem *item = [[self alloc] init];
	
	item.comment = comment;
	item.text = comment.text;
	item.URL = [comment.resource URLValueWithName:@"show"];
	
	return [item autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_comment);
	
	[super dealloc];
}

@end
