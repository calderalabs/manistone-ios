//
//  MSTableDedicationItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSDedication.h"

@interface MSTableDedicationItem : TTTableTextItem {
	MSDedication *_dedication;
}

@property (nonatomic, retain) MSDedication *dedication;

+ (id)itemWithDedication:(MSDedication *)dedication;

@end
