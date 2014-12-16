//
//  JXExplodeView.h
//  JXExplodeView
//
//  Created by andy on 12/14/14.
//  Copyright (c) 2014 Andy Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXExplodeView;
@protocol JXExplodeViewDelegate <NSObject>
/**
 *  开始动画回调
 */
- (void)explodeViewBegainExplode:(JXExplodeView *)explodeView;
/**
 *  结束动画回调
 */
- (void)explodeViewFinishExplode:(JXExplodeView *)explodeView;
@end

@interface JXExplodeView : UIImageView
/**
 *  代理
 */
@property (nonatomic, assign) id<JXExplodeViewDelegate> delegate;

/**
 *  动画爆炸
 */
- (void)explode;

/**
 *  动画爆炸，切换图片
 *
 *  @param prepareImage 切换的图片
 */
- (void)explodeWithPrepareImage:(UIImage *)prepareImage;

@end
