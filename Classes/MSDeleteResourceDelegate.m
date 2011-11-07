//[TTNavigator navigator].visibleViewController.navigationItem
//  MSDeleteResourceDelegate.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSDeleteResourceDelegate.h"

@implementation MSDeleteResourceDelegate

- (id)initWithController:(TTViewController *)controller text:(NSString *)text {
	if(self = [self init]) {
		[self retain];
		
		_controller = [controller retain];
		_text = [text retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_controller);
	TT_RELEASE_SAFELY(_text);
	
	[super dealloc];
}

- (void)requestDidStartLoad:(TTURLRequest *)request {
	[_controller startActivity:_text];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[_controller.navigationController popViewControllerAnimated:YES];
	
	[self release];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	[_controller stopActivity];
	
	[self release];
}

@end
