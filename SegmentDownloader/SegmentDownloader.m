//
//  SegmentDownloader.m
//  SegmentDownloader
//
//  Created by IosBX on 2025/5/5.
//

#import "SegmentDownloader.h"

@interface SegmentDownloader ()
@property (nonatomic, strong) NSMutableArray *receivedDataArray;
@property (nonatomic, assign) NSUInteger totalSize;
@property (nonatomic, assign) NSUInteger segmentCount;
@property (nonatomic, assign) NSUInteger completedSegments;
@end

@implementation SegmentDownloader

- (void)startDownloadWithURL:(NSURL *)url segments:(NSUInteger)segments {
    self.segmentCount = segments;
    self.receivedDataArray = [NSMutableArray arrayWithCapacity:segments];
    
    // 先获取文件总大小
    [self getFileSizeWithURL:url completion:^(NSUInteger fileSize) {
        self.totalSize = fileSize;
        [self startSegmentedDownloadWithURL:url];
    }];
}

- (void)getFileSizeWithURL:(NSURL *)url completion:(void (^)(NSUInteger))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSUInteger size = [response expectedContentLength];
            completion(size);
        } else {
            NSLog(@"获取文件大小失败: %@", error);
            completion(0);
        }
    }];
    [task resume];
}

- (void)startSegmentedDownloadWithURL:(NSURL *)url {
    NSUInteger segmentSize = self.totalSize / self.segmentCount;
    
    for (NSUInteger i = 0; i < self.segmentCount; i++) {
        NSUInteger start = i * segmentSize;
        NSUInteger end = (i == self.segmentCount - 1) ? self.totalSize - 1 : (i + 1) * segmentSize - 1;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:[NSString stringWithFormat:@"bytes=%lu-%lu", (unsigned long)start, (unsigned long)end] forHTTPHeaderField:@"Range"];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error && data) {
                @synchronized (self) {
                    [self.receivedDataArray addObject:data];
                    self.completedSegments++;
                    
                    if (self.completedSegments == self.segmentCount) {
                        [self mergeAllSegments];
                    }
                }
            } else {
                NSLog(@"分段 %lu 下载失败: %@", (unsigned long)i, error);
            }
        }];
        
        [task resume];
    }
}

- (void)mergeAllSegments {
    NSMutableData *completeData = [NSMutableData data];
    for (NSData *segmentData in self.receivedDataArray) {
        [completeData appendData:segmentData];
    }
    
    // 保存完整文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"downloadedFile"];
    
    [completeData writeToFile:filePath atomically:YES];
    NSLog(@"文件下载完成，保存路径: %@", filePath);
}

@end
