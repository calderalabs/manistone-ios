//
//  MSUser.m
//  Manistone
//
//  Created by Eugenio Depalo on 14/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"
#import "NSDateFormatter+MSAdditions.h"
#import "MSAPIRequest.h"
#import "NSData+Base64.h"

@implementation MSUser

@synthesize name = _name;
@synthesize surname = _surname;
@synthesize email = _email;
@synthesize stonesCount = _stonesCount;
@synthesize followersCount = _followersCount;
@synthesize stacksCount = _stacksCount;
@synthesize commentsCount = _commentsCount;
@synthesize favoritesCount = _favoritesCount;
@synthesize photo = _photo;
@synthesize password = _password;
@synthesize passwordConfirmation = _passwordConfirmation;
@synthesize informations = _informations;
@synthesize gender = _gender;
@synthesize unreadCount = _unreadCount;
@synthesize website = _website;
@synthesize hometown = _hometown;
@synthesize currentCity = _currentCity;
@synthesize birthday = _birthday;
@synthesize favorited = _favorited;
@synthesize followed = _followed;
@synthesize blocked = _blocked;
@synthesize hasPhoto = _hasPhoto;
@synthesize shareEmail = _shareEmail;
@synthesize shareBirthday = _shareBirthday;

+ (NSString *)stringForGender:(MSUserGender)gender {
	switch (gender) {
		case 0:
			return NSLocalizedString(@"Unspecified", @"");
			break;
		case 1:
			return NSLocalizedString(@"Male", @"");
			break;
		case 2:
			return NSLocalizedString(@"Female", @"");
			break;
	}
	
	return nil;
}

+ (NSString *)dedicationListWithUsers:(NSArray *)users {
	NSMutableArray *ids = [NSMutableArray array];
	
	for(MSUser *user in users)
		[ids addObject:user.uid];
	
	return [ids componentsJoinedByString:@","];
}

+ (NSString *)collectionName {
	return @"users";
}

- (NSString *)fullName {
	return [NSString stringWithFormat:@"%@ %@", _name, _surname];
}

-(id)copyWithZone:(NSZone*)zone {
	MSUser *newUser = [super copyWithZone:zone];
	
	newUser.name = _name;
	newUser.surname = _surname;
	newUser.email = _email;
	newUser.stonesCount = _stonesCount;
	newUser.followersCount = _followersCount;
	newUser.stacksCount = _stacksCount;
	newUser.commentsCount = _commentsCount;
	newUser.favoritesCount = _favoritesCount;
	newUser.gender = _gender;
	newUser.unreadCount = _unreadCount;
	newUser.hometown = _hometown;
	newUser.currentCity = _currentCity;
	newUser.informations = _informations;
	newUser.website = _website;
	newUser.birthday = _birthday;
	newUser.favorited = _favorited;
	newUser.followed = _followed;
	newUser.blocked = _blocked;
	newUser.hasPhoto = _hasPhoto;
	newUser.shareEmail = _shareEmail;
	newUser.shareBirthday = _shareBirthday;
	
	return newUser;
}

