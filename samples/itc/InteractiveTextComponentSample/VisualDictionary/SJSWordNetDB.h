//
//  SJSWordNetDB.h
//  GraphVisualizer
//
//  Created by Kai Lu on 2/11/14.
//  Copyright (c) 2014 Kai Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

@interface SJSWordNetDB : NSObject

+ (SJSWordNetDB *)instance;
- (NSSet *)meaningsForWord:(NSString *)word;
- (NSSet *)wordsForMeaning:(NSString *)meaning;
- (NSString *)definitionOfMeaning:(NSString *)meaning;
- (BOOL)containsWord:(NSString *)word;
- (NSString *)getRandomWord;

@end
