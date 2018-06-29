//
//  UIViewController+MySettings.h
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MySettings)
-(void)setBackgroundImage;
-(void)setAlertMessage :(NSString *)titel :(NSString *)message;
- (BOOL)validateEmailWithString:(NSString*)checkString;
@end
