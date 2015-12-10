// Copyright MyScript. All right reserved.

#import "DataFormatRecognizer.h"

@implementation DataFormatRecognizer

#define REGEX_MAIL @"[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})"
#define REGEX_PHONE @"(\\b[\\d]{3}[-.]?[\\d]{3}[-.]?[\\d]{4}\\b)"
#define REGEX_URL @"((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/][a-z]+((\\w)*|([0-9]*)|([-|_])*))+"

+ (NSArray *)dataTypesFromString:(NSString *)candidate
{
    // mail
    NSArray *matchMails = [self regex:REGEX_MAIL match:candidate];
    
    // phone
    NSArray *matchPhones = [self regex:REGEX_PHONE match:candidate];
    
    // url
    NSArray *matchUrls = [self regex:REGEX_URL match:candidate];
    
    
    NSMutableArray *dataformatMatches = [NSMutableArray arrayWithArray:matchMails];
    [dataformatMatches addObjectsFromArray:matchPhones];
    [dataformatMatches addObjectsFromArray:matchUrls];
    
    return dataformatMatches;
}

+ (DataFormatType)dataTypeFromString:(NSString *)candidate
{
    // mail
    {
        NSArray *matchMails = [self regex:REGEX_MAIL match:candidate];
        
        if (matchMails.count > 0)
            return DataFormatTypeMail;
    }
    
    // phone
    {
        NSArray *matchPhones = [self regex:REGEX_PHONE match:candidate];
        
        if (matchPhones.count > 0)
            return DataFormatTypePhoneNumber;
    }
    
    // url
    {
        NSArray *matchUrls = [self regex:REGEX_URL match:candidate];
        
        if (matchUrls.count > 0)
            return DataFormatTypeUrl;
    }
    
    return DataFormatTypeNone;
}

/*
 * return an NSArray of NSTextCheckingResult
 *
*/
+ (NSArray *)regex:(NSString *)regex match:(NSString *)text
{
    NSError *error;
    
    NSRegularExpression *regexTest = [NSRegularExpression regularExpressionWithPattern:regex
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    if (!error)
    {
        NSArray *matches = [regexTest matchesInString:text
                                                options:0
                                                  range:NSMakeRange(0, [text length])];
        return matches;
    }
    
    return nil;
}

@end
