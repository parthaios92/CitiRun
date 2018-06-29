//
//  ShadowDrop.m
//  cityRun
//
//  Created by Basir Alam on 22/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "ShadowDrop.h"

@implementation ShadowDrop

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(1, 2);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.3;
        
        //self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        
        //        [sel addSubview:popupmenu];
  

//        [UIView animateWithDuration:0.3/1.5 animations:^{
//            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3/2 animations:^{
//                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.3/2 animations:^{
//                    self.transform = CGAffineTransformIdentity;
//                }];
//            }];
//        }];


    }
    return self;
}


@end
