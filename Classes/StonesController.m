//
//  StonesController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StonesController.h"
#import "TTTableTextItem+MSAdditions.h"

@interface StonesController (Private)

- (void)updateStonesLink;

@end

@implementation StonesController

@synthesize location = _location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Stones";
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																							   target:self
																							action:@selector(search:)] autorelease];
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		
		[_locationManager startUpdatingLocation];
		
		self.tableViewStyle = UITableViewStyleGrouped;
		
		_stonesLink = [[TTTableLink itemWithText:nil
											 URL:[NSString stringWithFormat:@"tt://stones/%@", [NSLocalizedString(@"Around Me", @"") stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
										userInfo:nil] retain];
		
		_firstTime = YES;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_locationManager);
	TT_RELEASE_SAFELY(_locationText);
	TT_RELEASE_SAFELY(_stonesLink);
	
	[super dealloc];
}

- (void)setLocation:(CLLocationCoordinate2D)location {
	_location = location;
	
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:_location];
	geocoder.delegate = [self retain];
	[geocoder start];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	self.location = newLocation.coordinate;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSMutableArray *components = [[NSMutableArray alloc] init];
	
	if(placemark.thoroughfare)
		[components addObject:placemark.thoroughfare];
	
	if(placemark.locality)
		[components addObject:placemark.locality];
	
	if(placemark.country)
		[components addObject:placemark.country];
	
	TT_RELEASE_SAFELY(_locationText);
	_locationText = [[components componentsJoinedByString:@", "] retain];
	
	if(!TTIsStringWithAnyText(_locationText)) {
		TT_RELEASE_SAFELY(_locationText);
		_locationText = [[NSString stringWithFormat:@"%f, %f", _location.latitude, _location.longitude] retain];
	}
	
	TT_RELEASE_SAFELY(components);
	
    [geocoder autorelease];
	
	[self updateStonesLink];
	
	[self release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	TT_RELEASE_SAFELY(_locationText);
	_locationText = [[NSString stringWithFormat:@"%f, %f", _location.latitude, _location.longitude] retain];

	[geocoder autorelease];
	
	[self updateStonesLink];
	
	[self release];
}

- (void)updateStonesLink {
	TTSectionedDataSource *dataSource = (TTSectionedDataSource *)self.dataSource;
	
	_stonesLink.text = _locationText;
	_stonesLink.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:
										[NSString stringWithFormat:@"%@, %@", [NSNumber numberWithDouble:_location.latitude],
										 [NSNumber numberWithDouble:_location.longitude]],
										@"origin",
										[[NSUserDefaults standardUserDefaults] valueForKey:@"kAroundRadius"], @"radius",
																	   nil], @"parameters", [NSNumber numberWithBool:YES], @"showSort", nil];

	if(_firstTime)
		[dataSource.items replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:_stonesLink]];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
						  withRowAnimation:
	 _firstTime ? UITableViewRowAnimationFade : UITableViewRowAnimationNone];
	
	_firstTime = NO;
}

- (void)search:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://stones/search"] applyAnimated:YES]];
}

- (void)createModel {
	self.dataSource = [[[TTSectionedDataSource alloc] init] autorelease];
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	TTSectionedDataSource *dataSource = (TTSectionedDataSource *)self.dataSource;
	
	dataSource.items = [NSMutableArray arrayWithObjects:
	 [NSArray arrayWithObject:[TTTableActivityItem itemWithText:NSLocalizedString(@"Retrieving current location...", @"")]],
	 [NSArray arrayWithObjects:
	  [TTTableLink itemWithText:NSLocalizedString(@"Top rated", @"")
							URL:[NSString stringWithFormat:@"tt://stones/%@", [NSLocalizedString(@"Top Rated", @"") stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
					   userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																	@"votes", @"sort", nil] forKey:@"parameters"]],
	  [TTTableLink itemWithText:NSLocalizedString(@"Most recent", @"")
							URL:[NSString stringWithFormat:@"tt://stones/%@", [NSLocalizedString(@"Most Recent", @"") stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
					   userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																	@"date", @"sort", nil] forKey:@"parameters"]],
	  [TTTableLink itemWithText:NSLocalizedString(@"Most viewed", @"")
							URL:[NSString stringWithFormat:@"tt://stones/%@", [NSLocalizedString(@"Most Viewed", @"") stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
					   userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																	@"views", @"sort", nil] forKey:@"parameters"]],
	  nil],
	 [NSArray arrayWithObjects:
	  [TTTableLink itemWithText:NSLocalizedString(@"Random stone", @"") URL:@"tt://stone/show/0"],
	  nil], nil];
	
	dataSource.sections = [NSArray arrayWithObjects:
	 NSLocalizedString(@"Around Me", @""),
	 NSLocalizedString(@"World", @""),
	 NSLocalizedString(@"Miscellaneous", @""),
	 nil];
}

@end
