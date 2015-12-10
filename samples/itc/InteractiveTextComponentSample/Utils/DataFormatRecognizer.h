//
//  DataFormatRecognizer.h
//  InteractiveTextComponentInternSample
//
//  Created by Erwan Jestin on 25/02/14.
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFormatRecognizer : NSObject

typedef enum
{
  DataFormatTypeNone,
  DataFormatTypePhoneNumber,
  DataFormatTypeMail,
  DataFormatTypeUrl
}
DataFormatType;

+ (NSArray *)dataTypesFromString:(NSString *)candidate;
+ (DataFormatType)dataTypeFromString:(NSString *)candidate;


@end
