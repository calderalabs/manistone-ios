//
//  MSGeocoderDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 04/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSGeocoderDataSource.h"
#import "MSGeocoderResult.h"
#import "MSTableSelectableItemCell.h"

@implementation MSGeocoderDataSource

@synthesize delegate = _delegate;

- (id)initWithQueryString:(NSString *)query {
	if(self = [self init])
		_geocoder = [[MSGeocoder alloc] initWithQueryString:query];
	
	return self;
}

- (void)search:(NSString*)text {
    [_geocoder search:text];
}

- (id<TTModel>)model {
	return _geocoder;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	for(MSGeocoderResult *result in _geocoder.results) {
		TTTableButton *item = [TTTableButton itemWithText:result.address];
		item.userInfo = result;
		item.delegate = _delegate;
		item.selector = @selector(didSelectResult:);
		[items addObject:item];
	}
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    if ([object isKindOfClass:[TTTableButton class]]) {  
        return [MSTableSelectableItemCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (void)dealloc {
	TT_RELEASE_SAFELY(_geocoder);
	TT_RELEASE_SAFELY(_delegate);
	
	[super dealloc];
}

@end
