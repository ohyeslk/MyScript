// Copyright MyScript.

#import <UIKit/UIKit.h>

#import <AtkScw/SCWSingleCharViewDelegate.h>

/**
 * Class SCWCandidateInfo.
 */
@class SCWCandidateInfo;

/**
 * Interface SCWSingleCharView.
 */
@interface SCWSingleCharView : UIView

// ----------------------------------------------------------------------
#pragma mark - Properties
// ----------------------------------------------------------------------

@property (nonatomic, weak) id <SCWSingleCharViewDelegate> delegate;

/**
 * Set the color of the ink.
 */
@property (nonatomic, readwrite) UIColor *inkColor;

/**
 * Set the width of the ink.
 */
@property (nonatomic, readwrite) CGFloat inkWidth;

/**
 * Set the delay after which strokes start fading out.
 */
@property (nonatomic, readwrite) NSTimeInterval inkFadeOutDelay;

/**
 * Set the duration of the strokes fade-out animation.
 */
@property (nonatomic, readwrite) NSTimeInterval inkFadeOutDuration;

/**
 * Enable or disable handwriting recognition completion.
 * <p>
 * Handwriting recognition must be configured again for this
 * setting to take effect. Note that enabling handwriting
 * recognition completion significantly slows down handwriting
 * recognition. This feature is disabled by default.
 *
 * completionEnabled Enable handwriting recognition completion
 * if <code>YES</code>, disable if <code>NO</code>.
 */
@property (nonatomic, readwrite) BOOL completionEnabled;

/**
 * Enable/disable handwriting gestures recognition.
 * <p>
 * Handwriting recognition must be configured again for this
 * setting to take effect.
 *
 * gesturesEnabled Enable gestures if <code>YES</code>, disable
 * if <code>NO</code>.
 */
@property (nonatomic, readwrite) BOOL gesturesEnabled;

/**
 * Set speed/quality compromise of the handwriting recognition engine.
 * <p>
 * Handwriting recognition must be configured again for this
 * setting to take effect.
 *
 * speedQualityCompromise Speed/quality compromise rating.
 */
@property (nonatomic, readwrite) int speedQualityCompromise;

/**
 * Set user lexicon (array of words) for handwriting recognition.
 * <p>
 * Handwriting recognition must be configured again for this
 * setting to take effect.
 *
 * userLexicon User lexicon.
 */
@property (nonatomic, readwrite) NSArray *userLexicon;

/**
 * Set maximum size of the handwriting resources cache.
 *
 * maxResourcesSize Maximum size of the cache in bytes.
 */
@property (nonatomic, readwrite) unsigned long long maxResourcesSize;

/**
 * Set the delay after which handwriting recognition starts
 * for the character being written (in isolated mode).
 *
 * autoCommitDelay Auto-commit delay in seconds.
 */
@property (nonatomic, readwrite) NSTimeInterval autoCommitDelay;

/**
 * Set the delay after which strokes are automatically frozen.
 *
 * autoFreezeDelay Auto-freeze delay in seconds.
 */
@property (nonatomic, readwrite) NSTimeInterval autoFreezeDelay;

/**
 * Set the maximum number of word candidates.
 * <p>
 * Handwriting recognition must be configured again for this
 * setting to take effect.
 *
 * maxWordCandidates Maximum number of word candidates.
 */
@property (nonatomic, readwrite) int maxWordCandidates;

// ----------------------------------------------------------------------
#pragma mark - Text management
// ----------------------------------------------------------------------

/**
 * Clear ink and text contained in the widget.
 * <p>
 * This function does not call the text changed callback after the text
 * has been updated.
 */
- (void)clear;

/**
 * Set the text managed by this widget.
 * <p>
 * This function calls the text changed callback synchronously after
 * the text has been updated.
 *
 * @param text NSString representation of the text (may be <code>nil</code>).
 */
- (void)setText:(NSString*)text;

/**
 * Returns the text managed by this widget.
 * @return Representation of the text.
 */
- (NSString*)text;

