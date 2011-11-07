//
//  StoneShowController.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"

@interface StoneShowController : TTTableViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
	NSUInteger _uid;
	MSStone *_stone;
	
	TTView *_engravingView;
	UILabel *_engravingLabel;
	UILabel *_dateLabel;
	
	UIToolbar *_actionsToolbar;
	
#ifndef LITE_VERSION
	TTTableButton *_translateItem;
	NSString *_translatedText;
	TTTableButton *_revertButton;
#endif
}

@property (nonatomic, retain) NSString *engraving;

@end
