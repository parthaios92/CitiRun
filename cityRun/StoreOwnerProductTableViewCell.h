//
//  MyProductTableViewCell.h
//  cityRun
//
//  Created by Basir Alam on 05/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreOwnerProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblSubCategory;

@end
