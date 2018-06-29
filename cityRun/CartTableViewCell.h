//
//  CartTableViewCell.h
//  cityRun
//
//  Created by Basir Alam on 03/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgViewWeightLayout;
@property (strong, nonatomic) IBOutlet UIButton *btnIncrement;
@property (strong, nonatomic) IBOutlet UIButton *btnDecrement;
@property (strong, nonatomic) IBOutlet UITextField *txtProductCount;
@property (strong, nonatomic) IBOutlet UIButton *btnShowMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;


@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UIImageView *productImg;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;

@end
