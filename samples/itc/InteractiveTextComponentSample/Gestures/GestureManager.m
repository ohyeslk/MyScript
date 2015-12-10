// Copyright MyScript. All right reserved.

#import "GestureManager.h"

#import "ViewController.h"
#import "ITCSampleGestureData.h"
#import "ITCSampleWord.h"
#import "UserParamSample.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface GestureManager ()<MFMailComposeViewControllerDelegate>

@end

@implementation GestureManager
{
    ABPersonViewController *_personView;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initGestureData];
    }
    return self;
}

- (void)initGestureData
{
    _itcSampleGestureData = [NSMutableArray array];
    ITCSampleGestureData *gestureData;
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeErase;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = YES;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeInsert;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeJoin;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeOverwrite;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = YES;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeReturn;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeSelection;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeSingleTap;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
    {
        gestureData = [[ITCSampleGestureData alloc] init];
        gestureData.gestureType = ITCGestureTypeUnderline;
        gestureData.isEnable = YES;
        gestureData.isDefaultProcessing = NO;
        [_itcSampleGestureData addObject:gestureData];
    }
}


//----------------------------------
#pragma mark GestureTableViewController delegate
//----------------------------------
- (void)gestureType:(ITCGestureType)gestureType didEnable:(BOOL)isEnable
{
    // update gestureData list
    ITCSampleGestureData *gestureData = [self findGestureDataForGestureType:gestureType];
    
    if (gestureData != nil)
    {
        gestureData.isEnable = isEnable;
    }
    
    // apply gesture (enable/disable & default processing/manual)
    [self applyGestureOnPageInterpreter:_pageInterpreter];
}

- (void)gestureType:(ITCGestureType)gestureType didDefaultProcessing:(BOOL)isDefaultProcessing
{
    // update gestureData list
    ITCSampleGestureData *gestureData = [self findGestureDataForGestureType:gestureType];
    
    if (gestureData != nil)
    {
        gestureData.isDefaultProcessing = isDefaultProcessing;
    }
    
    // apply gesture (enable/disable & default processing/manual)
    [self applyGestureOnPageInterpreter:_pageInterpreter];
}

- (ITCSampleGestureData *)findGestureDataForGestureType:(ITCGestureType)gestureType
{
    for (ITCSampleGestureData *gestureData in _itcSampleGestureData)
    {
        if (gestureData.gestureType == gestureType)
            return gestureData;
    }
    
    return nil;
}

- (void)applyGestureOnPageInterpreter:(ITCPageInterpreter *)pageInterpreter
{
    for (ITCSampleGestureData *gestureData in _itcSampleGestureData)
    {
        [pageInterpreter setGesture:gestureData.gestureType enable:gestureData.isEnable];
        [pageInterpreter setGesture:gestureData.gestureType defaultProcessing:gestureData.isDefaultProcessing];
    }
}

- (ITCSampleGestureData *)gestureDataFromGestureType:(ITCGestureType)gestureType
{
    for (ITCSampleGestureData *gestureData in _itcSampleGestureData)
    {
        if (gestureType == gestureData.gestureType)
            return gestureData;
    }
    
    return nil;
}


//----------------------------------
#pragma mark DataFormat management
//----------------------------------

- (ABRecordRef)findPersonFromPhoneNumber:(NSString *)number
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // ask authorization
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        // The user doesn't want us to go in his contacts
        return NO;
    }
    
    
    CFArrayRef       allPeople   = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex          nPeople     = ABAddressBookGetPersonCount( addressBook );
    
    for (int i = 0; i < nPeople; i++)
    {
        ABRecordRef person       = CFArrayGetValueAtIndex( allPeople, i );
        ABMultiValueRef mainPhone    = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        // if phone number (at least one is present), iterate
        CFIndex index = ABMultiValueGetCount(mainPhone);
        if (index > 0)
        {
            for (int i = 0; i < index; i++)
            {
                NSString *phoneType = (__bridge NSString *)ABMultiValueCopyValueAtIndex(mainPhone, i);
                
                // remove space
                NSString *phoneNumberTrimmed = [phoneType stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if ([phoneNumberTrimmed isEqualToString:number])
                    return person;
                
                NSLog(@"phone %@", phoneType);
            }
        }
        
        NSLog(@"%@", mainPhone);
    }
    return nil;
}

//----------------------------------
#pragma mark ITCSmartPageGesture delegate
//----------------------------------

