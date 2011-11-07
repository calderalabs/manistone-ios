//
//  MSAdMobController.h
//  Manistone
//
//  Created by Eugenio Depalo on 29/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteListController.h"

#ifndef LITE_VERSION
#define MSAdController MSRemoteListController
#else

#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

@interface MSAdController : MSRemoteListController <AdWhirlDelegate> {
	AdWhirlView *_adView;
}

@end

#endif