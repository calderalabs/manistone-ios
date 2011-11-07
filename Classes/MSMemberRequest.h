//
//  MSMemberRequest.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAPIRequest.h"

typedef enum {
	MSMemberRequestActionRead,
	MSMemberRequestActionUpdate,
	MSMemberRequestActionDelete,
} MSMemberRequestAction;

@interface MSMemberRequest : MSAPIRequest {

}

- (id)initWithResource:(NSString *)resource
				  member:(NSString *)member
				  action:(MSMemberRequestAction)action
			  parameters:(NSDictionary *)parameters
				delegate:(id<TTURLRequestDelegate>)delegate;

@end
