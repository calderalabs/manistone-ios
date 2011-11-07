//
//  MSObjectRequest.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAPIRequest.h"

typedef enum {
	MSCollectionRequestActionCreate,
	MSCollectionRequestActionList,
} MSCollectionRequestAction;

@interface MSCollectionRequest : MSAPIRequest {

}

- (id)initWithResource:(NSString *)resource
				  action:(MSCollectionRequestAction)action
			  parameters:(NSDictionary *)parameters
				delegate:(id<TTURLRequestDelegate>)delegate;

@end
