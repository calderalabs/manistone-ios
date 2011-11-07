//
//  MSAddToStackDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 24/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStackListDataSource.h"

@interface MSAddToStackDataSource : MSStackListDataSource {
	NSUInteger _uid;
	id<TTURLRequestDelegate> _delegate;
}

@property (nonatomic, retain) id<TTURLRequestDelegate> delegate;

@end
