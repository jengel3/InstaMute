#import <Preferences/Preferences.h>

#define valuesPath @"/User/Library/Preferences/com.jake0oo0.instabetter.plist"

@interface InstaMutePrefsListController: PSListController
@end

@implementation InstaMutePrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"InstaMutePrefs" target:self] retain];
	}
	return _specifiers;
}
@end

@interface EditableListController : PSEditableListController {}
@end

@implementation EditableListController
- (id)specifiers {
	if (!_specifiers) {
		NSMutableArray *specs = [[NSMutableArray alloc] init];
		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:valuesPath];
		NSArray *keys = [prefs objectForKey:@"muted_users"];
		for (id o in keys) {
			PSSpecifier* defSpec = [PSSpecifier preferenceSpecifierNamed:o
				target:self
				set:NULL
				get:NULL
				detail:Nil
				cell:PSTitleValueCell
				edit:Nil];
			extern NSString* PSDeletionActionKey;
			[defSpec setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];
			[specs addObject:defSpec];
		}
		_specifiers = [[NSArray alloc] initWithArray:specs];
	}
	return _specifiers;
}

-(void)removedSpecifier:(PSSpecifier*)specifier{
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:valuesPath];
	NSMutableArray *keys = [prefs objectForKey:@"muted_users"];
	[keys removeObject:[specifier name]];
	[prefs setValue:keys forKey:@"muted_users"];
	[prefs writeToFile:valuesPath atomically:NO];
}


// http://iphonedevwiki.net/index.php/PreferenceBundles
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:valuesPath];
	if (!settings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return settings[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:valuesPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:valuesPath atomically:NO];
	CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}
// end

@end

