// Copyright MyScript. All right reserved.

#import "WordUserParamsFactorySample.h"
#import "UserParamSample.h"
#import <AtkItc/ITC.h>

@implementation WordUserParamsFactorySample

- (id<ITCUserParams>)createCharacterUserParamsForNewTypeSetWord:(ITCSmartWord*)aNewWord
                                                 characterIndex:(NSInteger)aCharIndex
                                                     oldWord:(ITCSmartWord*)anOldWord;
{
    // if stroke
    if (anOldWord.type == ITCWordTypeRaw)
    {
        UserParamSample *userParams = [[[anOldWord strokes] objectAtIndex:0] userParams];
        [userParams setCharacterFont:[UIFont systemFontOfSize:DEFAULT_FONT_SIZE]];
        return userParams;
    }
    else if (anOldWord.type == ITCWordTypeMix)
    {
        UserParamSample *userParams;
        NSUInteger charCount = anOldWord.charLabels.count;
        for (int i = 0; i < charCount; i++)
        {
            userParams = [anOldWord userParamsForCharacterAtIndex:i];
            if (userParams != nil)
                return userParams;
        }
        
        return [anOldWord userParamsForCharacterAtIndex:aCharIndex];
    }
    // else if typeseted or mix
    else
        return [anOldWord userParamsForCharacterAtIndex:aCharIndex];
}

- (id<ITCUserParams>)createCharacterUserParamsForWordFromUserParams:(id<ITCUserParams>)oldCharacterUserParams
{
    return oldCharacterUserParams;
}

- (id<ITCUserParams>)createCharacterUserParamsForTransformedWord:(id<ITCUserParams>)oldCharacterUserParams transform:(ITCTransform *)transform
{
    return oldCharacterUserParams;
}

@end
