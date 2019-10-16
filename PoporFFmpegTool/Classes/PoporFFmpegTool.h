//
//  PoporFFmpegTool.h
//  PoporFFmpegTool
//
//  Created by apple on 2019/2/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<mobileffmpeg/MobileFFmpegConfig.h>)
#define HasMobileffmpeg 1
#import <mobileffmpeg/MobileFFmpegConfig.h>
#import <mobileffmpeg/MobileFFmpeg.h>

#else
#define HasMobileffmpeg 0

#endif

/*
 由于github不推荐超过100MB的framework，所以推荐用户自己pod引入。而且cocoapods老说RETURN_CODE_SUCCESS有问题。
 推荐使用3.1，4.2貌似有问题。3.1已经开始x264，压制的视频可以再chrome等浏览器上播放。
 
 pod 'mobile-ffmpeg-full', '3.1'
 //*/

@interface PoporFFmpegTool : NSObject

// 只支持本地URL
+ (NSString * _Nullable)ffmpegCommand_VideoPath:(NSString * _Nonnull)videoPath tSize:(CGSize)tSize tPath:(NSString * _Nonnull)tPath;

// 命名规则: 具体功能函数、参数不使用简单单词
+ (void)executeCommand:(NSString * _Nonnull)ffmpegCommand finish:(void (^ __nullable)(BOOL executeFinish))finish;

#pragma mark - tool
+ (CGSize)sizeFrom:(CGSize)originSize targetSize:(CGSize)targetSize;
+ (CGSize)videoSizeFromPath:(NSString * _Nonnull)path;

@end
