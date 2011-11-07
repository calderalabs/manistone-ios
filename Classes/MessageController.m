//
//  MessageController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MessageController.h"
#import "MSDedicationDataSource.h"
#import "MSCollectionRequest.h"
#import "MSMessage.h"
#import "MSUser.h"

@implementation MessageController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	NSMutableArray *recipients = [[NSMutableArray alloc] init];
	
	for(MSUser *recipient in [query valueForKey:@"recipients"]) {
		TTTableTextItem *item = [TTTableTextItem itemWithText:recipient.fullName];
		item.userInfo = recipient;
		[recipients addObject:item];
	}
	
	if(self = [self initWithRecipients:recipients]) {
		self.title = NSLocalizedString(@"Send Message", @"");
		
		if([query valueForKey:@"subject"])
			self.subject = [query valueForKey:@"subject"];
		
		self.dataSource = [[[MSDedicationDataSource alloc] initWithParameters:nil] autorelease];
		self.delegate = self;
	}
	
	TT_RELEASE_SAFELY(recipients);
	
	return self;
}


- (void)composeController:(TTMessageController *)controller didSendFields:(NSArray *)fields {
	MSMessage *message = [[MSMessage alloc] init];
	message.text = controller.body;
	message.subject = controller.subject;
	
	TTMessageRecipientField *field = (TTMessageRecipientField *)[controller.fields objectAtIndex:0];
	
	for(TTTableTextItem *item in field.recipients)
		[message.recipients addObject:item.userInfo];
	
	MSCollectionRequest *request = [[MSCollectionRequest alloc] initWithResource:@"messages"
																		  action:MSCollectionRequestActionCreate
																	  parameters:[NSDictionary dictionaryWithObject:[message attributes] forKey:@"message"]
																		delegate:self];
	
	[request send];
	
	TT_RELEASE_SAFELY(message);
	TT_RELEASE_SAFELY(request);
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to send message", @"")
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
		
		[self showActivityView:NO];
	}
}

@end
