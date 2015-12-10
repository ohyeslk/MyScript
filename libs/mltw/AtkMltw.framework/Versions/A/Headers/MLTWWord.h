//
//  MLTWWord.h
//  MultiLineTextWidget
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The model of a word. Represents a word inside the widget. It contains information about the text
 *representation of the word as well as its  candidates and position in the widget.
 *  It is used for every action based on word (scrollToWord, gestures...)
 */
@interface MLTWWord : NSObject

/*!
 * Initialize a new `MLTWWord` with the current parameters.
 *
 * @param candidates The array of all the candidates of the word.
 * @param text The text of the word.
 * @param start The start character index of the word.
 * @param end The end character index of the word.
 */
- (instancetype)initWithCandidates:(NSArray *)candidates text:(NSString *)text start:(NSInteger)start end:(NSInteger)end NS_DESIGNATED_INITIALIZER;

/*!
 * A list of NSString. A candidate is a possible recognized text for the current word. The selected
 *candidate is equal to the `text` property.
 */
@property (nonatomic, strong, readonly) NSArray *candidates;

/*!
 * Start index of the word in the page.
 */
@property (nonatomic, assign, readonly) NSInteger start;

/*!
 * End index of the word in the page.
 */
@property (nonatomic, assign, readonly) NSInteger end;

/*!
 * The most probable candidate for the written word.
 */
@property (nonatomic, strong, readonly) NSString *text;

@end