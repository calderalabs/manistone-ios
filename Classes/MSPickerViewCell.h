//
//  MSPickerViewCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 29/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSPickerViewCell : TTButton {
	id        _object;
	UILabel*  _labelView;
}

@property (nonatomic, retain) id        object;
@property (nonatomic, copy)   NSString* label;
@property (nonatomic, retain) UIFont*   font;

@end
