//
//  MSLocationAnnotation.h
//  Manistone
//
//  Created by Eugenio Depalo on 04/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSLocationAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
