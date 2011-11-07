//
//  StonesController.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface StonesController : TTTableViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
	CLLocationManager *_locationManager;
	CLLocationCoordinate2D _location;
	NSString *_locationText;
	TTTableLink *_stonesLink;
	BOOL _firstTime;
}

@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
