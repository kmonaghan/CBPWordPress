//
//  NSString+CBPWordPressExample.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressPost;

@interface NSString (CBPWordPressExample)
+ (NSString *)cbp_HTMLStringFor:(CBPWordPressPost *)post withFontSize:(CGFloat)fontSize;
@end
