//
//  MSGeocoder.h
//  Manistone
//
//  Created by Eugenio Depalo on 18/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSGeocoder : TTURLRequestModel {
	NSString *_query;
	NSArray *_results;
}

@property (nonatomic, retain) NSArray *results;

- (id)initWithQueryString:(NSString *)query;
- (void)search:(NSString *)text;

@end

