//
//  MSLocationPicker.m
//  Manistone
//
//  Created by Eugenio Depalo on 02/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSLocationPicker.h"
#import "LocationPickerController.h"

@implementation MSLocationPicker

@synthesize delegate = _delegate;
@synthesize location = _location;

- (void)setShowsPicker:(BOOL)showsPicker {
	_pickButton.hidden = !showsPicker;
}

- (BOOL)showsPicker {
	return !_pickButton.hidden;
}

- (void)setLocation:(CLLocationCoordinate2D)location {
	[_locationManager stopUpdatingLocation];
	
	_location = location;
	
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:_location];
	geocoder.delegate = self;
	[geocoder start];
	
	if([_delegate respondsToSelector:@selector(locationPicker:didSelectLocation:)])
		[_delegate locationPicker:self didSelectLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	self.location = newLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	_locationActivity.hidden = YES;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	_locationActivity.hidden = YES;
	
	NSMutableArray *components = [[NSMutableArray alloc] init];
	
	if(placemark.thoroughfare)
		[components addObject:placemark.thoroughfare];
	
	if(placemark.subThoroughfare)
		[components addObject:placemark.subThoroughfare];
	
	if(placemark.locality)
		[components addObject:placemark.locality];
	
	if(placemark.country)
		[components addObject:placemark.country];
	
	_locationLabel.text = [components componentsJoinedByString:@", "];
	
	if(!TTIsStringWithAnyText(_locationLabel.text))
		_locationLabel.text = [NSString stringWithFormat:@"%f, %f", _location.latitude, _location.longitude];
	
	TT_RELEASE_SAFELY(components);
	
	[_locationLabel sizeToFit];
	
	TT_RELEASE_SAFELY(geocoder);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	_locationActivity.hidden = YES;
	_locationLabel.text = [NSString stringWithFormat:@"%f, %f", _location.latitude, _location.longitude];
	[_locationLabel sizeToFit];
	
	TT_RELEASE_SAFELY(geocoder);
}

- (id)initWithParentController:(TTViewController *)controller startWithUserLocation:(BOOL)locate {
	if(self = [self initWithFrame:CGRectZero]) {
		_controller = [controller retain];
		
		if(locate) {
			_locationManager = [[CLLocationManager alloc] init];
			_locationManager.delegate = self;
			
			[_locationManager startUpdatingLocation];
		}
		
		_locationActivity = [[TTActivityLabel alloc] initWithFrame:CGRectZero
															 style:TTActivityLabelStyleGray
															  text:locate ? NSLocalizedString(@"Retrieving current location...", @"") : NSLocalizedString(@"Retrieving location address...", @"")];
		_locationActivity.font = [UIFont systemFontOfSize:11];
		
		[self addSubview:_locationActivity];
		
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.text = NSLocalizedString(@"Location:", @"");
		_titleLabel.font = TTSTYLEVAR(messageFont);
		_titleLabel.textColor = TTSTYLEVAR(messageFieldTextColor);
		[_titleLabel sizeToFit];
		
		[self addSubview:_titleLabel];
		
		_pickButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
		[_pickButton addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_pickButton];
		
		_locationLabel = [[UILabel alloc] init];
		[self addSubview:_locationLabel];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_delegate);
	TT_RELEASE_SAFELY(_locationManager);
	TT_RELEASE_SAFELY(_locationActivity);
	TT_RELEASE_SAFELY(_controller);
	TT_RELEASE_SAFELY(_titleLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_pickButton);
	
	[super dealloc];
}

- (void)pick:(id)sender {
	LocationPickerController *pickerController = [[LocationPickerController alloc] initWithLocation:_location];
	pickerController.delegate = self;
	[_controller.navigationController pushViewController:pickerController animated:YES];
	TT_RELEASE_SAFELY(pickerController);
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake(size.width, 45);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_titleLabel.frame = CGRectMake(8, floor((self.height - _titleLabel.height) / 2), _titleLabel.width, _titleLabel.height);
	
	_locationActivity.frame = CGRectMake(_titleLabel.width + 5,
										 (self.height - _locationActivity.height) / 2,
										 [_locationActivity.text sizeWithFont:_locationActivity.font].width + 40,
										 _locationActivity.height);
	
	_pickButton.frame = CGRectMake(self.width - _pickButton.width - 5,
								   floor((self.height - _pickButton.height) / 2),
								   _pickButton.width,
								   _pickButton.height);
	
	_locationLabel.frame = CGRectMake(_locationActivity.left + 10,
									  floor((self.height - _locationLabel.height) / 2),
									  self.width - _locationActivity.left - 10 - _pickButton.width - 10,
									  _locationLabel.height);
}

- (void)locationPickerController:(LocationPickerController *)controller didSelectLocation:(CLLocationCoordinate2D)location {
	self.location = location;
}

@end
