//
//  WebViewController.m
//  citiRun
//
//  Created by Basir Alam on 08/06/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    IBOutlet UIWebView *webView;
    NSString *urlString;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"From: %@",_from);
    self.title = _from;
    [self navigationColorSet];

    if ([_from isEqual:@"About citiRunn"]) {
        
        urlString = @"http://www.appsforcompany.com/citirun/app/about.php";
        
    }else if([_from isEqual:@"Services"]){
        
        urlString = @"http://www.appsforcompany.com/citirun/app/services.php";

    }else if([_from isEqual:@"Terms and Conditions"]){
        
        urlString = @"http://www.appsforcompany.com/citirun/app/terms.php";

    }else{
        
        urlString = @"http://www.appsforcompany.com/citirun/app/privacy.php";

    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

-(void)navigationColorSet{
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


@end
