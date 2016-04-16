# AVFoundationEWM
### AVFoundation苹果原生二维码和条形码扫描
我们首先需要设置一些和相机相关的参数<br>
```OC
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
```
扫描输出在代理中实现<br>
二维码输出的url链接,条形码输出的是编号<br>
```OC
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
```
详细的使用,可以查看博客[《【iOS】AVFoundation架构下的原生二维码和条形码扫描》](http://blog.csdn.net/zhuming3834/article/details/49126489)<br>

###关于二维码的生成,请看这里<br>
[《【iOS】CoreImage原生二维码生成（一）》](http://blog.csdn.net/zhuming3834/article/details/50832953)<br>
[《【iOS】CoreImage原生二维码生成（二）一个方法生成带logo的二维码》](http://blog.csdn.net/zhuming3834/article/details/50835659)<br>
[《【iOS】一个方法读取图片中的二维码信息》](http://blog.csdn.net/zhuming3834/article/details/50835808)<br>


