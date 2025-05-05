//
//  SegmentDownloader.h
//  SegmentDownloader
//
//  Created by IosBX on 2025/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 下载进度回调块
 *
 * @param progress 下载进度 (0.0 ~ 1.0)
 */
typedef void (^DownloadProgressBlock)(float progress);

/**
 * 下载完成回调块
 *
 * @param success 是否成功
 * @param filePath 下载文件的保存路径 (失败时为nil)
 */
typedef void (^DownloadCompletionBlock)(BOOL success, NSString * _Nullable filePath);

@interface SegmentDownloader : NSObject

/**
 * 下载超时时间 (默认60秒)
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 * 文件保存目录 (默认是Documents目录)
 */
@property (nonatomic, copy) NSString *saveDirectory;

/**
 * 当前下载任务是否正在运行
 */
@property (nonatomic, readonly, getter=isDownloading) BOOL downloading;

/**
 * 初始化下载器
 */
- (instancetype)init;

/**
 * 开始分段下载
 *
 * @param url 要下载的文件URL
 * @param segments 要分割的下载段数 (建议4-8)
 */
- (void)startDownloadWithURL:(NSURL *)url segments:(NSUInteger)segments;

/**
 * 开始分段下载 (带回调)
 *
 * @param url 要下载的文件URL
 * @param segments 要分割的下载段数
 * @param progressBlock 进度回调块
 * @param completionBlock 完成回调块
 */
- (void)startDownloadWithURL:(NSURL *)url
                   segments:(NSUInteger)segments
                  progress:(nullable DownloadProgressBlock)progressBlock
               completion:(nullable DownloadCompletionBlock)completionBlock;

/**
 * 取消当前下载任务
 */
- (void)cancelDownload;

/**
 * 获取默认保存路径
 *
 * @return 默认保存目录路径
 */
+ (NSString *)defaultSaveDirectory;

@end

NS_ASSUME_NONNULL_END
