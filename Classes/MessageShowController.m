//
//  MessageShowController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MessageShowController.h"
#import "MSMessageDataSource.h"
#import "MSMessage.h"
#import "MSSession.h"

@implementation MessageShowController

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
		
		self.title = NSLocalizedString(@"Message Details", @"");
	}
	
	return self;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSMessageDataSource *dataSource = (MSMessageDataSource *)self.dataSource;
	
	MSMessage *message = (MSMessage *)dataSource.remoteObjectModel.remoteObject;
	
	if(![message.user.uid isEqualToNumber:[MSSession applicationSession].user.uid]) {
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reply", @"")
																				   style:UIBarButtonItemStylePlain
																				  target:self
																					action:@selector(reply:)] autorelease] animated:YES];
	}
}



- (void)reply:(id)sender {
	MSMessageDataSource *dataSource = (MSMessageDataSource *)self.dataSource;
	
	MSMessage *message = (MSMessage *)dataSource.remoteObjectModel.remoteObject;
	
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://message/new"] applyAnimated:YES]
											applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:
														[NSArray arrayWithObject:message.user], @"recipients",
														[NSString stringWithFormat:@"Re: %@", message.subject], @"subject", nil]]];
}

- (void)createModel {
	self.dataSource = [[[MSMessageDataSource alloc] initWithUid:_uid] autorelease];
}

@end
