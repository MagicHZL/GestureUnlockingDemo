//
//  GestureUnlockingView.m
//  GestureUnlocking
//
//  Created by imac on 16/1/14.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GestureUnlockingView.h"
#import "CheckView.h"


@interface GestureUnlockingView ()

{

    CGMutablePathRef _path;
    CGPoint _checkPoint;
    NSMutableString *_muStr;//生成的密码串
    CGPoint _p;
    BOOL isEnd;
    
}


@end

@implementation GestureUnlockingView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _creatSubViews];
        self.backgroundColor = [UIColor whiteColor];
        _muStr = [NSMutableString string];
        isEnd = YES;
       
    }

    return self;

}

-(void)_creatSubViews{

    CGFloat width = (self.bounds.size.width-40*4)/3.0;
    
    CGFloat height = width;
    
    for (int i=0; i<9; i++) {
        
        CGFloat x = i%3*width+40+i%3*40;
        CGFloat y = i/3*height+10+i/3*40;
        
        CheckView *subV = [[CheckView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        subV.backgroundColor = [UIColor blackColor];
        subV.s = i;
        subV.layer.cornerRadius = width/2.0;
        subV.layer.masksToBounds = YES;
        [self addSubview:subV];
        
    }


}

-(void)end{

    CGPathRelease(_path);
    _path=nil;
    _checkPoint = CGPointMake(0, 0);
    _p = CGPointMake(0, 0);
    isEnd = YES;
    [self setNeedsDisplay];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPathRelease(_path);
    _path=nil;
    _checkPoint = CGPointMake(0, 0);
    
    [self setNeedsDisplay];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint p = [touch locationInView:self];
    
    UIView *hitView = [self hitTest:p withEvent:event];
    if ([hitView isKindOfClass:[CheckView class]]) {
        
        CheckView *check = (CheckView*)hitView;
        _path = CGPathCreateMutable();
        
        CGPathMoveToPoint(_path, NULL, hitView.center.x, hitView.center.y);
        [_muStr appendFormat:@"%d",check.s];
        
        [self setNeedsDisplay];
        _checkPoint = hitView.center;
        isEnd = NO;

        
    }
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    UITouch *touch = [touches anyObject];
    
    CGPoint p = [touch locationInView:self];
    
    
    UIView *hitView = [self hitTest:p withEvent:event];
    
    CGPoint cp = hitView.center;
    
    
    if ([hitView isKindOfClass:[CheckView class]]&&(_checkPoint.x!=cp.x||_checkPoint.y!=cp.y)) {
        
        CheckView *check = (CheckView*)hitView;
        if (!_path) {
            
            _path = CGPathCreateMutable();
            
            CGPathMoveToPoint(_path, NULL, hitView.center.x, hitView.center.y);
            
            [self setNeedsDisplay];
            isEnd = NO;
            [_muStr appendFormat:@"%d",check.s];
            _checkPoint = cp;
            
        }else{
        
           CGPathAddLineToPoint(_path, NULL, hitView.center.x, hitView.center.y);
        
           [self setNeedsDisplay];
        
           [_muStr appendFormat:@"%d",check.s];
    
           _checkPoint = cp;
            
        }
        
        
    }else if(_checkPoint.x!=0){
    
        _p = p;
    
        [self setNeedsDisplay];
    
    }
    

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if ([self.delegate respondsToSelector:@selector(gestureUnlockingView:lockStr:)]) {
        
        [self.delegate gestureUnlockingView:self lockStr:[_muStr copy]];
        
    }
    //储存结束把密码字符串清空，以免影响下次操作
    [_muStr deleteCharactersInRange:NSMakeRange(0, _muStr.length)];
    
//    isEnd = YES;
//    _checkPoint = CGPointMake(0, 0);
//    _p = CGPointMake(0, 0);
//    
//    [self setNeedsDisplay];
    //延迟调用取消画线
//    [self performSelector:@selector(end) withObject:nil afterDelay:3];
    [self end];
    
}

- (void)drawRect:(CGRect)rect {
    
    if (_path) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextAddPath(context, _path);
        CGContextSetLineWidth(context, 3.0);
        [[UIColor redColor]set];
        
        CGContextDrawPath(context, kCGPathStroke);
 
    }
    
    if (!isEnd&&_checkPoint.x!=0&&_p.x!=0) {
        
      CGMutablePathRef sPath = CGPathCreateMutable();
    
      CGPathMoveToPoint(sPath, NULL, _checkPoint.x, _checkPoint.y);
    
      CGPathAddLineToPoint(sPath, NULL, _p.x, _p.y);
      CGContextRef context = UIGraphicsGetCurrentContext();
    
      CGContextAddPath(context, sPath);
      CGContextSetLineWidth(context, 3.0);
      [[UIColor redColor]set];
      CGContextDrawPath(context, kCGPathStroke);
      CGPathRelease(sPath);
      sPath = nil;
    }
    
}



@end