- (void)joinGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // if default processing, do no manually handle the gesture
        if ([self gestureDataFromGestureType:ITCGestureTypeJoin].isDefaultProcessing)
            return;

        // Do nothing if there is no word
        if (!nearestWord)
            return;
        
        [_viewController showNotification:@"Join Gesture"];
        
        // Get the nearest word line number
        ITCWordRange *wordRange = [ITCWordRange wordRangeWithWord:nearestWord];
        
        NSInteger nearestWordLineNumber = [_pageInterpreter.page lineNumberFromWordRange:wordRange];
        // Get the words at the same line
        NSArray *lineWords = [_pageInterpreter.page wordsAtLineNumber:nearestWordLineNumber];
        
        // Specific case of the arabic
        BOOL rtl = [self isRTLLine:nearestWord];
        
        NSMutableArray *removedWords = [self computeImpactedWords:x nearestWord:nearestWord charIndex:charIndex rtlCase:rtl];
        BOOL isGestureInsideWord = charIndex > 0 && charIndex < nearestWord.selectedCandidate.length;
        
        
        float nearestWordLeftBound = [nearestWord leftBound];
        float nearestWordRightBound = [nearestWord rightBound];
        
        BOOL isRTLNearestWord = [self isRTLAlignmentForString:nearestWord.selectedCandidate];
        
        NSInteger indexOfNearestWordInLine = [lineWords indexOfObject:nearestWord];
        
        // Initialize x translation value
        float dx = FLT_MAX;
        
        // One/First word in line case
        if (charIndex == 0 && [nearestWord isEqual:[lineWords objectAtIndex:0]] && [removedWords containsObject:nearestWord])
        {
            if (!rtl)
                dx = x - nearestWordLeftBound;
            else
                dx = x - nearestWordRightBound;
        }
        else
        {
            if (charIndex == 0 && indexOfNearestWordInLine > 0)
            {
                ITCSmartWord *word = [lineWords objectAtIndex:indexOfNearestWordInLine - 1];
                if (!rtl)
                    dx = [word rightBound] - nearestWordLeftBound;
                else if (rtl && isRTLNearestWord)
                    dx = [word leftBound] - nearestWordRightBound;
            }
            else if (charIndex == [nearestWord charBoxes].count)
            {
                if (indexOfNearestWordInLine < lineWords.count - 1 && !rtl)
                {
                    ITCSmartWord *word = [lineWords objectAtIndex:indexOfNearestWordInLine + 1];
                    dx = [nearestWord rightBound] - [word leftBound];
                }
                
                else if (indexOfNearestWordInLine > 0)
                {
                    if (!rtl)
                    {
                        ITCSmartWord *word = [lineWords objectAtIndex:indexOfNearestWordInLine - 1];
                        dx = [nearestWord rightBound] - [word leftBound];
                    }
                    else
                    {
                        ITCSmartWord *word = [lineWords objectAtIndex:indexOfNearestWordInLine - 1];
                        dx = [nearestWord rightBound] - [word leftBound];
                    }
                    
                    if (rtl)
                        dx = -dx;
                }
                else
                {
                    ITCSmartWord *word = [removedWords firstObject];
                    if (!rtl)
                        dx = nearestWordRightBound - [word leftBound];
                    else
                        dx = nearestWordLeftBound - [word rightBound];
                }
            }
            else
            {
                if (charIndex > 0)
                {
                    NSArray *charBox = [nearestWord charBoxes];
                    ITCRect *itcRect = [charBox objectAtIndex:charIndex];
                    ITCRect *previousItcRect = [charBox objectAtIndex:charIndex-1];
                    if (!isRTLNearestWord)
                        dx = (previousItcRect.x + previousItcRect.width) - itcRect.x;
                    else
                        dx = previousItcRect.x - (itcRect.x + itcRect.width);
                }
                else
                {
                    ITCSmartWord *word = [removedWords firstObject];
                    dx = nearestWordLeftBound - [word rightBound];
                }
            }
        }
        float maxDx = FLT_MAX;
        if (charIndex >= 0 && charIndex < nearestWord.charBoxes.count && isGestureInsideWord)
        {
            ITCRect *rect = [nearestWord.charBoxes objectAtIndex:charIndex];
            maxDx = rect.width;
        }
        
        // set a maximum gap
        if (dx > maxDx)
            dx = maxDx;
        
        // Create the new words list
        NSMutableArray *addedWords = [self createNewWordsFrom:removedWords dx:dx dy:0 isInsideWord:isGestureInsideWord keepSpaceBefore:NO];
        
        // Create the sub-words from the nearest word if necessary
        if (isGestureInsideWord)
        {
            ITCSmartWord *word = [_wordFactory createSubWord:nearestWord beginIndex:0 endIndex:charIndex spaceBefore:[nearestWord spaceBefore]];
            [addedWords addObject:word];
            
            ITCSmartWord *wordTempo = [_wordFactory createSubWord:nearestWord beginIndex:charIndex endIndex:[nearestWord charLabels].count spaceBefore:0];
            wordTempo = [_wordFactory createMovedWord:wordTempo offsetX:dx offsetY:0 spaceBefore:[wordTempo spaceBefore]];
            [addedWords addObject:wordTempo];
            
            [removedWords addObject:nearestWord];
            
        }
        
        // Remove underline from user params
        for (ITCSmartWord *word in removedWords)
        {
            [_viewController.displayViewController removeUnderlineToSmartWord:word];
        }
        
        [_pageInterpreter.page replaceWords:removedWords withNewWords:addedWords];
    }];
}

