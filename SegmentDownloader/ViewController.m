//
//  ViewController.m
//  SegmentDownloader
//
//  Created by IosBX on 2025/5/5.
//

#import "ViewController.h"
#import "SegmentDownloader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建下载器实例
    SegmentDownloader *downloader = [[SegmentDownloader alloc] init];

    // 开始下载（使用4个线程分段下载）
    [downloader startDownloadWithURL:[NSURL URLWithString:@"http://example.com/largefile.zip"] segments:4];
}


@end
