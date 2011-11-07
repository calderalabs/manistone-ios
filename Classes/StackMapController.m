//
//  StackMapController.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StackMapController.h"
#import "MSStack.h"
#import "MSCircleView.h"

@implementation StackMapController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [super initWithNavigatorURL:URL query:query]) {
		self.title = NSLocalizedString(@"Stack Map", @"");
		
		UISegmentedControl *navigationControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																						 TTIMAGE(@"bundle://Three20.bundle/images/previousIcon.png"),
																						 TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png"), nil]] autorelease];
		
		navigationControl.momentary = YES;
		
		[navigationControl addTarget:self action:@selector(navigationChanged:) forControlEvents:UIControlEventValueChanged];
		
		navigationControl.segmentedControlStyle = UISegmentedControlStyleBar;
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navigationControl] autorelease];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * _stones.count);
	
	MSStone *firstStone = [_stones objectAtIndex:0];
	
	[_mapView selectAnnotation:firstStone animated:YES];
	
	CLLocationCoordinate2D center;
	center.latitude = firstStone.coordinate.latitude;
	center.longitude = firstStone.coordinate.longitude;
	
	[_mapView addOverlay:[MKCircle circleWithCenterCoordinate:center radius:8]];
	
	for(int i = 0; i < _stones.count; i++) {
		MSStone *stone = [_stones objectAtIndex:i];
		
		coordinates[i].latitude = stone.coordinate.latitude;
		coordinates[i].longitude = stone.coordinate.longitude;
	}
	
	[_mapView addOverlay:[MKPolyline polylineWithCoordinates:coordinates count:_stones.count]];
	
	free(coordinates);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];   
		
		polylineView.strokeColor = [UIColor redColor];     
		polylineView.lineWidth = 3.0;
		polylineView.lineJoin = kCGLineJoinRound;
		
		return polylineView;  
	}
	else if([overlay isKindOfClass:[MKCircle class]]) {
		MSCircleView *circleView = [[[MSCircleView alloc] initWithOverlay:overlay] autorelease];   
		
		circleView.strokeColor = [UIColor redColor];     
		circleView.lineWidth = 5.0;
		circleView.lineJoin = kCGLineJoinRound;
		
		return circleView;  
	}
	
	return nil;
}

- (NSArray *)createStonesWithQuery:(NSDictionary *)query {
	MSStack *stack = [query valueForKey:@"stack"];
	
	return stack.stones;
}

- (void)navigationChanged:(id)sender {
	UISegmentedControl *control = (UISegmentedControl *)sender;
	
	NSInteger selectedStoneIndex = [_stones indexOfObject:[[_mapView selectedAnnotations] objectAtIndex:0]];
	
	if(control.selectedSegmentIndex == 0) // Back
		[_mapView selectAnnotation:((selectedStoneIndex == NSNotFound || selectedStoneIndex == 0) ?
									[_stones lastObject] :
									[_stones objectAtIndex:selectedStoneIndex - 1]) animated:YES];
	else // Forward
		[_mapView selectAnnotation:((selectedStoneIndex == NSNotFound || selectedStoneIndex == (_stones.count - 1)) ?
									[_stones objectAtIndex:0] :
									[_stones objectAtIndex:selectedStoneIndex + 1]) animated:YES];
}

@end
