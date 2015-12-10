// Copyright MyScript

#import <Foundation/Foundation.h>

/**
 * Interface SCWCandidateInfo.
 */
@interface SCWCandidateInfo : NSObject

/** Character range. */
@property (nonatomic, readonly) NSRange          range;
/** Index of the selected candidate and completion labels. */
@property (nonatomic, readonly) NSUInteger       selectedIndex;
/** Array of candidate labels for this character range. */
@property (nonatomic, readonly) NSMutableArray   *labels;
/** Array of completion labels for this character range. */
@property (nonatomic, readonly) NSMutableArray   *completions;

/**
 * Create a new candidate info object.
 *
 * @param range NSRange range of the candidate info.
 * @param selectedIndex NSUInteger index of the selected candidate.
 * @param labels NSMutableArray array of labels.
 * @param completions NSMutableArray array of completions.
 *
 */
+ (SCWCandidateInfo*)candidateInfoWithRange:(NSRange)range
                             selectedIndex:(NSUInteger)selectedIndex
                                    labels:(NSMutableArray*)labels
                               completions:(NSMutableArray*)completions;

/** Create a new candidate info object by shifting our character range by specified offset.
 *
 * @param offset NSUInteger offset.
 */
- (SCWCandidateInfo*)offsetBy:(NSUInteger)offset;

/** Return index of the given candidate label or -1 of not found. 
 *
 * @param text NSString candidate label.
 */
- (NSUInteger)indexForLabel:(NSString*)text;

/** Return index of the given candidate label+completion or -1 if not found. 
 *
 * @param text NSString candidate label + completion.
 */
- (NSUInteger)indexForLabelAndCompletion:(NSString*)text;

/** Return the selected candidate label for this range. */
- (NSString*)selectedLabel;

/** Return the selected completion label for this range. */
- (NSString*)selectedCompletion;

/** Return the selected candidate+completion label for this range. */
- (NSString*)string;

@end
