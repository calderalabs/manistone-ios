//
//  MSAPIRequest.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSAPIRequest : TTURLRequest <TTURLRequestDelegate, UIAlertViewDelegate> {
	NSString *_controller;
	NSString *_action;
}

- (id)initWithController:(NSString *)controller
				  action:(NSString *)action
				  method:(NSString *)method
			  parameters:(NSDictionary *)parameters
				delegate:(id<TTURLRequestDelegate>)delegate;

@property (nonatomic, retain) NSString *controller;
@property (nonatomic, retain) NSString *action;

+ (NSString *)serverRoot;

@end
