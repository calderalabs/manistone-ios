//
//  AuthorShowController.h
//  Manistone
//
//  Created by Eugenio Depalo on 01/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface AuthorShowController : TTTableViewController {
	NSUInteger _uid;

	TTImageView *_pictureView;
	TTStyledTextLabel *_stonesLabel;
	TTStyledTextLabel *_followersLabel;
	TTStyledTextLabel *_registeredLabel;
	TTStyledTextLabel *_ageLabel;
	TTStyledTextLabel *_locationLabel;
}

- (id)initWithUid:(NSUInteger)uid;

@end
