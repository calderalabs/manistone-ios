//
//  MSGeocoderDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 04/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSGeocoder.h"

@interface MSGeocoderDataSource : TTListDataSource {
	MSGeocoder *_geocoder;
	id _delegate;
}

@property (nonatomic, retain) id delegate;

- (id)initWithQueryString:(NSString *)query;

@end
