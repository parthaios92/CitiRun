//
//  ProductListTableViewCell.m
//  cityRun
//
//  Created by Basir Alam on 22/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "ProductListTableViewCell.h"

@implementation ProductListTableViewCell
{
    
    IBOutlet UIView *backgroundView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