- (void)eraseGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes wordRange:(ITCWordRange *)wordRange
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // if default processing, do no manually handle the gesture
        if (![self gestureDataFromGestureType:ITCGestureTypeErase].isDefaultProcessing)
        {
        }
        else
        {
            [_viewController showNotification:@"Erase Gesture"];
        }
    }];
    
}

- (void)overwriteGestureWithinPage:(ITCSmartPage *)page wordRange:(ITCWordRange *)wordRange
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_viewController showNotification:@"Overwrite Gesture"];
        
        // if default processing, do no manually handle the gesture
        if (![self gestureDataFromGestureType:ITCGestureTypeOverwrite].isDefaultProcessing)
        {
        }
    }];
    
}

- (void)insertGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // if default processing, do no manually handle the gesture
        if ([self gestureDataFromGestureType:ITCGestureTypeInsert].isDefaultProcessing)
            return;
        
        // Do nothing if there is no word
        if (!nearestWord)
            return;
        
        // Specific case of the arabic
        BOOL rtl = [self isRTLLine:nearestWord];
        
        NSMutableArray *removedWords = [self computeImpactedWords:x nearestWord:nearestWord charIndex:charIndex rtlCase:rtl];
        BOOL isGestureInsideWord = charIndex > 0 && charIndex < nearestWord.selectedCandidate.length;
        
        // Initialize final removed word list size
        NSInteger removedWordsSize = removedWords.count;
        
        // Calculate the translation
        float maxDx = FLT_MAX;
        if (charIndex >= 0 && charIndex < nearestWord.charBoxes.count)
        {
            ITCRect *rect = [nearestWord.charBoxes objectAtIndex:charIndex];
            maxDx = rect.width;
        }
        
        // Compute x translation value
        float dx = [nearestWord midlineShift];
        for (ITCSmartWord *word in removedWords)
        {
            dx += [word midlineShift];
        }
        dx /= removedWordsSize + 1;
        
        // set a maximum gap
        if (dx > maxDx)
            dx = maxDx;
        
        if (rtl)
        {
            dx = -dx;
        }
        
        // Create the new words list
        NSMutableArray *addedWords = [self createNewWordsFrom:removedWords dx:dx dy:0 isInsideWord:isGestureInsideWord keepSpaceBefore:YES];
        
        // Create the sub-words from the nearest word if necessary
        if (isGestureInsideWord)
        {
            BOOL isRTLCutWord = [self isRTLAlignmentForString:nearestWord.selectedCandidate];
            
            ITCSmartWord *smartWord = [_wordFactory createSubWord:nearestWord beginIndex:0 endIndex:charIndex spaceBefore:[nearestWord spaceBefore]];
            
            ITCSmartWord *secondPartWord = [_wordFactory createSubWord:nearestWord beginIndex:charIndex endIndex:[nearestWord charLabels].count spaceBefore:0];
            
            if (rtl && !isRTLCutWord && smartWord.boundingRect.x < secondPartWord.boundingRect.x)
                smartWord = [_wordFactory createMovedWord:smartWord offsetX:dx offsetY:0 spaceBefore:[secondPartWord spaceBefore] + 1];
            else
                secondPartWord = [_wordFactory createMovedWord:secondPartWord offsetX:dx offsetY:0 spaceBefore:[secondPartWord spaceBefore] + 1];
            
            
            // In the specific case of right to left language we need to re-typeset the word to calculate the right boxes for ligatures
            if (rtl)
            {
                if (smartWord.type == ITCWordTypeMix || smartWord.type == ITCWordTypeTypeset)
                    smartWord = [_wordFactory createTypeSetWord:smartWord xPosition:smartWord.boundingRect.x yPosition:smartWord.baseLine spaceBefore:smartWord.spaceBefore];
                if (secondPartWord.type == ITCWordTypeMix || secondPartWord.type == ITCWordTypeTypeset)
                    secondPartWord = [_wordFactory createTypeSetWord:secondPartWord xPosition:secondPartWord.boundingRect.x yPosition:secondPartWord.baseLine spaceBefore:secondPartWord.spaceBefore];
            }
            [addedWords addObject:smartWord];
            
            [addedWords addObject:secondPartWord];
            [removedWords addObject:nearestWord];
        }
        
        // check if words do not get out of page view frame
        if ([_viewController checkWords:addedWords insideBoundsoffsetX:dx offsetY:0])
        {
            [_viewController showNotification:@"Insert Gesture"];
            [_pageInterpreter.page replaceWords:removedWords withNewWords:addedWords];
        }
    }];
}

