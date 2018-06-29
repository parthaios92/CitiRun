//
//  UIViewController+MySettings.m
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "UIViewController+MySettings.h"

@implementation UIViewController (MySettings)

-(void)setBackgroundImage
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    if (IS_IPAD) {
        [[UIImage imageNamed:@"tab-bg.jpg"] drawInRect:self.view.bounds];
    }else{
        [[UIImage imageNamed:@"app-bg-innar.jpg"] drawInRect:self.view.bounds];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)setAlertMessage :(NSString *)titel :(NSString *)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:titel
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Email Validation

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
}


@end
