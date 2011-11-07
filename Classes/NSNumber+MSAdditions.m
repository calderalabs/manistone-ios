//
//  NSNumber+MSAdditions.m
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "NSNumber+MSAdditions.h"

@implementation NSNumber (MSAdditions)

- (NSString *)shortStringValue {
	NSUInteger value = [self unsignedIntegerValue];
	NSUInteger approxValue = value;
	NSString *measure = @"";
	
	if(value >= 1000000000) {
		approxValue = value / 1000000000;
		measure = @"b";
	}
	else if(value >= 1000000) {
		approxValue = value / 1000000;
		measure = @"m";
	}
	else if(value >= 1000) {
		approxValue = value / 1000;
		measure = @"k";
	}
	
	return [NSString stringWithFormat:@"%d%@", approxValue, measure];
}

@end
