//
//  HamburgerMenuCell.h
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerMenuCell : UITableViewCell

// For User Section
@property (strong, nonatomic) IBOutlet UILabel *lblMenuTitle;


// For Store Owner Section
@property (strong, nonatomic) IBOutlet UILabel *lblMenuTitleSO;

@property (strong, nonatomic) IBOutlet UIImageView *imgMenuImageSO;

@end
