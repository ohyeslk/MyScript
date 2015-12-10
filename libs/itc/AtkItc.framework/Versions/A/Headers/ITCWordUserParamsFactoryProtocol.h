// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

@class ITCSmartWord;
@class ITCTransform;
@protocol ITCUserParams;

/**
 * This protocol is called from the `ITCWordFactory` and from gesture processing.
 * By implementing these methods, you can create a new user param for the new `ITCSmartWord` from the previous user param.
 *
 * All methods are required.
 */
@protocol ITCWordUserParamsFactoryProtocol <NSObject>

@required

/**
 * Creates new character user parameters from an old `ITCSmartWord` for a new typeset word.
 * @param newWord New word.
 * @param charIndex New word character index.
 * @param oldWord Original word.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createCharacterUserParamsForNewTypeSetWord:(ITCSmartWord*)aNewWord
                                                 characterIndex:(NSInteger)aCharIndex
                                                     oldWord:(ITCSmartWord*)anOldWord;
/**
 * Creates new character user parameters from old character user parameters.
 * @param oldCharacterUserParams Old character user parameters.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createCharacterUserParamsForWordFromUserParams:(id<ITCUserParams>)oldCharacterUserParams;
/**
 * Creates new character user parameters from an old `ITCSmartWord` for a new moved word.
 * @param oldCharacterUserParams Old character user parameters.
 * @param transform The ITCTransform object to use for the transformation.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createCharacterUserParamsForTransformedWord:(id<ITCUserParams>)oldCharacterUserParams transform:(ITCTransform *)transform;

@end