- (void)returnGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // if default processing, do no manually handle the gesture
        if ([self gestureDataFromGestureType:ITCGestureTypeReturn].isDefaultProcessing)
            return;
        
        // Do nothing if there is no word
        if (!nearestWord)
            return;
        
        // Get the nearest word line number
        ITCWordRange *wordRange = [ITCWordRange wordRangeWithWord:nearestWord];
        NSInteger nearestWordLineNumber = [_pageInterpreter.page lineNumberFromWordRange:wordRange];
        
        // Specific case of the arabic
        BOOL rtl = [self isRTLLine:nearestWord];
        
        NSMutableArray *removedWords = [self computeImpactedWords:x nearestWord:nearestWord charIndex:charIndex rtlCase:rtl];
        BOOL isGestureInsideWord = charIndex > 0 && charIndex < nearestWord.selectedCandidate.length;
        
        // Add all the words from the line after the given index
        for (NSInteger i = nearestWordLineNumber + 1; i < [_pageInterpreter.page lineCount]; ++i)
            [removedWords addObjectsFromArray:[_pageInterpreter.page wordsAtLineNumber:i]];
        
        
        // Create the new words list
        NSMutableArray *addedWords = [self createNewWordsFrom:removedWords dx:0 dy:ITC_GUIDELINE_SPACING isInsideWord:isGestureInsideWord keepSpaceBefore:NO];
        
        // Create the sub-words from the nearest word if necessary
        if (isGestureInsideWord)
        {
            ITCSmartWord *smartWord = [_wordFactory createSubWord:nearestWord beginIndex:0 endIndex:charIndex spaceBefore:[nearestWord spaceBefore]];
            [addedWords addObject:smartWord];
            
            ITCSmartWord *tempWord = [_wordFactory createSubWord:nearestWord beginIndex:charIndex endIndex:[nearestWord charLabels].count spaceBefore:[nearestWord spaceBefore]];
            tempWord = [_wordFactory createMovedWord:tempWord offsetX:0 offsetY:ITC_GUIDELINE_SPACING spaceBefore:0];
            [addedWords addObject:tempWord];
            
            // Delete the old word
            [removedWords addObject:nearestWord];
        }
        
        // check if words do not get out of page view frame
        if ([_viewController checkWords:addedWords insideBoundsoffsetX:0 offsetY:ITC_GUIDELINE_SPACING])
        {
            // Replace the old words by the new words in the page.
            // Can also use "replaceWords:" instead of removeWords: + addWords:
            [_pageInterpreter.page removeWords:removedWords];
            [_pageInterpreter.page addWords:addedWords];
        }
    }];
}

