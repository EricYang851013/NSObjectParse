//
//  NSObject+YXNSObjectParser.m
//  YXNSobjectParser
//
//  Created by yangxu on 16/5/28.
//  Copyright © 2016年 yangxu. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSObject+YXNSObjectParser.h"
#import <objc/runtime.h>

@implementation NSObject (YXNSObjectParser)
- (NSDictionary *)infoDictionary
{
    return nil;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [self init]) {
        u_int    count;
        
        objc_property_t* properties= class_copyPropertyList([self class], &count);
        for (int i = 0; i < count ; i++)
        {
            objc_property_t property = properties[i];
            const char* propertyName = property_getName(property);
            //nsobject类中属性名为声明的默认存取器名前加"_"
            Ivar ivar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%s",propertyName]  UTF8String]);
            if (ivar == nil) {
                continue;
            }
            const char *typeEncode = ivar_getTypeEncoding(ivar);
            NSString *typeEncodeStr = [NSString stringWithCString:typeEncode encoding:NSUTF8StringEncoding];
            NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            NSString *campPropertyName = [propertyNameStr capitalizedStringWithoutChangeOtherCharacter];
            id value = [dict objectForKey:campPropertyName];
            
            //如果没有对应的值，直接寻找下一个
            if (value == nil) {
                continue;
            }
            
            //TODO:内置类型仅支持int，float，BOOL
            if ([typeEncodeStr hasPrefix:@"@"] && typeEncodeStr.length ==1) {
                //id 类型直接设值
                
                [self setValue:value forKey:propertyNameStr];
            }
            else if ([typeEncodeStr hasPrefix:@"@"] && typeEncodeStr.length > 1)
            {
                //只有是同一类型的才赋值
                
                
                Class class = NSClassFromString([typeEncodeStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]]);
                if ([value isKindOfClass:class]) {
                    [self setValue:value forKey:propertyNameStr];
                    
                }
            }
            else if ([typeEncodeStr hasPrefix:@"i"])
            {
                if ([value respondsToSelector:@selector(intValue)]) {
                    int intValue = [value intValue];
                    [self setValue:[NSNumber numberWithInt:intValue] forKey:propertyNameStr];
                }
            }
            else if ([typeEncodeStr hasPrefix:@"d"])
            {
                if ([value respondsToSelector:@selector(floatValue)]) {
                    float floatValue = [value floatValue];
                    [self setValue:[NSNumber numberWithFloat:floatValue] forKey:propertyNameStr];
                }
            }
            else if ([typeEncodeStr hasPrefix:@"B"])
            {
                if ([value respondsToSelector:@selector(boolValue)]) {
                    BOOL boolValue = [value boolValue];
                    [self setValue:[NSNumber numberWithBool:boolValue] forKey:propertyNameStr];
                }
            }else if ([typeEncodeStr hasPrefix:@"q"])
            {
                if ([value respondsToSelector:@selector(stringValue)]) {
                    [self setValue:[value stringValue] forKey:propertyNameStr];
                }
            }        }
        free(properties);
    }
    
    return self;
}



- (void)updateWithDict:(NSDictionary *)dict
{
    //TODO:yangxu 以后编写
}
@end
