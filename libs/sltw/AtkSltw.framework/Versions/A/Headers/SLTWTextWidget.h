// Copyright MyScript. All rights reserved.

#import "SLTWTextWidgetDelegate.h"

//================================================================================
#pragma mark - Interface
//================================================================================

@class SLTWTextWidgetPrivate;

@interface SLTWTextWidget : UIViewController
{
  SLTWTextWidgetPrivate *_viewController;
}

//================================================================================
#pragma mark - Properties
//================================================================================

@property (nonatomic, weak)   id <SLTWTextWidgetDelegate>   delegate;

//================================================================================
#pragma mark - Initialization
//================================================================================

- (id)init;

//================================================================================
#pragma mark - Text management
//================================================================================

/**
 * Set the text displayed and managed by this widget.
 * <p>
 * This function calls the text changed delegate synchronously after the
 * text has been updated.
 *
 * @param text String representation of the text.
 */
- (void)setText:(NSString *)text;

/**
 * Get the text displayed and managed by this widget.
 *
 * @return text String representation of the text.
 */
- (NSString *)text;

/**
 * Clear the widget.
 */
- (void)clear;

/**
 * Replace characters in the text.
 * <p>
 * This method can be used to perform one of the following actions:
 * <ol>
 *  <li>Add a space character at any location in the text</li>
 *  <li>Delete any part of the text</li>
 *  <li>Replace a part of the text by selecting an alternate word candidate</li>
 * </ol>
 * <p>
 * A space character may be inserted at any location in the text by calling
 * this function with the same start and end character indices and a
 * replacement string containing a single space character.
 * <p>
 * Characters may be deleted from the text by calling this function
 * with a non-empty characters range and an empty or <code>nil</code>
 * replacement string.
 * <p>
 * Text may be altered by selecting an alternate word candidate by calling
 * this function with a start and end character range spanning a word
 * and a replacement string that corresponds to one of the possible word
 * candidates (as reported by the delegate
 * textWidget:didSelectWordInRange:labels:selectedIndex:.
 * <p>
 * <b>Any other use of this method will do nothing.</b>
 * <p>
 * This function calls the text changed delegate synchronously
 * after characters have been replaced.
 *
 * @param range Range of characters indexes: the first character to replace 
 *              and one past the last character to replace.
 *
 * @param text Replacement text string (may be <code>nil</code>).
 *
 */
- (void)replaceCharactersInRange:(NSRange)range replacementString:(NSString *)text;

//================================================================================
#pragma mark - Scrolling management
//================================================================================

/**
 * Scroll the writing area to the given character index.
 * <p>
 * The widget defines invisible margins on each side of the screen that
 * determines whether a specific position is visible to the user or not.
 * <p>
 * The widget scrolls the writing area so that the given character
 * index is positioned on the boundary of the left scroll margin.
 * <p>
 * The widget does not scroll if it is already scrolled all the way
 * to the left or to the right and the requested character index is
 * visible. Also, the widget does not scroll if the requested character
 * index is already visible and is not inside the left or right scroll
 * margins.
 * <p>
 * The scroll operation is canceled and this method does nothing if the
 * user is currently scrolling the writing area.
 *
 * @param index Character index to scroll to.
 *
 */
- (void)scrollTo:(NSUInteger)index;

/**
 * Center the writing area around the given character index.
 * <p>
 * The widget scrolls the writing area so that the given character
 * index is located at the center of the screen, if possible.
 * <p>
 * The scroll operation is canceled and this method does nothing if the
 * user is currently scrolling the writing area.
 *
 * @param index Character index to put at the center of the screen.
 *
 */
- (void)centerTo:(NSUInteger)index;

//================================================================================
#pragma mark - Selection management
//================================================================================

/**
 * Select the word at the given index.
 *
 * @param index Character index to select the word.
 */
- (void)selectWordAtIndex:(NSUInteger)index;

//================================================================================
#pragma mark - Handwriting engine configuration
//================================================================================

/**
 * Configure the handwriting recognition engine.
 * <p>
 * This function is non-blocking and returns immediately.
 * <p>
 * Configuration is a lengthy process that may take up to several
 * seconds, depending on the handwriting resources to be configured.
 * It is recommended to implement configuration delegates to detect
 * the beginning and end of the configuration process.
 *
 * @param locale String representation of the handwriting recognition
 * locale.
 *
 * @param resources Array of paths to handwriting resource files.
 *
 * @param lexicon Array of user lexicon entries. May be <code>nil</code>.
 *
 * @param certificate Byte array containing the handwriting recognition
 * certificate.
 *
 */
