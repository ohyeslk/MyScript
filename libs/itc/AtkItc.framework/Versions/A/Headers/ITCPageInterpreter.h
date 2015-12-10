// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCPageInterpreterDelegate.h"
#import "ITCSmartPage.h"

@class ITCError;

/**
 * Defines the type of a gesture.
 */
typedef NS_ENUM(NSInteger, ITCGestureType)
{
  /** No gesture */
  ITCGestureTypeNone = 0,
  /** Insert gesture */
  ITCGestureTypeInsert = 1,
  /** Join gesture */
  ITCGestureTypeJoin = 2,
  /** Erase gesture */
  ITCGestureTypeErase = 3,
  /** Overwrite gesture */
  ITCGestureTypeOverwrite = 4,
  /** Single tap gesture */
  ITCGestureTypeSingleTap = 5,
  /** Selection gesture */
  ITCGestureTypeSelection = 6,
  /** Underline gesture */
  ITCGestureTypeUnderline = 7,
  /** Return gesture */
  ITCGestureTypeReturn = 8
};

/**
 * Defines the level of the debug.
 */
typedef NS_ENUM(NSInteger, ITCDebugMode)
{
  /** No debug */
  ITCDebugModeNo = 0,
  /** ITC output debug */
  ITCDebugModeStd = 1,
  /** ITC and recognition debug */
  ITCDebugModeMax = 2
};

/**
 * The `ITCPageInterpreter` is the object in charge of configuration and the recognition of a page.
 * It can deal with only one page at a time.
 *
 * Do not inherit.
 */
@interface ITCPageInterpreter : NSObject

/** @name Delegate */

/**
 * The receiver’s delegate or `nil` if it doesn’t have a delegate.
 * @discussion See `ITCPageInterpreterDelegate` for the methods this delegate can implement.
 */
@property (nonatomic, weak) id<ITCPageInterpreterDelegate> delegate;

/** @name Managing debug */

/**
 * Set `YES` to save automatically ITF files in the document directory. By default the value is `NO`.
 * It saves a new file each time a stroke/word is added.
 * @discussion ITF files can be used to replay same recognition for debugging purpose.
 */
@property (nonatomic, assign) BOOL ITFDebug;

/**
 *  Enables or not the debug in ITC
 *  @param debugMode The level of debug you want
 */
+ (void)enableDebug:(ITCDebugMode)debugMode;

//==================================================================================================
#pragma mark - Creation
//==================================================================================================

/** @name Creation */

/**
 *  Creates a new ITCPageInterpreter.
 *  @return The new ITCPageInterpreter
 */
+ (ITCPageInterpreter*)pageInterpreter;

//==================================================================================================
#pragma mark - Configuration
//==================================================================================================

/** @name Configuration */

/**
 *  Configures the handwriting recognition engine.
 *
 *  This function is non-blocking and returns immediately. Configuration is a lengthy process that may take up to
 *  several seconds, depending on the handwriting resources to be configured. It is recommended to setup a configure
 * listener to detect the end of the configuration process.
 *
 *  @param locale               String representation of the handwriting recognition locale.
 *  @param resources            Array of paths to handwriting resource files.
 *  @param lexicon              Array of user lexicon entries. May be `nil`.
 *  @param certificate          Data containing the handwriting recognition certificate.
 *  @param dpi                  The coordinate resolution in dot per inch.
 *
 *  @return an ITCError
 */
- (ITCError *)configurePageInterpreter:(NSString*)aLocale
                                resources:(NSArray*)resources
                                  lexicon:(NSArray*)lexicon
                              certificate:(NSData*)aCertificate
                                  density:(float)dpi;

/**
 *  Configures the handwriting recognition engine.
 *  <p>
 *  This function is non-blocking and returns immediately. Configuration is a lengthy process that may take up to
 *  several seconds, depending on the handwriting resources to be configured. It is recommended to setup a configure
 * listener to detect the end of the configuration process.
 *
 *  @param locale               String representation of the handwriting recognition locale.
 *  @param resources            Array of paths to handwriting resource files.
 *  @param lexicon              Array of user lexicon entries. May be <code>null</code>.
 *  @param certificate          Byte array containing the handwriting recognition certificate.
 *  @param certificateByteCount Size of the byte array
 *  @param dpi                  The coordinate resolution in dot per inch.
 *  @param freezeTimeout The minimum freeze time before the launch of the recognition.
 *  It corresponds of the time between the last request and the launch of the recognition. Can be from 200 to 10000 ms. The default value is 650 ms.
 *
 *  @return an ITCError
 */
