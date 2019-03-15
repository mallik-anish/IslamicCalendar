//
//  AniView.m
//  ApiParse
//
//  Created by Anish Mallik on 11/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import "AniView.h"
#import "AppDelegate.h"
@implementation AniView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    if (self != nil)
    {
        NSLog(@"Blog View loaded");
        
        self.backgroundColor = [UIColor redColor];
      
        
        
        
        
    }
    return self;
}
-(void)addView
{
     [[self getCurrentViewController].view addSubview:self];
}

-(void)removeSubview
{
    
           [self removeFromSuperview];
  
}

-(UIViewController *)getCurrentViewController
{
   // AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *cntrl=[UIApplication sharedApplication].keyWindow.rootViewController;
    return cntrl;
}
@end
