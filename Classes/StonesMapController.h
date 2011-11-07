//
//  StonesMapController.h
//  Manistone
//
//  Created by Eugenio Depalo on 13/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface StonesMapController : TTViewController <MKMapViewDelegate> {
	MKMapView *_mapView;
	NSArray *_stones;
}

- (NSArray *)createStonesWithQuery:(NSDictionary *)query;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;

@end
