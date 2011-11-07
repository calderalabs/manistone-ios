//
//  MSUser.h
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"

typedef enum {
	MSUserGenderUnspecified = 0,
	MSUserGenderMale,
	MSUserGenderFemale
} MSUserGender;

@interface MSUser : MSRemoteObject {
	NSString *_name;
	NSString *_surname;
	NSString *_hometown;
	NSString *_currentCity;
	NSString *_email;
	NSString *_informations;
	NSString *_website;
	
	NSString *_password;
	NSString *_passwordConfirmation;
	
	MSUserGender _gender;
	
	UIImage *_photo;
	
	NSNumber *_stonesCount;
	NSNumber *_followersCount;
	NSNumber *_stacksCount;
	NSNumber *_commentsCount;
	NSNumber *_favoritesCount;
	
	NSDate *_birthday;
	
	BOOL _favorited;
	BOOL _followed;
	BOOL _blocked;
	
	BOOL _hasPhoto;
	
	NSNumber *_shareEmail;
	NSNumber *_shareBirthday;
	NSNumber *_receiveNotifications;
	
	NSNumber *_unreadCount;
}

+ (NSString *)dedicationListWithUsers:(NSArray *)users;

+ (NSString *)stringForGender:(MSUserGender)gender;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *hometown;
@property (nonatomic, retain) NSString *currentCity;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *informations;
@property (nonatomic, retain) NSString *website;

@property (nonatomic, assign) MSUserGender gender;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *passwordConfirmation;
@property (nonatomic, retain) UIImage *photo;

@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, retain) NSNumber *stonesCount;
@property (nonatomic, retain) NSNumber *followersCount;
@property (nonatomic, retain) NSNumber *stacksCount;
@property (nonatomic, retain) NSNumber *commentsCount;
@property (nonatomic, retain) NSNumber *favoritesCount;

@property (nonatomic, retain) NSDate *birthday;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL blocked;
@property (nonatomic, assign) BOOL hasPhoto;

@property (nonatomic, retain) NSNumber *shareEmail;
@property (nonatomic, retain) NSNumber *shareBirthday;

@property (nonatomic, retain) NSNumber *unreadCount;

- (NSString *)remotePhotoURLWithStyle:(NSString *)style;

@end
