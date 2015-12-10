//
//  MAWSymbol.h
//  MathWidget
//
//  Copyright (c) 2013 MyScript. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A MAWSymbol represents a mathematical symbol that can be used for importing and exporting
 * equations. 
 *
 * See `[MAWMathViewController resultAsSymbolList]`, `[MAWMathViewController addSymbol:allowUndo:]`
 * and `[MAWMathViewController addSymbols:allowUndo:]`.
 */
@interface MAWSymbol : NSObject

/**
 * The symbol (UTF-8 encoded).
 */
@property (strong, nonatomic) NSString *label;

/**
 * The symbol bounding box.
 */
@property (assign, nonatomic) CGRect boundingBox;

/**
 * A boolean indicating if the Symbol is transitory. The transitory characters are added by the 
 * solver.
 *
 * @discussion Except in the case of a restoration, the value must always be `NO`.
 */
@property (assign, nonatomic) BOOL transitory;

#pragma mark - Initialization

/** @name Creating Symbols */

/**
 * Return a `MAWSymbol` initialized with the given label, boundingBox and transitory values.
 *
 * @param label A NSString containing the symbol, encoded using UTF-8.
 * @param boundingBox The frame of the Symbol
 * @param transitory A boolean indicating if the Symbol is transitory.
 * @return a MAWSymbol initialized with the given label, bounding box and transitory values.
 */
- (id)initWithLabel:(NSString *)label boundingBox:(CGRect)boundingBox transitory:(BOOL)transitory;

/**
 * Create and return a `MAWSymbol initialized with the given label, boundingBox and transitory values.
 *
 * @param label A NSString containing the symbol, encoded using UTF-8.
 * @param boundingBox The frame of the Symbol
 * @param transitory A boolean indicating if the Symbol is transitory.
 * @return a MAWSymbol initialized with the given label, bounding box and transitory values.
 */
+ (id)symbolWithLabel:(NSString *)label boundingBox:(CGRect)boundingBox transitory:(BOOL)transitory;

@end