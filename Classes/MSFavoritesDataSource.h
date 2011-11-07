//
//  MSFavoritesDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 04/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSFavoritesModel.h"

@interface MSFavoritesDataSource : TTListDataSource {
	MSFavoritesModel *_favoritesModel;
	NSUInteger _uid;
}

- (id)initWithUid:(NSUInteger)uid;

@end
