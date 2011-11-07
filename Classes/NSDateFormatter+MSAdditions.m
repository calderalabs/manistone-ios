//
//  NSDateFormatter+MSAdditions.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/06/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "NSDateFormatter+MSAdditions.h"

@implementation NSDateFormatter (MSAdditions)

static NSString *dateTimeFormatString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

+ (NSDateFormatter *)JSONDateFormatter {
	static NSDateFormatter *formatter = nil;
	
	if(!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[formatter setDateFormat:dateTimeFormatString];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	}
	
	return formatter;
}

+ (NSString *)JSONStringFromDate:(NSDate *)date {
	return [[self JSONDateFormatter] stringFromDate:date];
}

+ (NSDate *)dateFromJSONString:(NSString *)string {
	return [[self JSONDateFormatter] dateFromString:string];
}

@end
