//
//  MultiLineViewController.h
//  MultiLineTextWidget
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "MLTWMultiLineEnums.h"
#import "MLTWMultiLineViewDelegate.h"
#import "MLTWWord.h"
#import <UIKit/UIKit.h>

/**
 *  This class is reponsible for all the calls to the widget. It describes the public API of the
 * multi line text widget.
 *
 *  It's a subview, so you must add it to the layout via `[myView addSubView:MLTWMultiLineView]` or
 * a storyboard.
 */
@interface MLTWMultiLineView : UIView

#pragma mark - Delegate

/** @name Getting and Setting the Delegate */

/**
 * The receiver’s delegate or nil if it doesn’t have a delegate.
 *
 * See MLTWMultiLineViewDelegate for the methods this delegate can implement.
 */
@property (weak, nonatomic) id <MLTWMultiLineViewDelegate> delegate;

#pragma mark - Configuration

/** @name Launching The Widget Configuration */

/**
 *  Configures the handwriting recognition engine.
 *
 *  This function is non-blocking and returns immediately. Configuration is a lengthy
 * process that may take up to several seconds, depending on the handwriting resources to be
 * configured. It is recommended to setup the delegate to detect the end of the
 * configuration
 * process. The configure method is the first one to be called before any action on the widget.
 * A notification will be sent through the delegate. If valid configuration
 *`multiLineViewDidEndConfiguration:` or `multiLineView:didFailConfigurationWithError` if error
 * during the configuration.
 *
 *  @param locale               String representation of the handwriting recognition locale.
 *  @param resources            Array of paths (NSString) to handwriting resource files.
 *  @param lexicon              Array of user lexicon entries. May be `nil`.
 *  @param certificate          Data containing the handwriting recognition certificate.
 *  @param dpi                  The coordinate resolution in dot per inch.
 *
 */
- (void)configureWithLocale:(NSString *)locale
                  resources:(NSArray *)resources
                    lexicon:(NSArray *)lexicon
                certificate:(NSData *)certificate
                    density:(float)dpi;

#pragma mark - Clear

/** @name Clear Text */

/**
 *  Clears the page from all words. Be careful as this will erase everything.
 */
- (void)clear;

#pragma mark - Text

/** @name Managing The Text */

/**
 * The text of the full page.
 * Updated just before the call to [delegate multiLineView:didChangeText:intermediate:]
 */
@property (strong, nonatomic, readonly) NSString *text;

#pragma mark - Gestures

/** @name Handling The Gestures */

/**
 * Enables or disables a gesture (see `MLTWGestureType`).
 *
 * Enables/disables the management of a given gesture. By default all gestures are
 * enabled. Detected gestures will trigger a call to the gesture delegate's method except for
 *`MLTWGestureType.MLTWGestureTypeErase` and `MLTWGestureType.MLTWGestureTypeOverwrite` that are
 * managed internally by the widget and thus don't trigger any delegate's methods to the top-level
 * application.
 *
 *  @param gesture the gesture to enable or disable. The list of gestures can be found in
 * `MLTWGestureType` enum
 *  @param enable `YES` to enable the gesture, `NO` otherwise
 */
- (void)setGesture:(MLTWGestureType)gesture enable:(BOOL)enable;

/**
 *
 *  @return YES if the gesture is enabled, NO otherwise.
 *   By default all gestures are enabled.
 *  @param gesture The list of gestures can be found in  `MLTWGestureType` enum
 */
- (BOOL)isGestureEnable:(MLTWGestureType)gesture;

#pragma mark - Ink Properties

/** @name Configuring Ink Properties */

/**
 * Sets the width of the ink in pixels.
 *
 * The default value is `5.0`.
 */
@property (assign, nonatomic) CGFloat inkThickness;

/**
 * Sets the color of the ink used for no-highlight state, else use (`inkColorHighlight`)
 *
 * The no-highlight state is used for previously written words.
 * The default value `[UIColor blackColor]`.
 */
@property (strong, nonatomic) UIColor *inkColor;

/**
 * Sets the color of the ink used for highlight state, else use (`inkColor`)
 *
 * The highlight state is used for the selected word or the current drawing.
 * The default value `[UIColor blueColor]`.
 */
@property (strong, nonatomic) UIColor *inkColorHighlight;

#pragma mark - Insertion zone

/** @name Configuring Insertion Zone */

/**
 * Sets the color of the insert zone.
 *
 * The alpha is managed by the widget (0.15 for the background, 1.0 for the baseline).
 * The default value is blue : `[UIColor colorWithRed:39 / 255.0f green:169 / 255.0f blue:225 /
 * 255.0f alpha:1.0f]`.
 */
