//
//  MSTagsModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 16/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTagsModel : TTURLRequestModel {
	NSMutableArray *_tags;
}

@property (nonatomic, retain) NSMutableArray *tags;

- (void)search:(NSString*)text;

@end
