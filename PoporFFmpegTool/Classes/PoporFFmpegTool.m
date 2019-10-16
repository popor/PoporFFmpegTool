//
//  PoporFFmpegTool.m
//  PoporFFmpegTool
//
//  Created by apple on 2019/2/14.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporFFmpegTool.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#if __has_include(<mobileffmpeg/MobileFFmpegConfig.h>)
#define HasMobileffmpeg 1
#import <mobileffmpeg/MobileFFmpegConfig.h>
#import <mobileffmpeg/MobileFFmpeg.h>

#else
#define HasMobileffmpeg 0

#endif

@implementation PoporFFmpegTool

// 只支持本地URL
+ (NSString * _Nullable)ffmpegCommand_VideoPath:(NSString * _Nonnull)videoPath tSize:(CGSize)tSize tPath:(NSString * _Nonnull)tPath {
    if (!videoPath) {
        return nil;
    }
    if ([videoPath hasPrefix:@"file://"]) {
        videoPath = [videoPath substringFromIndex:7];
    }
    
    CGSize oSize = [PoporFFmpegTool videoSizeFromPath:videoPath];
    CGSize rSize = [PoporFFmpegTool sizeFrom:oSize targetSize:tSize];
    if (rSize.width == 0 || rSize.height == 0) {
        return nil;
    }
    // https://www.jianshu.com/p/7a186943cbdd
    // -acodec aac: aac音频, acodec,mp2:将失去声音
    NSInteger size = 600*1000*2; // 每分钟10兆的样子
    // -b: 每秒的流量
    // ,-vcodec,copy 视频将不进行压缩. // -vcodec : mpeg4, h264  _  -acodec,aac, -vcodec,mpeg4,
    // -vcodec,h264,
    // hide_banner 隐藏多余信息
    
    NSString * cmd = [NSString stringWithFormat:@"-hide_banner -i %@ -acodec aac -vcodec h264 -b %li -s %ix%i %@", videoPath, (long)size, (int)rSize.width, (int)rSize.height, tPath];
    
    //-vcodec,copy 和 -vf,scale=%i:%i, 不能同时选择.
    //cmd = [NSString stringWithFormat:@"ffmpeg,-i,%@,-acodec,aac,-vcodec,copy,-b,%li,-vf,scale=%i:%i,%@", url, (long)size, (int)rSize.width, (int)rSize.height, tPath];
    
    // -hwaccel,cuvid,加速,但是不能运行
    //cmd = [NSString stringWithFormat:@"ffmpeg,-i,%@,-acodec,aac,-hwaccel,videotoolbox,-b,%li,-s,%ix%i,%@", url, (long)size, (int)rSize.width, (int)rSize.height, tPath];
    
    return cmd;
}

+ (void)executeCommand:(NSString * _Nonnull)ffmpegCommand finish:(void (^ __nullable)(BOOL finish))finish {
#if HasMobileffmpeg == 1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"FFmpeg process started with arguments\n\'%@\'\n", ffmpegCommand);
        int result = [MobileFFmpeg execute:ffmpegCommand];
        //NSLog(@"FFmpeg process exited with rc %d\n", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result == RETURN_CODE_SUCCESS) {
                if (finish) {
                    finish(YES);
                }
            } else {
                if (finish) {
                    finish(NO);
                }
            }
        });
    });
#else
    if (finish) {
        NSLog(@"❌❌❌ PoporFFmpegTool: ERROR pod 'mobile-ffmpeg-full', '3.1' ❌❌❌");
        finish(NO);
    }
#endif
}

#pragma mark - tool
+ (CGSize)sizeFrom:(CGSize)originSize targetSize:(CGSize)targetSize {
    if (originSize.width !=0 && originSize.height != 0 && targetSize.width !=0 && targetSize.height != 0) {
        CGFloat wScale;
        CGFloat hScale;
        CGFloat tScale;
        if (originSize.width == originSize.height || targetSize.width == targetSize.height) {
            wScale = originSize.width/targetSize.width;
            hScale = originSize.height/targetSize.height;
            tScale = MIN(wScale, hScale);
            //NSLog(@"正方形");
        }else{
            if((originSize.width > originSize.height && targetSize.width > targetSize.height)
               ||(originSize.width < originSize.height && targetSize.width < targetSize.height)){
                wScale = originSize.width/targetSize.width;
                hScale = originSize.height/targetSize.height;
                tScale = MAX(wScale, hScale);
                //NSLog(@"同方向");
            }else{
                wScale = originSize.height/targetSize.width;
                hScale = originSize.width/targetSize.height;
                tScale = MAX(wScale, hScale);
                //NSLog(@"反方向");
            }
        }
        return CGSizeMake((int)(originSize.width/tScale), (int)(originSize.height/tScale));
    }else{
        return originSize;
    }
}

+ (CGSize)videoSizeFromPath:(NSString *)path {
    if (!path) {
        return CGSizeZero;
    }
    if ([path hasPrefix:@"file://"]) {
        path = [path substringFromIndex:7];
    }
    AVAsset *asset  = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if ([tracks count] > 0) {
        AVAssetTrack *videoTrack = tracks[0];
        CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
        videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
        return videoSize;
    }else{
        return CGSizeZero;
    }
}

//+ (CGSize)videoSizeFromUrl_old:(NSString *)url {
//    if (!url) {
//        return CGSizeZero;
//    }
//    if ([url hasPrefix:@"file://"]) {
//        url = [url substringFromIndex:7];
//    }
//    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:url]];
//    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    if([tracks count] > 0) {
//        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
//        CGAffineTransform t = videoTrack.preferredTransform;//这里的矩阵有旋转角度，转换一下即可
//        //NSLog(@"=====video size  width:%f===height:%f",videoTrack.naturalSize.width,videoTrack.naturalSize.height);
//
//        BOOL upDown = YES;
//        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
//            // Portrait
//            upDown = YES;
//        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
//            // PortraitUpsideDown
//            upDown = YES;
//        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
//            // LandscapeRight
//            upDown = NO;
//        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
//            // LandscapeLeft
//            upDown = NO;
//        }
//        if (!upDown) {
//            return CGSizeMake(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
//        }else{
//            return CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
//        }
//
//    }else{
//        return CGSizeZero;
//    }
//}

@end
