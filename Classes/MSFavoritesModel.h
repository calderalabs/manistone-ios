//
//  MSFavoritesModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 04/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSFavoritesModel : TTURLRequestModel {
	NSUInteger _stonesCount;
	NSUInteger _authorsCount;
	NSUInteger _stacksCount;
	
	NSUInteger _uid;
}

@property (nonatomic, assign) NSUInteger stonesCount;
@property (nonatomic, assign) NSUInteger authorsCount;
@property (nonatomic, assign) NSUInteger stacksCount;

- (id)initWithUid:(NSUInteger)uid;

@end