- (void)configureWithLocale:(NSString *)locale
                  resources:(NSArray *)resources
                    lexicon:(NSArray *)lexicon
                certificate:(NSData *)certificate;

/**
 * Return an error status that happened during the configuration, if any.
 *
 * @return Boolean <code>NO</code> if no error, <code>YES</code> otherwise.
 */
- (BOOL)failed;

//================================================================================
#pragma mark - Settings
//================================================================================

/**
 * Set the widget height.
 * @param widgetHeight Height of the widget.
 */
- (void)setWidgetHeight:(CGFloat)widgetHeight;

/**
 * Set the font of the text.
 * @param textFont UIFont of the text.
 */
- (void)setTextFont:(UIFont *)textFont;

/**
 * Set the size of the text.
 * @param textSize Size of the text in CGFloat.
 */
- (void)setTextSize:(CGFloat)textSize;

/**
 * Set the range of possible text sizes used for automatic font size selection.
 * @param textSizes NSArray of possible text sizes. Revert to default range if <code>nil</code>.
 */
- (void)setTextSizes:(NSArray *)textSizes;

/**
 * Set the color of the text.
 * @param textColor UIColor of the text.
 * @param state UIControlState of the text.
 */
- (void)setTextColor:(UIColor *)textColor forState:(UIControlState)state;

/**
 * Set the width of the ink.
 * @param inkWidth Width of the ink in CGFloat.
 */
- (void)setInkWidth:(CGFloat)inkWidth;

/**
 * Set the color of the ink.
 * @param inkColor UIColor of the text.
 * @param state UIControlState of the text.
 */
- (void)setInkColor:(UIColor*)inkColor forState:(UIControlState)state;

/**
 * Set the background color of the writing area.
 * @param backgroundColor UIColor of the background.
 */
- (void)setWritingAreaBackgroundColor:(UIColor*)backgroundColor;

/**
 * Set the position of the baseline from the top of the writing area.
 * @param baselinePosition Position of the baseline in CGFloat.
 */
- (void)setBaselinePosition:(CGFloat)baselinePosition;

/**
 * Set the thickness of the baseline.
 * @param thickness Thickness of the baseline in CGFloat.
 */
- (void)setBaselineThickness:(CGFloat)baselineThickness;

/**
 * Set the color of the baseline.
 * @param baselineColor Color of the baseline.
 */
- (void)setBaselineColor:(UIColor*)baselineColor;

/**
 * Set the amount of content left on the screen after the widget has
 * automatically scrolled.
 *
 * @param autoScrollMargin Margin in CGFloat.
 *
 */
- (void)setAutoScrollMargin:(CGFloat)autoScrollMargin;

/**
 * Set whether the widget scrolls automatically.
 *
 * @param autoScrollEnabled <code>YES</code> if the widget shall scroll
 * automatically after a delay, <code>NO</code> otherwise.
 *
 */
- (void)setAutoScrollEnabled:(BOOL)autoScrollEnabled;

/**
 * Set the delay after which the writing area scrolls automatically once the
 * user has finished writing.
 * <p>
 * This is a convenience method.
 *
 * @param autoScrollDelay Delay in milliseconds.
 *
 */
- (void)setAutoScrollDelay:(NSTimeInterval)autoScrollDelay;

/**
 * Set parameters of the auto-scroll delay.
 * <p>
 * The writing area scrolls automatically after a delay once the user has
 * finished writing. This delay is computed from the nearly full/nearly empty
 * delay values provided to this function.
 * <p>
 * After each stroke, the widget computes the amount of visible space left
 * on the screen and available for writing. If the visible portion of the
 * writing area is nearly full, the widget will compute a scroll delay that
 * is close to the <code> autoScrollDelayWhenNearlyFull</code> value. If the visible portion
 * of the writing area is nearly empty, the widget will compute a scroll delay
 * that is close to the <code> autoScrollDelayWhenNearlyEmpty</code> value. In-between delay
 * values are computed if the visible portion of the writing area is half full.
 * <p>
 * Typically, leaving delays as their default values, the widget scrolls the
 * writing area automatically after a long delay if there is a lot of space
 * available for writing. The widget scrolls the writing area automatically
 * after a short delay if there is little space available for writing.
 *
 * @param autoScrollDelayWhenNearlyEmpty Delay in milliseconds applied when the visible
 * portion of the writing area is nearly empty.
 *
 * @param autoScrollDelayWhenNearlyFull Delay in milliseconds applied when the visible
 * portion of the writing area is nearly full.
 *
 */
