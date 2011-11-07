//
//  NSDateFormatter+MSAdditions.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/06/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface NSDateFormatter (MSAdditions)

+ (NSDateFormatter *)JSONDateFormatter;
+ (NSString *)JSONStringFromDate:(NSDate *)date;
+ (NSDate *)dateFromJSONString:(NSString *)string;

@end
