//
//  MSGeocoderResult.m
//  Manistone
//
//  Created by Eugenio Depalo on 18/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSGeocoderResult.h"

@implementation MSGeocoderResult

@synthesize address = _address;
@synthesize northEast = _northEast;
@synthesize southWest = _southWest;

- (void)dealloc {
	TT_RELEASE_SAFELY(_address);

	[super dealloc];
}

@end
