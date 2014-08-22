//
//  UIViewController+CBPWordPressExample.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 15/07/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "TSMessage.h"

#import "UIViewController+CBPWordPressExample.h"

@implementation UIViewController (CBPWordPressExample)
- (void)showMessage:(NSString *)message
{
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeSuccess
                                       duration:5.0f
                           canBeDismissedByUser:YES];
}

- (void)showError:(NSString *)message
{
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeError
                                       duration:5.0f
                           canBeDismissedByUser:YES];
}
@end
