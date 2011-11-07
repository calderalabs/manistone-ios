//
//  StonesSearchController.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StonesSearchController.h"
#import "MSStonesSearchDataSource.h"
#import "AreaPickerController.h"

@implementation StonesSearchController

enum {
	kDateOrder = 0,
	kVotesOrder,
	kViewsOrder
};

enum {
	kEngravingScope = 0,
	kTagsScope
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		
		self.title = NSLocalizedString(@"Search Stones", @"");
		self.variableHeightRows = YES;
		self.autoresizesForKeyboard = YES;
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								target:self
																								action:@selector(done:)] autorelease];
		
		_area = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, 0), MKCoordinateSpanMake(90, 180));
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_mapView);
	TT_RELEASE_SAFELY(_searchField);
	TT_RELEASE_SAFELY(_sortControl);
	TT_RELEASE_SAFELY(_scopeControl);
	
	[super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[TTNavigator navigator].URLMap from:@"tt://stones/search/area" toViewController:self selector:@selector(pickArea)];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[TTNavigator navigator].URLMap removeURL:@"tt://stones/search/area"];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)done:(id)sender {
	[_searchField resignFirstResponder];
	
	CLLocationCoordinate2D southWest = [_mapView convertPoint:CGPointMake(0, _mapView.height) toCoordinateFromView:_mapView];
	CLLocationCoordinate2D northEast = [_mapView convertPoint:CGPointMake(_mapView.width, 0) toCoordinateFromView:_mapView];
	
	NSString *sort = nil;
	NSString *scope = nil;
	
	switch (_sortControl.selectedSegmentIndex) {
		case kDateOrder:
			sort = @"date";
			break;
			
		case kVotesOrder:
			sort = @"likes";
			break;
			
		case kViewsOrder:
			sort = @"views";
			break;
	}
	
	switch (_scopeControl.selectedSegmentIndex) {
		case kEngravingScope:
			scope = @"engraving";
			break;
		case kTagsScope:
			scope = @"tags";
			break;
	}
	
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:[NSString stringWithFormat:
																			 @"tt://stones/%@", TTIsStringWithAnyText(_searchField.text) ?
																			 [_searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] :
																			 NSLocalizedString([@"Search Results" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"")]] applyAnimated:YES]
											applyQuery:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
														[NSString stringWithFormat:@"%f,%f,%f,%f", southWest.latitude,
																	  southWest.longitude,
																	  northEast.latitude,
																	  northEast.longitude], @"bounds",
														_searchField.text, @"q",
														sort, @"sort",
														scope, @"scope",
														nil] forKey:@"parameters"]]];
	
}

- (void)createModel {
	_searchField = [[UITextField alloc] init];
	_searchField.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	_searchField.delegate = self;
	
	UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)] autorelease];
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 5, TTApplicationFrame().size.width - 5 * 2 - 20, 190)];
	_mapView.scrollEnabled = NO;
	_mapView.zoomEnabled = NO;
	
	_mapView.region = _area;
	
	_mapView.layer.cornerRadius = 5;
	
	[containerView addSubview:_mapView];
	
	UIView *scopeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
	_scopeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Engraving", @""), NSLocalizedString(@"Tags", @""), nil]];
	[_scopeControl addTarget:self action:@selector(scopeChanged:) forControlEvents:UIControlEventValueChanged];
	_scopeControl.selectedSegmentIndex = 0;
	_scopeControl.frame = CGRectMake(0, 0,  TTApplicationFrame().size.width - 20, 44);
	[scopeContainerView addSubview:_scopeControl];
	
	UIView *sortContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
	_sortControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Date", @""), NSLocalizedString(@"Votes", @""), NSLocalizedString(@"Views", @""), nil]];
	_sortControl.frame = CGRectMake(0, 0,  TTApplicationFrame().size.width - 20, 44);
	[sortContainerView addSubview:_sortControl];
	_sortControl.selectedSegmentIndex = 0;
	
	TTTableLink *selectAreaItem = [TTTableLink itemWithText:NSLocalizedString(@"Select an area", @"") URL:@"tt://stones/search/area"];
	
	self.dataSource = [MSStonesSearchDataSource dataSourceWithObjects:
						@"",
						_searchField,
						@"",
						scopeContainerView,
					   NSLocalizedString(@"Location", @""),
					  selectAreaItem,
					   [TTTableViewItem itemWithCaption:nil view:containerView],
					   NSLocalizedString(@"Order", @""),
					   sortContainerView,
						nil];
	
	TT_RELEASE_SAFELY(scopeContainerView);
	TT_RELEASE_SAFELY(sortContainerView);
}

- (void)scopeChanged:(id)sender {
	switch (_scopeControl.selectedSegmentIndex) {
		case kEngravingScope:
			_searchField.placeholder = NSLocalizedString(@"Keywords", @"");
			break;
		case kTagsScope:
			_searchField.placeholder = NSLocalizedString(@"comma, separated, list", @"");
			break;
	}
}

- (void)pickArea {
	AreaPickerController *pickerController = [[AreaPickerController alloc] initWithArea:_area];

	pickerController.delegate = self;
	[self.navigationController pushViewController:pickerController animated:YES];
	TT_RELEASE_SAFELY(pickerController);
}

- (void)areaPickerController:(AreaPickerController *)controller didSelectArea:(MKCoordinateRegion)area {
	_area = area;
	_mapView.region = [_mapView regionThatFits:_area];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return YES;
}

@end
