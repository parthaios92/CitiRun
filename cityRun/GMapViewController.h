//
/*
Declaring it copy would mean you get an entirely new NSDictionary object for use with your class. If it's quite a large dictionary this can be a performance hit; not very noticeable, but significant anyway. By retaining it, you simply give your class its own pointer to the same NSDictionary instance.

Declaring it assign puts your application at risk of crashing in case the NSDictionary is autoreleased. If it ends up in the pool and gets deallocated because the pool reduced its retain count to 0, your class won't get to access it anymore, causing a crash.
*/

//  GMapViewController.h
//  cityRun
//
//  Created by Basir Alam on 23/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"

@interface GMapViewController : UIViewController<PayPalPaymentDelegate>
@property(nonatomic, assign) int miles;
@property (nonatomic, copy) NSDictionary *dataDic;
@end
