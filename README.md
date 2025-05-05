# SegmentDownloader 分段文件下载器

一个用 Objective-C 实现的多线程分段文件下载工具，支持断点续传和大文件高效下载。

## 功能特性

- ✅ 多线程分段下载，提高下载速度
- ✅ 支持断点续传功能
- ✅ 自动合并下载的分段文件
- ✅ 支持大文件下载
- ✅ 简单的 API 接口

## 安装方法

### 直接使用源文件

1. 将 `SegmentDownloader.h` 和 `SegmentDownloader.m` 文件添加到您的项目中
2. 在需要使用的地方导入头文件：`#import "SegmentDownloader.h"`

### 通过 CocoaPods (可选)

即将支持...

## 使用示例

### 基本使用

```objective-c
#import "SegmentDownloader.h"

// 创建下载器实例
SegmentDownloader *downloader = [[SegmentDownloader alloc] init];

// 开始下载（使用4个线程分段下载）
[downloader startDownloadWithURL:[NSURL URLWithString:@"http://example.com/largefile.zip"] segments:4];
```

### 带进度回调的使用

```objective-c
[downloader startDownloadWithURL:url segments:4 progress:^(float progress) {
    NSLog(@"下载进度: %.2f%%", progress * 100);
} completion:^(BOOL success, NSString *filePath) {
    if (success) {
        NSLog(@"下载完成，文件保存路径: %@", filePath);
    } else {
        NSLog(@"下载失败");
    }
}];
```

## API 文档

### 初始化方法

```objective-c
- (instancetype)init;
```

### 主要方法

```objective-c
/**
 开始分段下载
 
 @param url 文件URL
 @param segments 要分割的段数
 */
- (void)startDownloadWithURL:(NSURL *)url segments:(NSUInteger)segments;

/**
 开始分段下载（带进度和完成回调）
 
 @param url 文件URL
 @param segments 分段数量
 @param progressBlock 进度回调 (0.0-1.0)
 @param completionBlock 完成回调 (success, filePath)
 */
- (void)startDownloadWithURL:(NSURL *)url 
                   segments:(NSUInteger)segments
                  progress:(void (^)(float progress))progressBlock
               completion:(void (^)(BOOL success, NSString *filePath))completionBlock;
```

### 取消下载

```objective-c
- (void)cancelDownload;
```

## 高级配置

### 设置下载超时时间

```objective-c
downloader.timeoutInterval = 30.0; // 默认60秒
```

### 设置保存目录

默认保存在 Documents 目录下，可以修改保存路径：

```objective-c
downloader.saveDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
```

## 注意事项

1. 确保服务器支持 Range 请求（返回 HTTP 206 状态码）
2. 分段数量不宜过多，通常4-8个为宜
3. 大文件下载时注意设备存储空间
4. 后台下载需要额外配置后台任务标识

## 示例项目

包含在 `Example/` 目录中的示例项目演示了如何使用此下载器。

## 许可证

MIT 许可证 - 详情见 LICENSE 文件
