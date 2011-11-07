//
//  NSDate+MSAdditions.m
//  Manistone
//
//  Created by Eugenio Depalo on 01/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "NSDate+MSAdditions.h"

@implementation NSDate (MSAdditions)

- (NSUInteger)age {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:self];
	
	if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
		(([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
		return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
	} else {
		return [dateComponentsNow year] - [dateComponentsBirth year];
	}
}

@end
