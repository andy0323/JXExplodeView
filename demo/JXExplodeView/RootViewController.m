//
//  RootViewController.m
//  JXExplodeView
//
//  Created by andy on 12/14/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

/**
 *  爆炸
 */
- (void)explode
{
    static int flag = 0;
    
    [_explodeView explodeWithPrepareImage:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.jpg", flag++%2]]];
}

#pragma mark -
#pragma mark 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftItems = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(explode)];
    self.navigationItem.leftBarButtonItem = leftItems;
    
    _explodeView = [[JXExplodeView alloc] initWithFrame:self.view.bounds];
    _explodeView.image = [UIImage imageNamed:@"img1.jpg"];
    [self.view addSubview:_explodeView];
}


@end
