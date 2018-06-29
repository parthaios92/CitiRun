//
//  CheckoutViewController.h
//  cityRun
//
//  Created by Basir Alam on 04/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"

@interface CheckoutViewController : UIViewController<PayPalPaymentDelegate>
@property (strong, nonatomic) NSString *items;
@property (strong, nonatomic) NSString *cart_id;
@property (strong, nonatomic) NSString *billing_amount;

@end
