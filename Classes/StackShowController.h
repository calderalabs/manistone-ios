//
//  StackShowController.h
//  Manistone
//
//  Created by Eugenio Depalo on 26/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStack.h"

@interface StackShowController : TTTableViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
	NSUInteger _uid;
	MSStack *_stack;
	TTView *_tipView;
	UILabel *_tipLabel;
	UILabel *_nameLabel;
	UIToolbar *_actionsToolbar;
}

@end