/**
 * Replace characters in the text.
 * <p>
 * This function can be used to select an alternate handwriting
 * recognition candidate for any word or character. The specified
 * character range shall span a word or a single character, and the
 * provided replacement text shall be one of the possible candidates
 * to trigger a word or character candidate change.
 * <p>
 * Characters may be inserted at any location in the text by calling
 * this function with the same start and end character indices and a
 * non-empty replacement string.
 * <p>
 * Characters may be deleted from the text by calling this function
 * with a non-empty characters range and an empty or <code>nil</code>
 * replacement string.
 * <p>
 * This function calls the text changed callback synchronously
 * after characters have been replaced.
 *
 * @param range NSRange of character index of the first character to the last character to replace.
 * @param text Replacement text NSString (may be <code>nil</code>).
 *
 * @see getWordCandidatesAtIndex:
 * @see getCharacterCandidatesAtIndex:
 */
- (void)replaceCharactersInRange:(NSRange)range withText:(NSString*)text;

// ----------------------------------------------------------------------
#pragma mark - Candidates
// ----------------------------------------------------------------------

/**
 * Returns alternate candidate information for the word at
 * specified index.
 * <p>
 * This function computes the character range of the word at specified
 * index, and provides alternate candidates and possible completions.
 * <p>
 * Alternate candidates can be selected by calling the
 * replaceCharactersInRange:withText: function with
 * parameters from the candidate information.
 *
 * @param index Character index within or before the word.
 * @return Candidate information for the word at specified index
 * or <code>nil</code> if index is out of bounds.
 *
 * @see SCWCandidateInfo
 */
- (SCWCandidateInfo*)getWordCandidatesAtIndex:(NSUInteger)index;

/**
 * Returns alternate candidate information for the character at
 * specified index.
 * <p>
 * Alternate candidates can be selected by calling the
 * replaceCharactersInRange:withText: function with
 * parameters from the candidate information.
 *
 * @param index of the specified character.
 * @return Candidate information for the character at specified index
 * or <code>nil</code> if index is out of bounds.
 *
 * @see SCWCandidateInfo
 */
- (SCWCandidateInfo*)getCharacterCandidatesAtIndex:(NSUInteger)index;

// ----------------------------------------------------------------------
#pragma mark - Insertion point
// ----------------------------------------------------------------------

/**
 * Set the index of the insertion point.
 * @param index Character index of the insertion point.
 */
- (void)setInsertIndex:(NSUInteger)index;

/**
 * Returns the index of the insertion point.
 * @return Character index of the insertion point.
 */
- (NSUInteger)insertIndex;

// ----------------------------------------------------------------------
#pragma mark - Configuration
// ----------------------------------------------------------------------

/**
 * Configure the handwriting recognition engine to use the MyScript
 * Builder engine running on the device.
 * <p>
 * This function is non-blocking and returns immediately.
 * <p>
 * Configuration is a lengthy process that may take up to several
 * seconds, depending on the handwriting resources to be configured.
 * It is recommended to setup a configuration listener to detect the end
 * of the configuration process.
 *
 * @param language NSString Handwriting recognition language (locale).
 * @param resources Array of paths to handwriting resource files.
 * @param certificate Byte array containing the handwriting recognition
 * certificate.
 */
- (void)configureWithLanguage:(NSString *)language resources:(NSArray *)resources certificate:(NSData *)certificate;

/**
 * Return an error code describing the error that happened during the
 * configuration, if any.
 *
 * @return Error code describing the error or 0 if no error.
 */
- (int)errorCode;

/**
 * Return a string describing the error that happened during the
 * configuration, if any.
 *
 * @return String describing the error.
 */
- (NSString*)errorString;

// ----------------------------------------------------------------------
#pragma mark - Error codes
// ----------------------------------------------------------------------

/* Single Character Widget error codes. */
enum SCWSingleCharWidgetError {
    /* No error. */
    SCWSingleCharWidgetSuccess = 0,
    /* Invalid certificate. */
    SCWSingleCharWidgetErrorInvalidCertificate = 1,
    /* Invalid API key. */
    SCWSingleCharWidgetErrorInvalidApiKey = 2,
    /* Cannot load handwriting resource. */
    SCWSingleCharWidgetErrorCannotLoadResource = 3,
    /* Cannot create user lexicon resource. */
    SCWSingleCharWidgetCannotCreateUserLexiconResource = 4,
    /* Error setting internal property. */
    SCWSingleCharWidgetErrorSetProperty = 5,
};

@end