@property (strong, nonatomic) UIColor *insertZoneColor;

#pragma mark - Input View

/** @name Configuring Input View */

/**
 * Sets the background color of the input view.
 *
 * The default value is `[UIColor whiteColor]`.
 */
@property (strong, nonatomic) UIColor *inputViewBackgroundColor;

/**
 * Sets the background image of the input view. The image is stretched according to the
 * inputViewHeight.
 *
 * The default value is `nil`. Not used if not set.
 */
@property (strong, nonatomic) UIImage *inputViewBackgroundImage;

/**
 * Sets the height of the widget input view. The input view is made of the view capturing the ink as
 * well as the one displaying the strokes/text.
 *
 * The value is in pixels
 */
@property (nonatomic, assign) CGFloat inputViewHeight;

#pragma mark - Scrolling

/** @name Configuring Scrolling */

/**
 * Sets the background color of the scroll view.
 *
 * The default value is `[UIColor clear]`.
 */
@property (strong, nonatomic) UIColor *scrollBackgroundColor;

/**
 * Sets the background image of the scroll view. The image will be repeated as many times as needed
 * to
 * cover the full size of the scroll view.
 *
 * The default value is `nil`. Not used if not set.
 */
@property (strong, nonatomic) UIImage *scrollBackgroundImage;

#pragma mark - Scrolling position

/**
 * Moves the scrolled position of the widget around the given word, so that it is at the top of the
 * widget.
 *
 * If word is `nil` the widget will scroll to the top of the view.
 *
 * @param word The word to scroll to.
 */
- (void)scrollWordToTop:(MLTWWord *)word;

/**
 * Moves the scrolled position of the widget around the given word, so that it is centered inside
 * the
 * widget.
 *
 * If word is `nil` the widget will not scroll.
 *
 * @param word The word to scroll to.
 */
- (void)scrollWordToCenter:(MLTWWord *)word;

/**
 * Sets the auto scroll ratio. This is the ratio of the widget height that needs to be filled
 * with text before the widget scrolls down. The default value is 0.6.
 *
 * The ratio value must be between 0. and 1.
 */
@property (nonatomic, assign) CGFloat autoScrollRatio;

/**
 * Disable the auto scroll used in writing mode which put the last word at the top of the page. This
 * enable the user to write without scrolling himself.
 *
 * Do not disable auto scroll notification after a `scrollWordToTop:` or a `scrollWordToCenter:`.
 * Default value is `NO`
 */
@property (nonatomic, assign, getter = isAutoScrollDisabled) BOOL autoScrollDisabled;

#pragma mark - Mode

/** @name Configuring Mode */

/**
 * Changes the widget edition mode to `MLTWMultilineModeInsertion` by creating writing space at the
 * given index.
 *
 * Insertion mode is defined so that the user can write inside already written text. Therefore, no
 * automatic scroll is triggered and the space created is highlighted. A large
 * space is created before or after the word, pushing the following words on the next line of the
 * widget.
 *
 * @param word The reference word related of the insertion mode.
 * @param characterIndex The index of the character related to the insertion mode. If the
 * characterIndex
 * is `< 0`, the insertion mode will be opened before the word. If >= word.text.length, the
 * insertion mode will be
 * opened after
 * the word. For any other value the insertion mode will be opened inside the word.
 */
- (void)setInsertionMode:(MLTWWord *)word atIndex:(NSInteger)characterIndex;

/**
 * Changes the widget edition mode to `MLTWMultilineModeCorrection` by selecting the given word.
 * Correction mode is defined so that the user can correct words. Therefore, there is always
 * a selected
 * and highlighted word around which the input view is automatically centered.
 *
 * @param word The word to select. If the word is invalid, the selection will be cleared.
 */
- (void)setCorrectionMode:(MLTWWord *)word;

/**
 * Changes the widget edition mode to `MLTWMultilineModeWriting`.
 *
 * Writing mode is defined for the user to input text continuously at the end of the widget.
 * Therefore, if the auto-scroll ratio is matched, the input view automatically scrolls down after
 * the user writing. No word is highlighted in the widget but the last written word is always
 * automatically selected.
 *
 */
- (void)setWritingMode;

#pragma mark - Word

/** @name Word Management */

/**
 * Replaces a word in the text.
 * This function will do nothing if :
 * The given word is nil or is not part of the widget text.
 * The given text is nil or is not one of the word candidates.
 * This function fire the delegate's method `multiLineView:didChangeText:`
 *
 * @param word The word to change
 * @param newText The replacement text string. The text has to be one of the word's candidates.
 */
