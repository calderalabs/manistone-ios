//
//  MSDeleteResourceDelegate.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSDeleteResourceDelegate : NSObject <TTURLRequestDelegate> {
	TTViewController *_controller;
	NSString *_text;
}

- (id)initWithController:(TTViewController *)controller text:(NSString *)text;

@end
