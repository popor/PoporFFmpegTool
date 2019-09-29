//
//  PoporFFmpegTool.h
//  PoporFFmpegTool
//
//  Created by apple on 2019/2/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <mobileffmpeg/MobileFFmpegConfig.h>
#import <mobileffmpeg/MobileFFmpeg.h>

@interface PoporFFmpegTool : NSObject

// 只支持本地URL
+ (NSString * _Nullable)ffmpegGetCmd_VideoPath:(NSString * _Nonnull)videoPath size:(CGSize)tSize tPath:(NSString * _Nonnull)tPath;

//+ (void)ffmpegExecuteCmd:(NSString * _Nonnull)cmd finish:(void (^ __nullable)(BOOL finish))finish;

#pragma mark - tool
+ (CGSize)sizeFrom:(CGSize)originSize targetSize:(CGSize)targetSize;
+ (CGSize)videoSizeFromPath:(NSString * _Nonnull)path;

@end
