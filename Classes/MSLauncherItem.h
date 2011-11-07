//
//  MSLauncherItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 4/29/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSLauncherItem : TTLauncherItem {
    id _userInfo;   
}

@property (nonatomic, retain) id userInfo;

@end
