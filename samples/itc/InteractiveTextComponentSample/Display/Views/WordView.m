// Copyright MyScript. All right reserved.

#import "WordView.h"
#import <CoreText/CoreText.h>

@interface WordView ()

- (UIFont *)bestFontForString:(NSString *)string originalFont:(UIFont *)font;

@end

@implementation WordView
{
    BOOL _DBG;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _DBG = NO;
        self.backgroundColor = [UIColor clearColor];
        if (_DBG)
            [self setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"dealloc %@", self);
}

- (void)drawRect:(CGRect)rect
{
    // Draw characters
    NSMutableString *typesetLabel = [NSMutableString string];
    // Order the char boxes from left to right
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *orderedCharBoxes = [_word.charBoxes sortedArrayUsingDescriptors:sortDescriptors];
    
    BOOL isAllTypeset = NO;
    NSUInteger charTypesCount = _word.charTypes.count;
    int firstTypesetedCharIndex = 0;
    for (int i = 0; i < charTypesCount; i++)
    {
        ITCWordType wordForCharType = (ITCWordType) [[_word.charTypes objectAtIndex:i] intValue];
        if (wordForCharType == ITCWordTypeTypeset)
        {
            [typesetLabel appendString:[[_word charLabels] objectAtIndex:i]];
            isAllTypeset = YES;
        }
        else
        {
            if (typesetLabel.length > 0)
            {
                ITCRect *previousCharBoxes = (ITCRect*)orderedCharBoxes[firstTypesetedCharIndex];
                CGFloat xPosition =  previousCharBoxes.x - self.frame.origin.x;
                [self drawGlyphsForLabel:typesetLabel andXPosition:xPosition];
                
                typesetLabel = [NSMutableString string];
                isAllTypeset = NO;
            }
            firstTypesetedCharIndex = i+1;
        }
    }
    
    // if only typeset
    if (isAllTypeset)
    {
        if (firstTypesetedCharIndex < _word.charBoxes.count)
        {
            CGFloat xPosition = [(ITCRect*)orderedCharBoxes[firstTypesetedCharIndex] x] - self.frame.origin.x;
            [self drawGlyphsForLabel:typesetLabel andXPosition:xPosition];
        }
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (_DBG)
    {
        float scale = 1;
        NSUInteger count = _word.charBoxes.count;
        for (NSInteger index = 0; index < count; index++)
        {
            ITCRect *itcRect = _word.charBoxes[index];
            //            NSLog(@"WordView : character : %@, box :%@" , [_word charSelectedCandidateWithCharIndex:index], itcRect.description);
            
            CGContextSetStrokeColorWithColor(c, [UIColor greenColor].CGColor);
            CGContextSetLineWidth(c, 1);
            CGContextSetLineDash(c, 0, NULL, 0);
            
            CGRect charBox = itcRect.cgRect;
            charBox.origin.x = charBox.origin.x * scale - self.frame.origin.x;
            charBox.origin.y = charBox.origin.y * scale - self.frame.origin.y;
            charBox.size.width = charBox.size.width * scale;
            charBox.size.height = charBox.size.height * scale;
            
            CGRect frameRect = CGRectInset(charBox, 0.5f, 0.5f);
            
            CGContextStrokeRect(c, frameRect);
        }
    }
}

- (void)drawGlyphsForLabel:(NSString *)label andXPosition:(CGFloat)xPosition
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    float scale = 1;
    
    // Configure text matrix
    CGContextSetTextMatrix(c, CGAffineTransformMakeScale(scale, -scale));
    CGContextSetTextPosition(c, xPosition, _word.baseLine * scale - self.frame.origin.y);
    
    
    UIFont *bestFont = [self bestFontForString:label originalFont:_font];
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)(bestFont.fontName), bestFont.pointSize, NULL);
    
    // Construct the line
    NSDictionary *dict = @{
                           (NSString *)kCTFontAttributeName: (__bridge id)ctfont
                           };
    CFAttributedStringRef attributedString = CFAttributedStringCreate(NULL,
                                                                      (__bridge CFStringRef)(label),
                                                                      (__bridge CFDictionaryRef)(dict));
    CTLineRef line = CTLineCreateWithAttributedString(attributedString);
    
    CTLineDraw(line, c);

    CGContextRestoreGState(c);
}

- (CGFloat)lengthCharBoxes:(NSArray *)boxes ForIndex:(int)index
{
    CGRect totalFrame = CGRectNull;
    for (int i = 0; i < index; i++)
    {
        ITCRect *charBox = (ITCRect *)[boxes objectAtIndex:i];
        CGRect boxFrame = charBox.cgRect;
        totalFrame = CGRectUnion(totalFrame, boxFrame);
    }
    
    return totalFrame.size.width;
}

- (UIFont *)bestFontForString:(NSString *)string originalFont:(UIFont *)font
{
    if (!font)
        font = [UIFont systemFontOfSize:15];
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, NULL);
    CFRange range = CFRangeMake(0, [string length]);
    CTFontRef refFont = CTFontCreateForString(ctfont, (__bridge CFStringRef)string, range);
    
    CFRelease(ctfont);
    
    NSString *fontName = (NSString *)CFBridgingRelease(CTFontCopyName(refFont, kCTFontPostScriptNameKey));
    CGFloat fontSize = CTFontGetSize(refFont);
    UIFont *newFont = [UIFont fontWithName:fontName size:fontSize];
    
    return newFont;
}

@end
