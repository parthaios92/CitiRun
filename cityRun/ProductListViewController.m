//
//  ProductListViewController.m
//  cityRun
//
//  Created by Basir Alam on 22/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductListTableViewCell.h"
@interface ProductListViewController ()<VSDropdownDelegate>
{
    IBOutlet UIView *productDetailView;
    IBOutlet UITextField *txtNumberOfItem;
    IBOutlet UILabel *lblTotalPrice;
    IBOutlet UIButton *btnDecrement;
    VSDropdown *_dropDown;
    NSMutableArray* listArray;
    IBOutlet UIButton *btnShowMenu;
}
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackgroundImage];

    btnDecrement.enabled = NO;
    btnDecrement.alpha = 0.6f;
    [self setVSDropDown];
    
}
-(void)setVSDropDown{
//    spotNo = 1;
    _dropDown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropDown setAdoptParentTheme:YES];
    [_dropDown setShouldSortItems:YES];
    listArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<= 10; i++) {
        [listArray addObject:[NSString stringWithFormat:@"%dml",100*i]];
    }
    NSLog(@"%@",listArray);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListTableViewCell" forIndexPath:indexPath];

    //    IS_IPHONE_5 or IS_IPHONE_4_OR_LESS
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        cell.productImageWidthLC.constant = 95;
    }else{
        cell.productImageWidthLC.constant = 106;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    tempTotal = [[lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
//    NSLog(@"%f",tempTotal);
    [productDetailView setFrame:CGRectMake(8,64+8,self.view.frame.size.width-16,self.view.frame.size.height-(16+64))];
    [self.view addSubview:productDetailView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        return 120;
    }else{
        return 140;
    }
}
- (IBAction)btnCloseDetailAction:(id)sender {
    [productDetailView removeFromSuperview];
}
- (IBAction)btnIncrementAction:(id)sender {
    btnDecrement.enabled = YES;
    btnDecrement.alpha = 1.0f;
    txtNumberOfItem.text = [NSString stringWithFormat:@"%ld", [txtNumberOfItem.text integerValue]+1];
//    NSString* newTotal = [lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
//    lblTotalPrice.text = [NSString stringWithFormat:@"$%.02f", [newTotal floatValue]+[newTotal floatValue]];
}
- (IBAction)btnDecrementAction:(id)sender {
    if ([txtNumberOfItem.text isEqual:@"2"]) {
        btnDecrement.enabled = NO;
        btnDecrement.alpha = 0.6f;
        txtNumberOfItem.text = [NSString stringWithFormat:@"%ld", [txtNumberOfItem.text integerValue]-1];
//        NSString* newTotal = [lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
//        NSLog(@"%@",newTotal);
//        lblTotalPrice.text = [NSString stringWithFormat:@"$%.02f", [newTotal floatValue]-[newTotal floatValue]];
    }else{
        txtNumberOfItem.text = [NSString stringWithFormat:@"%ld", [txtNumberOfItem.text integerValue]-1];
        NSString* newTotal = [lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSLog(@"%@",newTotal);
  
    }
}

#pragma mark -
#pragma mark - VSDropdown Delegate methods.
- (IBAction)btnSelectAmount:(id)sender {
    NSLog(@"%@",sender);
    NSLog(@"%@",listArray);
    [self showDropDownForButton:sender adContents:listArray multipleSelection:NO];
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    NSLog(@"%@",sender);
    [_dropDown setAllowMultipleSelection:multipleSelection];
    [_dropDown setupDropdownForView:sender];
    [_dropDown setSeparatorColor:sender.titleLabel.textColor];
    if (_dropDown.allowMultipleSelection)
    {
        NSLog(@"%@",[[listArray objectAtIndex:sender.tag] componentsSeparatedByString:@","]);
        [_dropDown reloadDropdownWithContents:contents andSelectedItems:[[listArray objectAtIndex:sender.tag] componentsSeparatedByString:@","]];
    }
    else
    {
        [_dropDown reloadDropdownWithContents:contents andSelectedItems:@[[sender titleForState:UIControlStateNormal]]];
    }
}

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    NSLog(@"%lu",(unsigned long)index);
    
    btnShowMenu = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = 0;
    if (dropDown.selectedItems.count>1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@","];
        
        if ([allSelectedItems hasPrefix:@","]) {
            
            allSelectedItems = [allSelectedItems substringFromIndex:1];
            
        }
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    
    if (allSelectedItems.length == 0) {
        allSelectedItems = @"";
    }
    
    [btnShowMenu setTitle:allSelectedItems forState:UIControlStateNormal];
    
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    
    return btn.titleLabel.textColor;
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}

@end
