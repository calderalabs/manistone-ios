//
//  MSDedicateDelegate.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSDedicateDelegate.h"
#import "MSAPIRequest.h"
#import "MSTableAuthorItem.h"
#import "DedicateController.h"

@implementation MSDedicateDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	DedicateController *dedicateController = (DedicateController *)self.controller;
	id<TTTableViewDataSource> dataSource = (id<TTTableViewDataSource>)tableView.dataSource;
	MSTableAuthorItem *item = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
	
	[self.controller startActivity:NSLocalizedString(@"Sending stone...", @"")];
	
	MSAPIRequest *request = [[[MSAPIRequest alloc] initWithController:@"dedications"
									  action:nil
									  method:@"POST"
								  parameters:[NSDictionary dictionaryWithObject:
											  [NSDictionary dictionaryWithObjectsAndKeys:
											   item.author.uid, @"dedicated_user_id",
											   [NSNumber numberWithUnsignedInteger:dedicateController.uid], @"stone_id", nil] forKey:@"dedication"] delegate:self] autorelease];
	
	[request send];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self.controller stopActivity];

	[self.controller dismissModalViewControllerAnimated:YES];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	[self.controller stopActivity];
	
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to send dedication", @"")
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
}

@end
