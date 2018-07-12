//
//  LoginViewController.h
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController

@property (weak,nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end
