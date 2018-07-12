//
//  RestaurentDetailsController.m
//  citiRun
//
//  Created by @vi on 15/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "RestaurentDetailsController.h"
#import "NewMenuController.h"

@interface RestaurentDetailsController (){
    
    IBOutlet UIView *viewRestaurant;
    
    IBOutlet UIImageView *detailsStoreImage;
    IBOutlet UILabel *lblStoreName;
    IBOutlet UILabel *lblStoreDistance;
    IBOutlet UITextView *detailsTxtView;
    
    
}

@end

@implementation RestaurentDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",self.restDetailsArray);
//    NSLog(@"%@",[self.restDetailsArray valueForKey:@"image"]);
    [self BackbuttonSet];
    
    NSString *imageAttached = [NSString stringWithFormat: @"http://www.appsforcompany.com/citirun/app/uploads/%@", [self.restDetailsArray valueForKey:@"image"]];
    
//    if ([[self.restDetailsArray valueForKey:@"image"] isEqualToString:@"http://www.appsforcompany.com/citirun/app/image/"]){
//
//        NSLog(@"Attached");
//
//    }else{
//
//          NSLog(@"Not Attached");
//    }
    
    
    [detailsStoreImage sd_setImageWithURL:[NSURL URLWithString:imageAttached]];
    
    if ([[self.restDetailsArray valueForKey:@"distance"] isEqual:[NSNull null]]){
        
         NSLog(@"Null");
        lblStoreDistance.text = [NSString stringWithFormat: @"Distance :Null Mile"];
        
    }else{
        
        lblStoreDistance.text = [NSString stringWithFormat: @"Distance:%@ Mile", [self.restDetailsArray valueForKey:@"distance"]];
    }
    
    lblStoreName.text = [self.restDetailsArray valueForKey:@"store_name"];
    detailsTxtView.text = [self.restDetailsArray valueForKey:@"details"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self navigationSet];
    
}

-(void)navigationSet{
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnViewMenuAction:(UIButton *)sender {
    
    NewMenuController *newMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMenuController"];
    newMenuVC.storeID = [self.restDetailsArray valueForKey:@"storeid"];
    [self.navigationController pushViewController:newMenuVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