- (void)singleTapGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes x:(float)x y:(float)y
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [_viewController showNotification:@"SingleTap Gesture"];
        
        // if default processing, do no manually handle the gesture
        if (![self gestureDataFromGestureType:ITCGestureTypeSingleTap].isDefaultProcessing)
        {
            // add an action on data formated word (phone number, url , email)
            {
                ITCWordRange *wordRange = [page wordRangeAtX:x y:y];
                
                if (wordRange && wordRange.words.count > 0)
                {
                    ITCSmartWord *word = [wordRange.words objectAtIndex:0];
                    if (word.strokes.count > 0)
                    {
                        ITCSmartStroke *stroke = [word.strokes objectAtIndex:0];
                        UserParamSample *userParam = (UserParamSample *)stroke.userParams;

                        NSString *dataFormatLabel = userParam.dataFormatLabel;
                        if (![dataFormatLabel isEqualToString:@""])
                        {
                            DataFormatType dataFormatType = [DataFormatRecognizer dataTypeFromString:dataFormatLabel];
                            
                            // url
                            if (dataFormatType == DataFormatTypeUrl)
                            {
                                NSString *urlString = [dataFormatLabel lowercaseString];
                                
                                // prepend 'http://' if not existing
                                NSRange rangeForHTTP = [urlString rangeOfString:@"http://"];
                                if (rangeForHTTP.location == NSNotFound || rangeForHTTP.location != 0)
                                {
                                    urlString = [NSString stringWithFormat:@"http://%@", urlString];
                                }
                                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                NSURL *url = [NSURL URLWithString:urlString];
                                [[UIApplication sharedApplication] openURL:url];
                            }
                            // mail
                            else if (dataFormatType == DataFormatTypeMail)
                            {
                                // get email
                                NSString *mail = dataFormatLabel;
                                
                                // get page content (as string)
                                NSString *textPage = _pageInterpreter.page.text;
                                textPage = [textPage stringByReplacingOccurrencesOfString:mail withString:@""];
                                
                                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                                mailViewController.mailComposeDelegate = self;
                                
                                // add recipient (to:)
                                [mailViewController setToRecipients:@[mail]];
                                // add message
                                [mailViewController setMessageBody:textPage isHTML:NO];
                                
                                // Show iPad menu (popover)
                                [_viewController presentViewController:mailViewController animated:YES completion:nil];
                            }
                            // phone
                            else if (dataFormatType == DataFormatTypePhoneNumber)
                            {
                                NSString *phone = dataFormatLabel;
                                ABRecordRef contact = [self findPersonFromPhoneNumber:phone];
                                
                                if (contact == nil)
                                {
                                    NSString *textPage = _pageInterpreter.page.text;
                                    textPage = [textPage stringByReplacingOccurrencesOfString:phone withString:@""];
                                    
                                    contact = ABPersonCreate();
                                    
                                    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
                                    ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(phone), kABPersonPhoneMobileLabel, NULL);
                                    
                                    // fill phone number
                                    ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumberMultiValue, nil); // set the phone number property
                                    
                                    // fill fake info. Need it to create the contact
                                    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(textPage), nil); // his last name
                                    
                                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                                    ABAddressBookAddRecord(addressBook, contact, nil); //add the new person to the record
                                    
                                    ABAddressBookSave(addressBook, nil); //save the record
                                    
                                    // free contact
                                    CFRelease(contact);
                                    
                                    // reload the contact
                                    contact = [self findPersonFromPhoneNumber:phone];
                                }
                                
                                if (contact != nil)
                                {
                                    _personView = [[ABPersonViewController alloc] init];
                                    _personView.displayedPerson    = contact;
                                    _personView.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                                                      [NSNumber numberWithInt:kABPersonEmailProperty],
                                                                      [NSNumber numberWithInt:kABPersonBirthdayProperty], [NSNumber numberWithInt:kABPersonAddressProperty],nil];
                                    _personView.allowsActions = YES;
                                    
                                    [_viewController.navigationController pushViewController:_personView animated:YES];
                                }
                            }
                            
                            return;
                        }
                        else
                        {
                            [self openSearchWithKey:word.selectedCandidate];
                        }
                    }
                    else
                    {
                        [self openSearchWithKey:word.selectedCandidate];
                    }
                }
            }
        }
    }];
}

- (void)selectionGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes wordRange:(ITCWordRange *)wordRange
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [_viewController showNotification:@"Selection Gesture"];
        
        // if default processing, do no manually handle the gesture
        if (![self gestureDataFromGestureType:ITCGestureTypeSelection].isDefaultProcessing)
        {
            [_viewController.displayViewController createSelectionForWordRange:wordRange];
        }
        
        
    }];
}

- (void)underlineGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray *)gestureStrokes wordRange:(ITCWordRange *)wordRange
{
    // need to be in UI thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // if default processing, do manually handle the gesture
        if (![self gestureDataFromGestureType:ITCGestureTypeUnderline].isDefaultProcessing)
        {
            // create a underline line under each words
            for (ITCSmartWord *itcSmartWord in wordRange.words)
            {
                NSArray *strokes = [itcSmartWord strokes];
                BOOL isWholeWordUndeline = NO;
                for (ITCSmartStroke *stroke in strokes)
                {
                    UserParamSample *userParam = (UserParamSample *)[stroke userParams];
                    if (userParam.isUnderline)
                    {
                        isWholeWordUndeline = YES;
                        break;
                    }
                }
                if (!isWholeWordUndeline)
                    [_viewController.displayViewController addUnderlineToSmartWord:itcSmartWord];
                else
                    [_viewController.displayViewController removeUnderlineToSmartWord:itcSmartWord];
            }
        }
    }];
}


