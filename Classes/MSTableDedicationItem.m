//
//  MSTableDedicationItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableDedicationItem.h"

@implementation MSTableDedicationItem

@synthesize dedication = _dedication;

+ (id)itemWithDedication:(MSDedication *)dedication {
	MSTableDedicationItem *item = [[self alloc] init];
	
	item.dedication = dedication;
	item.text = dedication.stone.engraving;
	item.URL = [dedication.stone URLValueWithName:@"show"];
	
	return [item autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_dedication);
	
	[super dealloc];
}

@end
