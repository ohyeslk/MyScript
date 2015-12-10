// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartStroke.h"
#import "ITCSmartPage.h"
#import "ITCUserParams.h"
#import "ITCRect.h"

/**
 * Defines the type of a word.
 */
typedef NS_ENUM(NSInteger, ITCWordType)
{
  /** The word is entirely made of word characters. */
  ITCWordTypeTypeset,
  /** The word is entirely made of strokes. */
  ITCWordTypeRaw,
  /** The word is made of both word characters and strokes. */
  ITCWordTypeMix
};

/**
 *  This class is the representation of the word in Interactive Text Component.
 
 *  Do not inherit
 */
@interface ITCSmartWord : NSObject

//==================================================================================================
#pragma mark - Candidates and labels
//==================================================================================================

/** @name Candidates and labels */

/**
 * @return A list of candidates labels (`NSString`) for this word.
 */
- (NSArray*)candidates;

/**
 * @return The index of the selected candidate in candidates list
 */
- (NSInteger)selectedCandidateIndex;

/**
 * @return The string of the selected candidate.
 */
- (NSString*)selectedCandidate;

/**
 *  @param charIndex Character index in the word.
 *
 *  @return A list of candidates labels (`NSString`) for the character at the
 * given index in this word.
 */
- (NSArray*)charCandidatesWithCharIndex:(NSInteger)charIndex;

/**
 *  Returns the string of the selected candidate for the character at the given index in this word.
 *
 *  @param charIndex The character index in the word.
 *
 *  @return The string of the selected candidate.
 */
- (NSString*)charSelectedCandidateWithCharIndex:(NSInteger)charIndex;

/**
 *  Returns a list of strings representing the character labels of this word. This can have a different size than the word label.
 *
 *  @return The list of character labels.
 */
- (NSArray*)charLabels;

/**
 *  Returns the number of char in the word label.
 *
 *  @return The char count
 */
- (NSInteger)labelCharSize;

//==================================================================================================
#pragma mark - Geometry
//==================================================================================================

/** @name Geometric and content */

/**
 *  Returns a list of rectangular boxes (`ITCRect`) corresponding to the word characters.
 *
 *  @return The list of word character boxes.
 */
- (NSArray*)charBoxes;

/**
 *  @return The word midline shift value.
 */
- (ITCRect*)charBoxForCharIndex:(NSInteger)index;

/**
 *  @return The midline shift of this word.
 */
- (float)midlineShift;

/**
 *  @return The word baseline position.
 */
- (float)baseLine;

/**
 *  @return The X coordinate of the left bound of this word.
 */
- (float)leftBound;

/**
 *  @return The X coordinate of the right bound of this word.
 */
- (float)rightBound;

/**
 *  @return The bounding rectangle of this word.
 */
- (ITCRect*)boundingRect;


//==================================================================================================
#pragma mark - Type
//==================================================================================================

/** @name Type */

/**
 *  @return The wordType can be either a Typeset word, a Raw word is a Mix word
 */
- (ITCWordType)type;

/**
 *  Returns a array of `ITCWordType` as int value inside a `NSArray`
 *  @return The charType list that can be either a Typeset character or a Raw character
 */
- (NSArray *)charTypes;

/**
 *  @return The number of spaces before this word.
 */
- (NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - Strokes
//==================================================================================================

/** @name Strokes */

/**
 *  @return The strokes (`ITCSmartStroke`) associated to this word or nothing if this word has been typeset
 */
- (NSArray*)strokes;

//==================================================================================================
#pragma mark - User params
//==================================================================================================

/** @name User params */

/**
 *  Returns the user parameters associated to this given word character index.
 *
 *  @param charIndex The character index
 *
 *  @return User parameters of the given character.
 */
- (id<ITCUserParams>)userParamsForCharacterAtIndex:(NSInteger)aCharacterIndex;


//==================================================================================================
#pragma mark - Serialization
//==================================================================================================

/** @name Serialization */

/**
 *  Creates a data object from the stroke
 *
 *  @return The serialized data from the stroke.
 */
- (NSData *)data;

//==================================================================================================
#pragma mark - Locale
//==================================================================================================

/** @name Locale */

/**
 *  @return The string representing the locale of the word.
 */
- (NSString*)locale;

//==================================================================================================
#pragma mark - Utils
//==================================================================================================

/** @name Utils */

/**
 *  @return `YES` if the smartword is empty
 */
- (BOOL)isEmpty;

/**
 *  @return YES if need to redraw the typeset (only for TYPESET or MIX word),
 *  false otherwise.
 */
- (BOOL)isOutdatedTypeset;

/**
 *  @return Returns the date of the start of this word.
 */
- (NSDate *)startTimeStamp;

/**
 *  @return Returns the date of the end of this word.
 */
- (NSDate *)endTimeStamp;

@end
