//
//  ViewController.m
//  IslamicCalendarEx
//
//  Created by Anish Kumar Mallik on 15/03/19.
//  Copyright © 2019 Anish Mallik. All rights reserved.
//

#import "ViewController.h"
#import "DIslamicCalVc.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DIslamicCalVc *disL=[[DIslamicCalVc alloc] initWithNibName:@"DIslamicCalVc" bundle:nil];
    [self.navigationController pushViewController:disL animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
