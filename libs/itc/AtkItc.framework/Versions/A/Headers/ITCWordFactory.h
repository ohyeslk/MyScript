// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

@protocol ITCUserParams;
@protocol ITCWordUserParamsFactoryProtocol;
@protocol ITCCharBoxFactoryProtocol;
@class ITCStrokeFactory;
@class ITCSmartWord;
@class ITCTransform;
@class ITCCharBoxFactory;

/**
 *  Object in charge of the creation of `ITCSmartWord`.
 *  Do not inherit
 */
@interface ITCWordFactory : NSObject

//==================================================================================================
#pragma mark - Creation
//==================================================================================================

/** @name Creation */

/**
 *  Creates a new ITCWordFactory. Mandatory for the creation of a ITCSmartPage.
 *
 *  @param strokeFactory        The stroke factory used in the word factory. Must not be `nil`.
 *  @param wordUserParamFactory The wordUserParamsFactory for the current word factory.
 *  If you use `ITCUserParams`, the object can not be `nil`.
 *
 *  @return the new ITCWordFactory
 */
+ (id)wordFactoryWithStrokeFactory:(ITCStrokeFactory *)strokeFactory wordUserParamFactory:(id<ITCWordUserParamsFactoryProtocol>)wordUserParamFactory;

//==================================================================================================
#pragma mark - Copy/Sub
//==================================================================================================

/** @name Copy/Sub */

/**
 * Creates a copy of the given `ITCSmartWord`
 *
 * @param word Original word.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word copied.
 */
- (ITCSmartWord *)createCopyOfWord:(ITCSmartWord*)aWord spaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a sub `ITCSmartWord` from a given word.
 * @param begin Start index to consider among word characters.
 * @param end End index to consider among word characters.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word created with the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createSubWord:(ITCSmartWord*)aWord beginIndex:(NSInteger)aBeginIndex endIndex:(NSInteger)anEndIndex spaceBefore:(NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - Geometry
//==================================================================================================

/** @name Geometry */

/**
 * Creates a `ITCSmartWord` with the given translation values.
 * @param dx Amount in the X direction to offset the word.
 * @param dy Amount in the Y direction to offset the word.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word created with the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createMovedWord:(ITCSmartWord*)aWord offsetX:(NSInteger)anOffsetX offsetY:(NSInteger)anOffsetY spaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a `ITCSmartWord` with the given translation values.
 * @param dx The X scale the word.
 * @param dy The Y scale the word.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word created with the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createScaledWord:(ITCSmartWord*)aWord scaleX:(NSInteger)aScaleX scaleY:(NSInteger)aScaleY spaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a `ITCSmartWord` with the given translation values.
 * @param transform The new transform applied to the word.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word created with the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createTransformedWord:(ITCSmartWord*)aWord transform:(ITCTransform*)aTransform spaceBefore:(NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - Candidate
//==================================================================================================

/** @name Candidate */

/**
 * Creates a `ITCSmartWord` by selecting a new candidate.
 * This method applies on both ink or typeset words. 
 * @param word Original word.
 * @param selectedIndex The selected candidate index to set.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word created from the given parameters.
 */
- (ITCSmartWord *)createWord:(ITCSmartWord*)aWord selectedCandidateIndex:(NSInteger)selectedIndex spaceBefore:(NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - User params
//==================================================================================================

/** @name User params */

/**
 * Creates a copy of the given `ITCSmartWord` associated with given array of ITCUserParams.
 * If the userParams count is different from the characters count or the strokes count the
 * method will return `nil`.
 * @param word Original word.
 * @param userParams The list of user parameters to be set.
 * @param spaceBefore The new number of spaces before the word.
 * @return Word copied with given user parameters.
 */
- (ITCSmartWord *)createWord:(ITCSmartWord*)aWord userParams:(NSArray *)userParams spaceBefore:(NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - Typeset
//==================================================================================================

/** @name Typeset */

/**
 * Creates a typeset `ITCSmartWord` from a given word.
 *
 * This is the way to typeset a word using an external way to compute the character boxes.
 * @param word Original word.
 * @param charBoxes The char boxes for the selected candidate.
 * @param baseline The base line position where the word will be typeset.
 * @param mideline The midline position used for the internal scaling of the characters in their boxes.
 * @param spaceBefore The new number of space before the word.
 * @return Word created form the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createTypeSetWord:(ITCSmartWord*)aWord charBoxes:(NSArray *)charBoxes baseline:(float)baseline midLine:(float)midline spaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a typeset `ITCSmartWord` from a given ink word.
 *
 * This is the way to typeset a word using the component provided character box calculation feature.
 * See ITCSmartPage.replaceWord:
 * @param word Original word.
 * @param x Word bounding rectangle abscissa.
 * @param y Word bounding rectangle ordinate.
 * @param spaceBefore The new number of spaces before the word.
 * @return ITCSmartWord created form the given parameters or `nil` for an invalid request.
 */
- (ITCSmartWord *)createTypeSetWord:(ITCSmartWord*)aWord xPosition:(float)x yPosition:(float)y spaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a `ITCSmartWord` from a label.
 *
 * This is the way of creating a word from a label. It could be the case of a
 * copy(cut)/paste feature from outside the application.
 * See ITCSmartPage.addWord: to add it to the recognition process once created.
 * @param label String representing the label of the word to be created.
 * @param locale String representing the system local.
 * @param x Word bounding rectangle abscissa.
 * @param y Word bounding rectangle ordinate.
 * @param defaultCharacterUserParams User parameters to be set to all the word characters.
 * @param spaceBefore The new number of spaces before the word.
 * @return an array of ITCSmartWord created form the given parameters.
 */
- (NSArray *)createTypesetWordsFromLabel:(NSString *)label locale:(NSString*)locale xPosition:(float)x yPosition:(float)y userParams:(id<ITCUserParams>)defaultCharacterUserParams spaceBefore:(NSInteger)spaceBefore;

//==================================================================================================
#pragma mark - Serialisation
//==================================================================================================

/** @name Serialisation */

/**
 * Creates a `ITCSmartWord` from a serialized word.
 *
 * @param word Original word.
 * @param charIndexTypeset The characters index to typeset. The other ones will be created with this stroke.
 * @param spaceBefore The new number of spaces before the word.
 * @return a ITCSmartWord created from the given parameters.
 */
- (ITCSmartWord*)createMixWordFromWord:(ITCSmartWord*) word charIndexTypeset:(NSArray *)charIndexTypeset andSpaceBefore:(NSInteger)spaceBefore;

/**
 * Creates a ITCSmartWord from a serialized word.
 *
 * @param data the `ITCSmartWord` serialized as a NSData
 * @return a word deserialized from the NSData
 */
- (ITCSmartWord *)createWordFromData:(NSData *)data;

//==================================================================================================
#pragma mark - CharBoxFactory
//==================================================================================================

/** @name CharBoxFactory */

/**
 *  Sets the char box factory that will be used for typeset words.
 *  @param charBoxFactory The newchar box factory
 */
- (void)setCharBoxFactory:(id<ITCCharBoxFactoryProtocol>)charBoxFactory;

/**
 *  @return The char box factory used.
 */
- (id<ITCCharBoxFactoryProtocol>)charBoxFactory;

/**
 *  @return Our default implementation of the `ITCCharBoxFactoryProtocol`.
 */
- (ITCCharBoxFactory *)defaultCharBoxFactory;

@end
