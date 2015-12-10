// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

/**
 * The different error codes
 */
typedef NS_ENUM(NSInteger, ITCErrorCode)
{
  /** No error. */
  NoError = 0,
  /** Recognition engine cannot be loaded. */
  CannotLoadEngine,
  /** Recognition engine cannot be initialized. */
  CannotInitializeEngine,
  /** Missing recognition engine certificate. */
  MissingCertificate,
  /** Configuration has not been set. */
  MissingConfig,
  /** Configuration is unsuitable to this input method. */
  UnsuitableConfig,
  /** Resource file cannot be opened. */
  CannotLoadRes,
  /** Missing alphabet knowledge resource. */
  MissingAkRes,
  /** Alphabet knowledge resource is unsuitable for this input method. */
  UnsuitableAkRes,
  /** Malformed input. */
  MalformedInput,
  /** Recognition thread cannot be started. */
  CannotStartThread,
  
  // ITC-specific errors take values from 100 onwards
  
  /** Configuration not started */
  NotConfigured = 100,
  /** Set a wrong (<0) guidelines line count */
  WrongGuidelinesNumber,
  /** The configuration cannot be restored */
  ConfigurationCannotBeRestored,
  /** The configuration cannot be released */
  ConfigurationCannotBeReleased,
  /** The maximum page interpreter configured is 8. Above, this error will be fired. */
  PageInterpreterOverflow,
  /** A file already exists at path. */
  FileAlreadyExists,
  /** Failed to write the file. */
  FailedToWriteTheFile,
  
  /** General Error */
  NilParameter = 1000
};

/**
 *  This class describes the errors that ITC can post.
 */
@interface ITCError : NSObject

/**
 *  The code error.
 */
@property (nonatomic, assign) ITCErrorCode codeError;

/**
 *  The message error
 */
@property (nonatomic, strong) NSString *messageError;

/**
 *  Creates a new ITCError with the code and the message error
 */
- (id)initWithCode:(ITCErrorCode)code message:(NSString *)message;

@end
