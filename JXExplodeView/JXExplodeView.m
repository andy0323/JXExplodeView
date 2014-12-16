//
//  JXExplodeView.m
//  JXExplodeView
//
//  Created by andy on 12/14/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import "JXExplodeView.h"

// 爆炸最大个数
static const int kJXExplodeViewVerticalCount   = 5;
static const int kJXExplodeViewHorizontalCount = 5;

// 旋转参数
static const float kJXExplodeViewRotationAngle   = M_PI;
static const float kJXExplodeViewRotationX       = 1;
static const float kJXExplodeViewRotationY       = 1;
static const float kJXExplodeViewRotationZ       = 1;

// 放大参数
static const float kJXExplodeViewScale = 1.2;

// 偏移参数
static const int kJXExplodeViewCenterPointRangeX = 1000;
static const int kJXExplodeViewCenterPointRangeY = 1000;

typedef struct JXExplodeViewDelegateState {
    BOOL respondsBegainExplode;
    BOOL respondsFinishExplode;
}JXExplodeViewDelegateState;

@interface JXExplodeView ()
{
    NSArray *_images;
    
    JXExplodeViewDelegateState _state;
}
@end
@implementation JXExplodeView

/**
 *  图层爆炸
 */
- (void)explode
{
    if (_state.respondsBegainExplode) {
        [_delegate explodeViewBegainExplode:self];
    }
    
    for (UIImageView *imageView in _images) {
        [UIView animateWithDuration:2.0 animations:^{
            // 旋转
            imageView.layer.transform = CATransform3DMakeRotation(kJXExplodeViewRotationAngle,
                                                                  kJXExplodeViewRotationX,
                                                                  kJXExplodeViewRotationY,
                                                                  kJXExplodeViewRotationZ);
            
            // 大小
            imageView.bounds = CGRectMake(0, 0,
                                          kJXExplodeViewScale * imageView.frame.size.width,
                                          kJXExplodeViewScale * imageView.frame.size.height);

            // 透明度
            imageView.alpha = 0;
            
            // 随机坐标
            int flagX = (arc4random()%2)==0 ? -1 : 1;
            int flagY = (arc4random()%2)==0 ? -1 : 1;
            
            int pointX = ( arc4random() % kJXExplodeViewCenterPointRangeX ) * flagX;
            int pointY = ( arc4random() % kJXExplodeViewCenterPointRangeY ) * flagY;
            
            imageView.center = CGPointMake( pointX, pointY );

        } completion:^(BOOL finished) {
            // 移除小模块
            [imageView removeFromSuperview];
            _images = nil;
            
            if (_state.respondsFinishExplode) {
                [_delegate explodeViewFinishExplode:self];
            }
        }];
    }
}

/**
 *  爆炸，切换图片
 *
 *  @param prepareImage 需要切换的图片
 */
- (void)explodeWithPrepareImage:(UIImage *)prepareImage
{
    [self prepareExplode:prepareImage];
    [self explode];
}

/**
 *  爆炸后图像切换
 */
- (void)prepareExplode:(UIImage *)nestImage
{
    _images = [self getExplodeViews];
    
    self.image = nestImage;
}

/**
 *  获取爆炸图像小元素块
 */
- (NSArray *)getExplodeViews
{
    // 最大个数
    int maxCount = kJXExplodeViewVerticalCount * kJXExplodeViewHorizontalCount;
    
    NSMutableArray *explodeElements = [NSMutableArray array];
    
    float imageHeight = self.image.size.height;
    float imageWidth  = self.image.size.width;
    
    CGRect frame;
    float imgHeight = imageHeight/kJXExplodeViewVerticalCount;
    float imgWidth  = imageWidth/kJXExplodeViewHorizontalCount;
    
    float divHeight = self.frame.size.height/kJXExplodeViewVerticalCount;
    float divWidth  = self.frame.size.width/kJXExplodeViewHorizontalCount;

    for (int i = 0; i < maxCount; i++) {
        // 设置坐标
        frame = CGRectMake(imgWidth  * (i%kJXExplodeViewHorizontalCount),
                           imgHeight * (i/kJXExplodeViewVerticalCount),
                           imgWidth, imgHeight);
                
        // 图像切割
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, frame);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        // 切割图像贴入
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        imageView.frame = CGRectMake(divWidth  * (i%kJXExplodeViewHorizontalCount),
                                     divHeight * (i/kJXExplodeViewVerticalCount),
                                     divWidth, divHeight);
        [self addSubview:imageView];
        
        // 缓存图像
        [explodeElements addObject:imageView];
    }
    
    _images = explodeElements;
    return _images;
}

- (void)setDelegate:(id<JXExplodeViewDelegate>)delegate
{
    _delegate = delegate;
    
    _state.respondsBegainExplode = [_delegate respondsToSelector:@selector(explodeViewBegainExplode:)];
    _state.respondsFinishExplode = [_delegate respondsToSelector:@selector(explodeViewFinishExplode:)];
}

@end
