//
//  NSString+CBPWordPressExample.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPress.h"

#import "NSString+CBPWordPressExample.h"

@implementation NSString (CBPWordPressExample)

+ (NSString *)cbp_HTMLStringFor:(CBPWordPressPost *)post withFontSize:(CGFloat)fontSize
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
    
    [html replaceOccurrencesOfString:@"$fontsize$"
                          withString:[@(fontSize) stringValue]
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"$title$"
                          withString:post.title
                             options:0
                               range:NSMakeRange(0, [html length])];
    
    static NSDateFormatter *postDateFormatter;
    
    if (!postDateFormatter) {
        postDateFormatter = [NSDateFormatter new];
        [postDateFormatter setDateFormat:@"h:mm a, MMMM d, yyyy"];
    }
    
    [html replaceOccurrencesOfString:@"$date$"
                          withString:[postDateFormatter stringFromDate:post.date]
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
    
    
    if ([post.categories count])
    {
        static NSString *categorySnippet;
        
        if (!categorySnippet) {
            NSError *error;
            
            NSString *categorypath = [[NSBundle mainBundle] pathForResource:@"category.snippet" ofType:@"html"];
            categorySnippet = [NSString stringWithContentsOfFile:categorypath encoding:NSUTF8StringEncoding error:&error];
            
            if (error) {
                NSLog(@"Error loading Tag template: %@", error);
            }
        }
        
        if (categorySnippet) {
            NSMutableString *categories = @"".mutableCopy;
            
            for (CBPWordPressCategory *category in post.categories)
            {
                NSMutableString *currentCategory = categorySnippet.mutableCopy;
                
                [currentCategory replaceOccurrencesOfString:@"$categoryId$"
                                                 withString:[@(category.categoryId) stringValue]
                                                    options:0
                                                      range:NSMakeRange(0, [currentCategory length])];
                [currentCategory replaceOccurrencesOfString:@"$categoryname$"
                                                 withString:category.title
                                                    options:0
                                                      range:NSMakeRange(0, [currentCategory length])];
                
                [categories appendString:currentCategory];
            }
            
            [html replaceOccurrencesOfString:@"$categories$"
                                  withString:categories
                                     options:0
                                       range:NSMakeRange(0, [html length])];
        }
    } else {
        [html replaceOccurrencesOfString:@"$categories$"
                              withString:@""
                                 options:0
                                   range:NSMakeRange(0, [html length])];
    }
    
    if ([post.tags count])
    {
        static NSString *tagSnippet;
        
        if (!tagSnippet) {
            NSError *error;
            
            NSString *tagpath = [[NSBundle mainBundle] pathForResource:@"tag.snippet" ofType:@"html"];
            tagSnippet = [NSString stringWithContentsOfFile:tagpath encoding:NSUTF8StringEncoding error:&error];
            
            if (error) {
                NSLog(@"Error loading Tag template: %@", error);
            }
        }
        
        if (tagSnippet) {
            NSMutableString *tags = @"".mutableCopy;
            
            for (CBPWordPressTag *tag in post.tags)
            {
                NSMutableString *currentTag = tagSnippet.mutableCopy;
                
                [currentTag replaceOccurrencesOfString:@"$tagId$"
                                            withString:[@(tag.tagId) stringValue]
                                               options:0
                                                 range:NSMakeRange(0, [currentTag length])];
                [currentTag replaceOccurrencesOfString:@"$tagname$"
                                            withString:tag.title
                                               options:0
                                                 range:NSMakeRange(0, [currentTag length])];
                
                [tags appendString:currentTag];
            }
            
            [html replaceOccurrencesOfString:@"$tags$"
                                  withString:tags
                                     options:0
                                       range:NSMakeRange(0, [html length])];
        }
    } else {
        [html replaceOccurrencesOfString:@"$tags$"
                              withString:@""
                                 options:0
                                   range:NSMakeRange(0, [html length])];
    }
    
    if (([html rangeOfString:@"twitter-tweet"].location != NSNotFound) && ([html rangeOfString:@"widgets.js"].location == NSNotFound))
    {
        [html appendString:@"<script async src=\"//platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>"];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"\"//platform.twitter.com/"
                                           withString:@"\"http://platform.twitter.com/"].mutableCopy;
    
    if (([html rangeOfString:@"\"//player.vimeo.com"].location != NSNotFound))
    {
        [html replaceOccurrencesOfString:@"\"//player.vimeo.com"
                              withString:@"\"http://player.vimeo.com"
                                 options:0
                                   range:NSMakeRange(0, [html length])];
    }
    
    
    return html;
}

@end
