//
//  MSRemoteObjectModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSResourceModel.h"

@interface MSRemoteObjectModel : MSResourceModel {
	NSUInteger _uid;
	MSRemoteObject *_remoteObject;
	NSMutableDictionary *_parameters;
}

@property (nonatomic, retain) MSRemoteObject *remoteObject;
@property (nonatomic, retain) NSMutableDictionary *parameters;

- (id)initWithResource:(Class)resource uid:(NSUInteger)uid;
- (id)initWithResource:(Class)resource uid:(NSUInteger)uid parameters:(NSDictionary *)parameters;

@end
