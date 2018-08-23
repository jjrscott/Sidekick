// MIT License
//
// Copyright (c) 2018 John Scott
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "ManageLocalizations.h"
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>

@implementation MLBundle

@end

NSString *__MLLocalizedStringKey(NSString *value, NSString *context);

NSString *__MLLocalizedStringKey(NSString *value, NSString *context)
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    NSData *hashableData = [[NSString stringWithFormat:@"%@\x1f%@", value, context] dataUsingEncoding:NSUTF8StringEncoding];
    CC_SHA1(hashableData.bytes, (CC_LONG)hashableData.length, result);
    
    NSMutableString *key = [NSMutableString new];
    for (NSUInteger i=0; i<6; i++)
    {
        [key appendFormat:@"%02x", result[i]];
    }

    return [key copy];
}

NSString *MLLocalizedString(NSString *value, NSString *context, ...)
{
    NSString *key = __MLLocalizedStringKey(value, context);
    NSString *localizedFormat = [NSBundle.mainBundle localizedStringForKey:key value:value table:nil];
    va_list arguments;
    va_start(arguments, context);
    NSString *localizedString = [[NSString alloc] initWithFormat:localizedFormat
                                                          locale:NSLocale.currentLocale
                                                       arguments:arguments];
    va_end(arguments);
//    NSLog(@"localizedString: %@ %@ -> %@", key, value, localizedString);
    return localizedString;
}

NSAttributedString *MLLocalizedHtml(NSString *value, NSString *context, ...)
{
    NSString *key = __MLLocalizedStringKey(value, context);
    NSString *localizedFormat = [NSBundle.mainBundle localizedStringForKey:key value:value table:nil];
    va_list arguments;
    va_start(arguments, context);
    NSString *localizedHtml = [[NSString alloc] initWithFormat:localizedFormat
                                                          locale:NSLocale.currentLocale
                                                       arguments:arguments];
    va_end(arguments);
//    NSLog(@"localizedString: %@ %@ -> %@", key, value, localizedHtml);
    
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding),
                              };
    
    NSAttributedString *localizedString = [[NSAttributedString alloc] initWithData:[localizedHtml dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:options
                                                                 documentAttributes:NULL
                                                                             error:NULL];
    return localizedString;

    
    
}
