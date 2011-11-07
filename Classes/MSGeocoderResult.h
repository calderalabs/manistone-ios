//
//  MSGeocoderResult.h
//  Manistone
//
//  Created by Eugenio Depalo on 18/05/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSGeocoderResult : NSObject {
	NSString *_address;
	CLLocationCoordinate2D _northEast;
	CLLocationCoordinate2D _southWest;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D northEast;
@property (nonatomic, assign) CLLocationCoordinate2D southWest;

@end
