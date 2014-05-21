//
//  NSString+CBPWordPressExample.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSString+CBPWordPressExample.h"

@implementation NSString (CBPWordPressExample)

+ (NSString *)cbp_HTMLStringFor:(CBPWordPressPost *)post
{
    static NSString *HTMLTemplate;
    
    if (!HTMLTemplate) {
        NSError *error;
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
        HTMLTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Error loading HTML template: %@", error);
            
            return nil;
        }
    }
    
    NSMutableString *html = HTMLTemplate.mutableCopy;
    
    [html replaceOccurrencesOfString:@"$title$"
                          withString:post.title
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"$date$"
                          withString:[post.date description]
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"$authorId$"
                          withString:[NSString stringWithFormat:@"%ld", (long)post.author.authorId]
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"$author_name$"
                          withString:post.author.name
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"$content$"
                          withString:post.content
                             options:0
                               range:NSMakeRange(0, [html length])];
    
    /*
    if ([post.categories count])
    {
        [html appendString:@"<div>"];
        
        for (CBPWordPressCategory *item in post.categories)
        {
            [html appendFormat:@"<a class=\"category\" href=\"kmwordpress://category:%ld\">%@</a> ", (long)item.categoryId, item.title];
        }
        
        [html appendString:@"</div>"];
    }
    
    if ([post.tags count])
    {
        [html appendString:@"<div style=\"clear:both\">"];
        
        for (CBPWordPressTag *item in post.tags)
        {
            [html appendFormat:@"<a class=\"tag\" href=\"kmwordpress://tag:%ld\">%@</a>", (long)item.tagId, item.title];
        }
        
        [html appendString:@"</div>"];
    }
    */
    
    if (([html rangeOfString:@"twitter-tweet"].location != NSNotFound) && ([html rangeOfString:@"widgets.js"].location == NSNotFound))
    {
        [html appendString:@"<script async src=\"//platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>"];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"\"//platform.twitter.com/"
                                           withString:@"\"http://platform.twitter.com/"].mutableCopy;
    
     
    
    return html;
}

@end