- (void)setAutoScrollDelayWhenNearlyEmpty:(NSTimeInterval)autoScrollDelayWhenNearlyEmpty
                      delayWhenNearlyFull:(NSTimeInterval)autoScrollDelayWhenNearlyFull;

/**
 * Set whether the widget typesets ink automatically.
 *
 * @param autoTypesetEnabled <code>YES</code> if the widget shall typeset
 * (turn ink into characters) automatically after a delay,
 * <code>NO</code> otherwise.
 *
 */
- (void)setAutoTypesetEnabled:(BOOL)autoTypesetEnabled;

/**
 * Set delay after which the widget typesets ink automatically.
 * <p>
 * This is a convenience method.
 *
 * @param autoTypesetDelay Delay in milliseconds.
 *
 */
- (void)setAutoTypesetDelay:(NSTimeInterval)autoTypesetDelay;

/**
 * Set parameters of the auto-typeset delay.
 * <p>
 * The widget turns ink into characters (typesets) automatically after a delay
 * once the user has finished writing. This delay is computed from the
 * nearly full/nearly empty delay values provided to this function.
 * <p>
 * After each stroke, the widget computes the amount of visible space left
 * on the screen and available for writing. If the visible portion of the
 * writing area is nearly full, the widget will compute a typeset delay that
 * is close to the <code> autoTypesetDelayWhenNearlyFull</code> value. If the visible portion
 * of the writing area is nearly empty, the widget will compute a typeset delay
 * that is close to the <code> autoTypesetDelayWhenNearlyEmpty</code> value. In-between delay
 * values are computed if the visible portion of the writing area is half full.
 * <p>
 * Typically, leaving delays as their default values, the widget triggers
 * a typeset of the ink after a short delay if there is a lot of space available
 * for writing. The widget triggers a typeset of the ink after a long delay if
 * there is little space available for writing.
 *
 * @param autoTypesetDelayWhenNearlyEmpty Delay in milliseconds applied when the visible
 * portion of the writing area is nearly empty.
 *
 * @param autoTypesetDelayWhenNearlyFull Delay in milliseconds applied when the visible
 * portion of the writing area is nearly full.
 *
 */
- (void)setAutoTypesetDelayWhenNearlyEmpty:(NSTimeInterval)autoTypesetDelayWhenNearlyEmpty
                      delayWhenNearlyFull:(NSTimeInterval)autoTypesetDelayWhenNearlyFull;

/**
 * Set whether transient space is enabled.
 *
 * @param enabled <code>YES</code> to enable transient space, <code>NO</code> to disable.
 */
- (void)setTransientSpaceEnabled:(BOOL)enabled;

/**
 * Set whether the logs are displayed.
 *
 * @param enabled <code>NO</code> to not display the logs,
 * <code>YES</code> otherwise.
 */
- (void)setDebugEnabled:(BOOL)enabled;

//================================================================================
#pragma mark - Navigation bar
//================================================================================

/**
 * Hide the navigation bar.
 *
 * By default, the navigation bar is visible and scrolling is possible by swiping
 * the area of the navigation bar, scrolling is not possible from the writing area.
 *
 * When the navigation bar is hidden, the widget switches to 2-fingers scrolling
 * and scrolling is allowed from the anywhere within the surface of the widget.
 */
- (void)hideNavigationBar;

/**
 * Set the tiled image to be used as navigation scrollbar background.
 * @param image Background image of the navigation scrollbar.
 */
- (void)setNavigationBackgroundImage:(UIImage *)image;

/**
 * Set the image pattern of the navigation bar for the given control state.
 * Only state UIControlStateNormal and UIControlStateHighlighted are supported.
 * @param image Pattern image of the navigation bar.
 * @param state Control state that corresponds to the pattern image.
 */
- (void)setNavigationPatternImage:(UIImage *)image forState:(UIControlState)state;

/**
 * Set the image of the left arrow button for the given control state.
 * @param image Image of the left arrow button.
 * @param state Control state that correponds to the image.
 */
- (void)setArrowLeftImage:(UIImage *)image forState:(UIControlState)state;

/**
 * Set the image of the right arrow button for the given control state.
 * @param image Image of the right arrow button.
 * @param state Control state that correponds to the image.
 */
- (void)setArrowRightImage:(UIImage *)image forState:(UIControlState)state;

//================================================================================
#pragma mark - Miscellaneous
//================================================================================

/**
 * Cancel the ink capture
 */
- (void)cancelInkCapture;

@end
