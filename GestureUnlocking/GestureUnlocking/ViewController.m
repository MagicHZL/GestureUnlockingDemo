//
//  ViewController.m
//  GestureUnlocking
//
//  Created by imac on 16/1/14.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ViewController.h"
#import "GestureUnlockingView.h"

@interface ViewController ()<GestureUnlockingViewDelegate>
{
    GestureUnlockingView *getsView;

}
@property (weak, nonatomic) IBOutlet UILabel *textResults;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    getsView = [[GestureUnlockingView alloc]initWithFrame:CGRectMake(20, 200, 300, 500)];
    
    getsView.delegate = self;
    
    [self.view addSubview:getsView];
    
    
}

-(void)gestureUnlockingView:(GestureUnlockingView*)ges lockStr:(NSString*)str{

    _textResults.text = str;

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
