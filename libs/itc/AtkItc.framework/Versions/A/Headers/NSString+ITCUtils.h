//
//  NSString+ITCUtils.h
//  InteractiveTextComponent
//
//

#import <Foundation/Foundation.h>

@interface NSString (ITCUtils)

/**
 *  @return YES if the string is a CJK punctuation.
 */
- (BOOL)isCJKPunctuation;

/**
 *  @return YES if the string is an Arabic punctuation.
 */
- (BOOL)isArabicPunctuation;

/**
 *  @return YES if the string is a Latin punctuation.
 */
- (BOOL)isLatinPunctuation;

/**
 *  @return YES if the string is a Thai punctuation.
 */
- (BOOL)isThaiPunctuation;

/**
 *  Check if the string is a puncation whatever the language.
 *  @return YES if the string is a punctuation (CJK, Arabic, Latin or Thai).
 */
- (BOOL)isPunctuation;

@end
