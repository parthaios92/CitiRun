//
//  NewMenuController.m
//  citiRun
//
//  Created by @vi on 18/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "NewMenuController.h"
#import "NewMenuCell.h"
#import "NewCartController.h"
#import "AppDelegate.h"

@interface NewMenuController ()<UITableViewDataSource, UITableViewDelegate,ProcessDataDelegate>{
    
    IBOutlet UITableView *newMenuTableView;
    
    NSDictionary *dataDic;
    NSMutableArray* restaurantMenuArray;
    DataFetch *_dataFetch;
    IBOutlet UIView *checkoutView;
    
    NSString *checkCount;
    
}

@end

@implementation NewMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkCount = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:checkCount forKey:@"preferenceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self BackbuttonSet];
    
    newMenuTableView.delegate = self;
    newMenuTableView.dataSource = self;
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    [self MenuItem];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]
//                 stringForKey:@"preferenceName"]);

    
    if ([[[NSUserDefaults standardUserDefaults]
          stringForKey:@"preferenceName"] isEqualToString: @"0"]){
        
         checkoutView.hidden = YES;
    }else{
        
         checkoutView.hidden = NO;
    }
    
    [self navigationColorSet];
}

-(void)MenuItem{
    
    //NSLog(@"%@",_storeID);
    
    NSDictionary *menuDic = @{@"actiontype":@"view_menu",
                              @"user_id":_storeID
                              };
    NSLog(@"%@",menuDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:menuDic from:@"menuList" type:@"json"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
     self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

- (IBAction)btnCheckOutAction:(UIButton *)sender {
    
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return restaurantMenuArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMenuCell * cell =  [newMenuTableView dequeueReusableCellWithIdentifier:@"NewMenuCell" forIndexPath:indexPath];
    
    //    cell.cellView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //    cell.cellView.layer.borderWidth = 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imageAttached = [NSString stringWithFormat: @"http://www.appsforcompany.com/citirun/app/uploads/%@", [[restaurantMenuArray objectAtIndex:indexPath.row] valueForKey:@"image"]];
    
    [cell.menuImage sd_setImageWithURL:[NSURL URLWithString:imageAttached]]; //http://www.appsforcompany.com/citirun/app/uploads/
    cell.lblMenuName.text = [[restaurantMenuArray objectAtIndex:indexPath.row] valueForKey:@"productname"];
    cell.lblMenuPrice.text = [NSString stringWithFormat:@"$%@", [[restaurantMenuArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewCartController *newCartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewCartController"];
    newCartVC.menuDetailsArray = restaurantMenuArray[indexPath.row];
    [self.navigationController pushViewController:newCartVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD){
        
        return 200;
        
    }else{
        
        return 120;
    }
    
}

#pragma mark - Process Successful

- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    
    if ([JsonFor isEqual:@"menuList"]){
        
        if ([[data1 objectForKey:@"availability"] isEqual:@"yes"]){
            
            dataDic = data1;
            
            restaurantMenuArray=[dataDic objectForKey:@"data"];
            
            
            //NSLog(@"%lu,%@",(unsigned long)restaurantListingArray.count,[dataDic objectForKey:@"data"]);
            [newMenuTableView reloadData];
            
        }else{
            
            
        }
        
    }
    
    
}

-(void)processNotSucessful:(NSString *)string{
    
}


@end