- (void)replaceWord:(MLTWWord *)word withNewText:(NSString *)newText;

/**
 * Retrieves all words of the widget. The output is a list of words, each containing the possible
 * candidates.
 *
 * @return A list of `MLTWWord`.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *words;

#pragma mark - Serialization

/** @name Managing Serialization */

/**
 * Serializes the widget content into a NSData;
 *
 * @return A NSData representing the widget content model.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *save;

/**
 * Deserializes the given byte array into the widget content. This will trigger a
 * `multiLineView:didChangeText:` event. A `clear` will be triggered before the loading if
 * the model is not nil.
 *
 * @param model A NSData representing the widget content model.
 */
- (void)load:(NSData *)model;

#pragma mark Space

/** @name Managing Space */

/**
 * Adds a space at the word index.
 *
 * Create writing space at the given index to enable the user to write inside already
 * written text. The application provides an index where a space is created.
 * If the index is inside a word, the word is split in two by creating a small space (character
 * width). Nothing else will be done otherwise.
 *
 * @param word The word related to the space creation.
 * @param characterIndex The character index related to the space creation point inside the word. If
 * the characterIndex
 * is `< 0`, a space before the word will be added. If >= word.text.length, a space after the word
 * will be
 * added. For any other a space inside the word will be added.
 */
- (void)addSpaceWithWord:(MLTWWord *)word atIndex:(NSInteger)characterIndex;

/**
 * Removes a space at the word index.
 *
 * Removes writing space at the given index by joining the surrounding words. The
 * application provides an index where a space is removed. If there is no space at the given
 * index, nothing happens.
 *
 * @param word The word related to the space removal.
 * @param characterIndex The character index related to the space removal. If the characterIndex
 * is `< 0`, the space before the word will be removed. If >= word.text.length, the space after
 * the word will be
 * removed. For any other value nothing will be done.
 */
- (void)removeSpaceWithWord:(MLTWWord *)word atIndex:(NSInteger)characterIndex;

/**
 * Inserts a line break at the given index.
 *
 * @param word The reference word of the line break insertion.
 * @param characterIndex Character index related to the line break insertion. If the characterIndex
 * is `< 0`, a line break before the word will be added. If >= word.text.length, a line break
 *after
 * the word will
 * be
 * added. For any other a line break inside the word will be added.
 */
- (void)addLineBreakForWord:(MLTWWord *)word atIndex:(NSInteger)characterIndex;

#pragma mark - Reflow

/** @name Launch a Reflow */

/**
 * Moves all the words in the page to optimize the vertical writing space. Words will be reordered
 * in
 * lines in a way that removes all unused spaces.
 */
- (void)reflow;

#pragma mark - Guidelines

/** @name Configuring Guidelines */

/**
 * Sets the spacing between guidelines.
 * The guidelines are real lines drawn on the page for a better writing. If followed, the
 * recognition will work better. Can also be used to help the
 * user with the possible gestures.
 * The value cannot be < 0 && > inputViewHeight. The default value is `100`.
 */
@property (nonatomic, assign) CGFloat guidelinesHeight;

/**
 * Sets the spacing of the first guideline.
 *
 * The value cannot be < 0 && > inputViewHeight. The default value is `150`.
 */
@property (nonatomic, assign) CGFloat guidelineFirstPosition;

/**
 * Sets the guidelines color.
 *
 * The default value is `[UIColor colorWithWhite:0 alpha:0.6]`.
 */
@property (nonatomic, strong) UIColor *guidelinesColor;

/**
 * Sets the guidelines thickness.
 *
 * The default value is `1.0`.
 */
@property (nonatomic, assign) CGFloat guidelinesThickness;

#pragma mark - Export

/** @name Export */

/**
 * Retrieves the content of the widget as a UIImage.
 *
 * @param background `YES` the current background will also be exported.
 * @param exactHeight `YES` the UIImage will be sized to fit exactly the contained stroke or text.
 * Otherwise it will have the full size of the input view (set via setInputViewHeight: )
 *
 * @return A UIImage representing the widget content.
 */
- (UIImage *)exportAsImageWithBackground:(BOOL)background exactHeight:(BOOL)exactHeight;

#pragma mark - Utils

/** @name Utils */

/**
 * Checks if the widget contains any word/strokes.
 *
 * @return `YES` if the widget does not contain any words.
 */
@property (NS_NONATOMIC_IOSONLY, getter=isEmptyPage, readonly) BOOL emptyPage;

#pragma mark - Version

/** @name Version */

/**
 * The current version of MultiLineTextWidget
 * @return The current version of MultiLineTextWidget
 */
+ (NSString *)versionString;

@end