- (ITCError *)configurePageInterpreter:(NSString*)aLocale
                                resources:(NSArray*)resources
                                  lexicon:(NSArray*)lexicon
                              certificate:(NSData*)aCertificate
                                  density:(float)dpi
                            freezeTimeout:(NSInteger)freezeTimeout;

/**
 *  This function saves the configuration of the recognition.
 *
 *  @warning If you don't call `restoreConfigurationFromId:` after, there will be a memory leak.
 *  @return The id of the configuration backup.
 */
- (NSString*)saveConfiguration;

/**
 *  Restores the configuration from the given id.
 *
 *  @param anId The id referencing the configuration backup.
 *  @return An error if an error occured or nil.
 */
- (ITCError*)restoreConfigurationFromId:(NSString*)anId;

/**
 *  Gets the locale of the page interpreter.
 *  @return The current locale of the page interpreter.
 */
- (NSString*)locale;

//==================================================================================================
#pragma mark - Page management
//==================================================================================================

/** @name Page management */

/**
 * Sets the current page.
 * @discussion The behavior is not defined if the page is nil.
 */
- (void)setPage:(ITCSmartPage *)aSmartPage;

/**
 * Gets the current page.
 * @return An `ITCSmartPage` object representing the current page.
 */
- (ITCSmartPage *)page;

//==================================================================================================
#pragma mark - Error management
//==================================================================================================

/** @name Error management */

/**
 *  @return The error string of the last instruction concerning the configuration or the recognition.
 */
- (NSString *)recognitionErrorString;

/**
 *  @return The error associated to the last instruction concerning the configuration or the recognition.
 */
- (ITCError *)recognitionError;

//==================================================================================================
#pragma mark - Guidelines management
//==================================================================================================

/** @name Guidelines management */

/**
 *  Assigns the guidelines
 *
 *  @param firstLinePosition  The position of the first line
 *  @param gap                The gap between two lines
 *  @param lineCount          The number of lines displayed
 *
 *  @return a ITCError, nil if no error
 */
- (ITCError *)setGuidelines:(float)firstLinePosition gap:(float)gap lineCount:(NSInteger)lineCount;

/**
 *  Clears the guidelines
 */
- (void)clearGuidelines;

//==================================================================================================
#pragma mark - Gesture management
//==================================================================================================

/** @name Gesture management */

/**
 * Sets the processing for the current gesture. The default processing is the default mecanism
 * used to act according to the gesture. Else, it will be done in the implementation of
 * gestures notifications (see SmartPage->setGestureDelegate)
 *
 * @param gestureType       The current gesture (see ITCGestureType enum)
 * @param defaultProcessing `YES` if you want the page interpreter to handle default processing of the detected gesture, `NO` if you want the page interpreter to delegate gesture processing to the application.
 */
- (void)setGesture:(ITCGestureType)gestureType defaultProcessing:(BOOL)defaultProcessing;

/**
 * Enables or disables the current gesture
 * @param gestureType   The current gesture (see ITCGestureType enum)
 * @param enabled       `YES` if the gesture is enabled, `NO` otherwise
 */
- (void)setGesture:(ITCGestureType)gestureType enable:(BOOL)enabled;

/**
 * Checks if a gesture is currently enabled.
 * @param gestureType Gesture type.
 * @return `YES` if gesture detection is enabled, `NO` if disabled.
 */
- (BOOL)isGestureEnabled:(ITCGestureType)gestureType;

/**
 *  Setter to enable (`YES` by default) intermediate recognition
 *
 *  @param enableIntermediateRecognition `YES` to enable intermediate recognition, `NO` otherwise
 */
- (void)setEnableIntermediateRecognition:(BOOL)enableIntermediateRecognition;

//==================================================================================================
#pragma mark - Version
//==================================================================================================

/** @name Version */

+ (NSString*)version;

@end

