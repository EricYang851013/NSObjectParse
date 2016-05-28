//
//  NSString+Extension.m
//  YXNSobjectParser
//
//  Created by yangxu on 16/5/28.
//  Copyright © 2016年 yangxu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (NSString *)capitalizedStringWithoutChangeOtherCharacter
{
    NSMutableString *str = [self mutableCopy];
    NSRange toReplaceRange = NSMakeRange(0, 1);
    if (str.length >= NSMaxRange(toReplaceRange)) {
        NSString *toReplaceStr = [str substringWithRange:toReplaceRange];
        NSString *upperedReplaceStr = [toReplaceStr capitalizedString];
        [str replaceCharactersInRange:toReplaceRange withString:upperedReplaceStr];
        return str;
    }
    else
    {
        return nil;
    }
}
@end