//----------------------------------
#pragma mark MailCompose delegate
//----------------------------------

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // remove MailComposeViewController
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//----------------------------------
#pragma mark Utils
//----------------------------------

- (NSMutableArray*)createNewWordsFrom:(NSMutableArray*)oldWords dx:(CGFloat)dx dy:(CGFloat)dy isInsideWord:(BOOL)isGestureInsideWord keepSpaceBefore:(BOOL)keepSpaceBefore
{
    NSMutableArray *addedWords = [NSMutableArray array];
    // Start creating moved word from removed word list
    for (int i = 0; i < oldWords.count; i++)
    {
        ITCSmartWord *removedWord = [oldWords objectAtIndex:i];
        
        ITCSmartWord *movedWord;
        if (!isGestureInsideWord && i == 0 && keepSpaceBefore)
            movedWord = [_wordFactory createMovedWord:removedWord offsetX:dx offsetY:dy spaceBefore:[removedWord spaceBefore]+1];
        else if (!isGestureInsideWord && i == 0)
            movedWord = [_wordFactory createMovedWord:removedWord offsetX:dx offsetY:dy spaceBefore:0];
        else
            movedWord = [_wordFactory createMovedWord:removedWord offsetX:dx offsetY:dy spaceBefore:[removedWord spaceBefore]];
        
        [addedWords addObject:movedWord];
    }
    return addedWords;
}

- (NSMutableArray*)computeImpactedWords:(CGFloat)x nearestWord:(ITCSmartWord*)nearestWord charIndex:(NSInteger)charIndex rtlCase:(BOOL)isRTL
{
    // Get the nearest word line number
    ITCWordRange *wordRange = [ITCWordRange wordRangeWithWord:nearestWord];
    
    NSInteger nearestWordLineNumber = [_pageInterpreter.page lineNumberFromWordRange:wordRange];
    
    // Get the words at the same line
    NSArray *lineWords = [_pageInterpreter.page wordsAtLineNumber:nearestWordLineNumber];
    
    
    // Compute the list of word impacted by the gesture according to the current orientation
    NSMutableArray *removedWords = [NSMutableArray arrayWithCapacity:lineWords.count];
    float nearestWordLeftBound = [nearestWord leftBound];
    float nearestWordRightBound = [nearestWord rightBound];
    
    
    for (ITCSmartWord *lineWord in lineWords)
    {
        if ( ([lineWord boundingRect].x > nearestWordLeftBound && !isRTL)
            || ([lineWord boundingRect].x + [lineWord boundingRect].width < nearestWordRightBound && isRTL) )
        {
            [removedWords addObject:lineWord];
        }
    }
    
    // Insert the nearest word in the impacted word list if necessary
    // Also check for inside word gesture
    BOOL isGestureInsideWord = NO;
    if (charIndex == 0)
    {
        if (!isRTL)
            [removedWords insertObject:nearestWord atIndex:0];
    }
    else if (charIndex != [nearestWord selectedCandidate].length)
        isGestureInsideWord = YES;
    
    // Add automatically the word at the left of the gesture in arabic
    if (isRTL && nearestWordLeftBound < x && !isGestureInsideWord)
    {
        [removedWords insertObject:nearestWord atIndex:0];
    }
    
    return removedWords;
}

- (BOOL)isRTLLine:(ITCSmartWord*)nearestWord
{
    return  [nearestWord.locale isEqualToString:@"ar"] ||
    [nearestWord.locale isEqualToString:@"fa_IR"] ||
    [nearestWord.locale isEqualToString:@"he_IL"] ||
    [nearestWord.locale isEqualToString:@"ur_PK"];
}


- (BOOL)isRTLAlignmentForString:(NSString *)aString
{
    if (aString.length)
    {
        NSArray *rightLeftLanguages = @[@"ar",@"he"];
        
        NSString *lang = CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)aString,CFRangeMake(0,[aString length])));
        
        if ([rightLeftLanguages containsObject:lang])
        {            
            return YES;
        }
    }
    
    return NO;
}

- (void)openSearchWithKey:(NSString *)key
{
    key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", key];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}


@end
