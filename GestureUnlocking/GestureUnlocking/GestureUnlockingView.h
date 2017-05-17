//
//  GestureUnlockingView.h
//  GestureUnlocking
//
//  Created by imac on 16/1/14.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GestureUnlockingView;
@protocol GestureUnlockingViewDelegate<NSObject>

-(void)gestureUnlockingView:(GestureUnlockingView*)ges lockStr:(NSString*)str;

@end


@interface GestureUnlockingView : UIView

@property(nonatomic,weak)id<GestureUnlockingViewDelegate> delegate;

-(void)end;

@end
