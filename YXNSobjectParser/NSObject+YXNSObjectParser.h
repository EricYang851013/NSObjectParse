//
//  NSObject+YXNSObjectParser.h
//  YXNSobjectParser
//
//  Created by yangxu on 16/5/28.
//  Copyright © 2016年 yangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXNSObjectParser)
//NSObject 与 NSDictionary 的转换
- (NSDictionary *)infoDictionary;
- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
