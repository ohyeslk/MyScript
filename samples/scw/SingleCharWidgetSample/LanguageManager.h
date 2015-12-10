// Copyright MyScript

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject

+ (NSArray *)availableLanguages;

+ (NSArray *)resourcesForLanguage:(NSString *)language;

+ (NSArray *)pathsForResources:(NSArray *)resources;

@end
