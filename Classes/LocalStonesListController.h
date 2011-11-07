//
//  LocalStonesListController.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

@interface LocalStonesListController : TTTableViewController {
	BOOL _picker;
}

@property (nonatomic, assign, getter=isPicker) BOOL picker;

@end
