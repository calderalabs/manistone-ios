//
//  TTViewController+MSAdditions.m
//  Manistone
//
//  Created by Eugenio Depalo on 4/29/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "TTViewController+MSAdditions.h"

static const NSInteger kActivityLabelTag = 4467;

@implementation TTViewController (MSAdditions)

- (void)startActivity:(NSString *)title {
    TTActivityLabel* label = [[[TTActivityLabel alloc]
                               initWithStyle:TTActivityLabelStyleBlackBezel] autorelease];
    label.tag = kActivityLabelTag;
    label.text = title;
    label.frame = self.view.frame;
    label.alpha = 0.0;
    [self.view addSubview:label];
    
    [UIView animateWithDuration:0.3 animations:^{ label.alpha = 1.0; }];
}

- (void)stopActivity {
    UIView* label = [self.view viewWithTag:kActivityLabelTag];
    
    [UIView animateWithDuration:0.3
                     animations:^{ label.alpha = 1.0; }
                     completion:^(BOOL finished) { [label removeFromSuperview]; }];
}

@end
