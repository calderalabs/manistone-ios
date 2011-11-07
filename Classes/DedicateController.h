//
//  DedicateController.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSAdController.h"

@interface DedicateController : MSRemoteListController <UISearchBarDelegate> {
	NSUInteger _uid;
}

@property (nonatomic, readonly, assign) NSUInteger uid;

@end