- (id)init {
	if(self = [super init]) {
		_birthday = [[NSDate date] retain];
	}
	
	return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
	if(self = [super initWithAttributes:attributes]) {
		_name = [[attributes valueForKey:@"name"] retain];
		_surname = [[attributes valueForKey:@"surname"] retain];
		
		if([attributes valueForKey:@"gender"] != [NSNull null])
			_gender = [[attributes valueForKey:@"gender"] unsignedIntValue];
	
		if([attributes valueForKey:@"email"] != [NSNull null])
			_email = [[attributes valueForKey:@"email"] retain];
		
		_stonesCount = [[attributes valueForKey:@"stones_count"] retain];
		_followersCount = [[attributes valueForKey:@"followers_count"] retain];
		
		_stacksCount = [[attributes valueForKey:@"stacks_count"] retain];
		_commentsCount = [[attributes valueForKey:@"comments_count"] retain];
		
		_unreadCount = [[attributes valueForKey:@"unread_count"] retain];
		
		_favoritesCount = [[attributes valueForKey:@"favorites_count"] retain];
		
		if([attributes valueForKey:@"informations"] != [NSNull null])
			_informations = [[attributes valueForKey:@"informations"] retain];
		
		if([attributes valueForKey:@"website"] != [NSNull null])
			_website = [[attributes valueForKey:@"website"] retain];
		
		if([attributes valueForKey:@"hometown"] != [NSNull null])
			_hometown = [[attributes valueForKey:@"hometown"] retain];
		
		if([attributes valueForKey:@"current_city"] != [NSNull null])
			_currentCity = [[attributes valueForKey:@"current_city"] retain];
		
		if([attributes valueForKey:@"birthday"] != [NSNull null]) {
			TT_RELEASE_SAFELY(_birthday);
			_birthday = [[NSDateFormatter dateFromJSONString:[attributes valueForKey:@"birthday"]] retain];
		}
		
		_favorited = [[attributes valueForKey:@"favorited"] boolValue];
		_followed = [[attributes valueForKey:@"followed"] boolValue];
		_blocked = [[attributes valueForKey:@"blocked"] boolValue];
		_hasPhoto = [[attributes valueForKey:@"has_photo"] boolValue];
		
		_shareEmail = [[attributes valueForKey:@"share_email"] retain];
		_shareBirthday = [[attributes valueForKey:@"share_birthday"] retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_name);
	TT_RELEASE_SAFELY(_surname);
	TT_RELEASE_SAFELY(_email);
	TT_RELEASE_SAFELY(_stonesCount);
	TT_RELEASE_SAFELY(_followersCount);
	TT_RELEASE_SAFELY(_stacksCount);
	TT_RELEASE_SAFELY(_commentsCount);
	TT_RELEASE_SAFELY(_favoritesCount);
	TT_RELEASE_SAFELY(_hometown);
	TT_RELEASE_SAFELY(_birthday);
	TT_RELEASE_SAFELY(_photo);
	TT_RELEASE_SAFELY(_currentCity);
	TT_RELEASE_SAFELY(_informations);
	TT_RELEASE_SAFELY(_website);
	TT_RELEASE_SAFELY(_password);
	TT_RELEASE_SAFELY(_passwordConfirmation);
	TT_RELEASE_SAFELY(_shareEmail);
	TT_RELEASE_SAFELY(_shareBirthday);
	TT_RELEASE_SAFELY(_unreadCount);
	
	[super dealloc];
}

- (NSDictionary *)attributes {
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	[attributes setValue:_name forKey:@"name"];
	[attributes setValue:_surname forKey:@"surname"];
	[attributes setValue:_hometown forKey:@"hometown"];
	[attributes setValue:_currentCity forKey:@"current_city"];
	[attributes setValue:_informations forKey:@"informations"];
	[attributes setValue:_website forKey:@"website"];
	[attributes setValue:_password forKey:@"password"];
	[attributes setValue:[NSNumber numberWithInt:_gender] forKey:@"gender"];
	[attributes setValue:_passwordConfirmation forKey:@"password_confirmation"];
	[attributes setValue:[NSDateFormatter JSONStringFromDate:_birthday] forKey:@"birthday"];
	[attributes setValue:_email forKey:@"email"];
	[attributes setValue:_shareEmail forKey:@"share_email"];
	[attributes setValue:_shareBirthday forKey:@"share_birthday"];
	
	if(_photo) {
		if(_photo.CGImage) {
			NSData *photoData = UIImageJPEGRepresentation(_photo, 1.0);
			
			[attributes setValue:[photoData base64EncodingWithLineLength:0] forKey:@"photo"];
		}
		else
			[attributes setValue:[NSNumber numberWithBool:YES] forKey:@"delete_photo"];
	}
	
	[attributes addEntriesFromDictionary:[super attributes]];
	
	return [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSString *)remotePhotoURLWithStyle:(NSString *)style {
	NSString *string = [[NSString stringWithFormat:@"%@/photos/%@?style=%@", [MSAPIRequest serverRoot], _uid, style] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	if(_hasPhoto)
		return string;
	
	return @"";
}

@end
