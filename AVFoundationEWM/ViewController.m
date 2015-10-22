//
//  ViewController.m
//  AVFoundationEWM
//
//  Created by HGDQ on 15/10/14.
//  Copyright (c) 2015年 HGDQ. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureDevice            *device;
@property (nonatomic,strong)AVCaptureDeviceInput       *input;
@property (nonatomic,strong)AVCaptureMetadataOutput    *output;
@property (nonatomic,strong)AVCaptureSession           *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.button.selected = NO;
	[self setAVFoundation];
	// Do any additional setup after loading the view, typically from a nib.
}
/**
 *  按钮点击事件
 *
 *  @param sender sender description
 */
- (IBAction)buttonClick:(id)sender {
	//按钮的selected取反
	self.button.selected = !self.button.selected;
	//凯斯二维码扫描
	if (self.button.selected == YES) {
		//开始二维码扫描
		[self.session startRunning];
		//按钮UI移动到二维码扫描后面
		[self.view sendSubviewToBack:self.button];
		//移除UILabel控件
		UILabel *oldLabel = (UILabel *)[self.view viewWithTag:100];
		[oldLabel removeFromSuperview];
	}
}
/**
 *  设置一个UILabel控件 显示扫描结果
 *
 *  @param text 需要显示的数据
 */
- (void)setLabel:(NSString *)text{
	UILabel *oldLabel = (UILabel *)[self.view viewWithTag:100];
	[oldLabel removeFromSuperview];
	UILabel *urlLabel = [[UILabel alloc] init];
	urlLabel.frame = CGRectMake(0, 400, 320, 80);
	urlLabel.text = text;
	urlLabel.textColor = [UIColor redColor];
	urlLabel.textAlignment = NSTextAlignmentCenter;
	urlLabel.numberOfLines = 0;
	urlLabel.tag = 100;
	[self.view addSubview:urlLabel];
}
/**
 *  设置二维码扫描相关代码
 */
- (void)setAVFoundation{
	//设置相机设备
	self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	//设置输入源是摄像头
	self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
	//构建一个输出对象
	self.output = [[AVCaptureMetadataOutput alloc] init];
	//设置代理
	[self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
	//构建一个session对象
	self.session = [[AVCaptureSession alloc] init];
	[self.session setSessionPreset:AVCaptureSessionPresetHigh];
	//输入和输出的桥接
	if ([self.session canAddInput:self.input]) {
		[self.session addInput:self.input];
	}
	if ([self.session canAddOutput:self.output]) {
		[self.session addOutput:self.output];
	}
	//AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code
	//可扫描二维码和条形码
	self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
	self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
	self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
	self.preview.frame = self.view.bounds;
	[self.view.layer insertSublayer:self.preview atIndex:0];
}
/**
 *  实现AVCaptureMetadataOutputObjectsDelegate代理方法
 *
 *  @param captureOutput   captureOutput description
 *  @param metadataObjects metadataObjects description
 *  @param connection      connection description
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
	NSString *stringVaule;
	//扫描成功
	if (metadataObjects.count >0) {
		//停止扫描
		[self.session stopRunning];
		//获取扫描结果
		AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
		stringVaule = metadataObject.stringValue;
		NSLog(@"stringVaule = %@",stringVaule);
		//把按钮移最上层
		[self.view bringSubviewToFront:self.button];
		self.button.selected = NO;
		//设置UILabel的显示
		[self setLabel:stringVaule];
	}
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end








































