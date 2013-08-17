//
//  RecordViewController.m
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController
@synthesize PreviewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // AVCaptureSesstionを作る
    CaptureSession = [[AVCaptureSession alloc] init];
    
    // カメラデバイスを取得する
    AVCaptureDevice *VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (VideoDevice)
    {
        NSError *error;
        // カメラからの入力を作成する
//        VideoInputDevice = [AVCaptureDeviceInput  deviceInputWithDevice:VideoDevice error:&error];
        VideoInputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                // Sessionに追加
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    // 動画録画なのでAudioデバイスも取得する
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        // 同じように追加
        // 参考ではこんな感じになってたけど、厳密には上のVideoInputDeviceと同じようにやった方がいいと思う。
        [CaptureSession addInput:audioInput];
    }
    
    // PreviewLayerを設定する
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    
//    PreviewLayer.orientation = AVCaptureVideoOrientationPortrait;
    PreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    // 引き伸ばし方とか設定。ここではアスペクト比が維持されるが、必要に応じてトリミングされる設定を適用
    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // ファイル用のOutputを作成
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    // 動画の長さ
    Float64 TotalSeconds = 60;
    // 一秒あたりのFrame数
    int32_t preferredTimeScale = 30;
    // 動画の最大長さ
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);
    MovieFileOutput.maxRecordedDuration = maxDuration;
    // 動画が必要とする容量
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    // sessionに追加
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    // CameraDeviceの設定(後述)
    [self CameraSetOutputProperties];
    
    // 画像の質を設定。詳しくはドキュメントを読んでください
    [CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])     //Check size based configs are supported before setting them
        [CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    // StoryBoard使えばこんなの要らない？
//    CGRect layerRect = [[[self view] layer] bounds];
    CGRect layerRect = CGRectMake(85, 20, 150, 200);
    [PreviewLayer setBounds:layerRect];
    [PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                          CGRectGetMidY(layerRect))];

    // さっきLayerを設定したやつをaddSubviewして貼り付ける
    UIView *CameraView = [[UIView alloc] init];
    [[self view] addSubview:CameraView];
    [self.view sendSubviewToBack:CameraView];
//反転
//    PreviewLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
    [[CameraView layer] addSublayer:PreviewLayer];
    
    // sessionをスタートさせる
    [CaptureSession startRunning];
}

//- (UIImage *)mirrorImage:(UIImage *)img{
//    
//    CGImageRef imgRef = [img CGImage]; // 画像データ取得
//    
//    UIGraphicsBeginImageContext(img.size); // 開始
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // コンテキスト取得
//    CGContextTranslateCTM( context, img.size.width,
//                          img.size.height); // コンテキストの原点変更
//    CGContextScaleCTM( context, -1.0, -1.0);
//    // コンテキストの軸をXもYも等倍で反転
//    CGContextDrawImage( context, CGRectMake( 0, 0,
//                                            img.size.width, img.size.height), imgRef);
//    // コンテキストにイメージを描画
//    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
//    // コンテキストからイメージを取得
//    
//    UIGraphicsEndImageContext(); // 終了
//    
//    return retImg;
//}

// サポートする画面の向き
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WeAreRecording = NO;
}

- (void) CameraSetOutputProperties{
    // ドキュメントには書いてなかったけど、このConnectionっていうのを貼らないとうまく動いてくれないっぽい
    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // Portraitに設定。これはあくまでもカメラ側からファイルへの出力。カメラーロールで再生した時にどの向きであって欲しいかを設定
    if ([CaptureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        [CaptureConnection setVideoOrientation:orientation];
    }
    
    //ここから下はお好みで
    CMTimeShow(CaptureConnection.videoMinFrameDuration);
    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
    
    if (CaptureConnection.supportsVideoMinFrameDuration)
        CaptureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
    if (CaptureConnection.supportsVideoMaxFrameDuration)
        CaptureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
    
    CMTimeShow(CaptureConnection.videoMinFrameDuration);
    CMTimeShow(CaptureConnection.videoMaxFrameDuration);
}

// カメラ切り替えの時に必要
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

// Camera切り替えアクション
- (IBAction)CameraToggleButtonPressed:(id)sender{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)        //Only do if device has multiple cameras
    {
        NSError *error;
        AVCaptureDeviceInput *NewVideoInput;
        AVCaptureDevicePosition position = [[VideoInputDevice device] position];
        // 今が通常カメラなら顔面カメラに
        if (position == AVCaptureDevicePositionBack)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        // 今が顔面カメラなら通常カメラに
        else if (position == AVCaptureDevicePositionFront)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        }
        
        if (NewVideoInput != nil)
        {
            // beginConfiguration忘れずに！
            [CaptureSession beginConfiguration];            // 一度削除しないとダメっぽい
            [CaptureSession removeInput:VideoInputDevice];
            if ([CaptureSession canAddInput:NewVideoInput])
            {
                [CaptureSession addInput:NewVideoInput];
                VideoInputDevice = NewVideoInput;
            }
            else
            {
                [CaptureSession addInput:VideoInputDevice];
            }
            
            //Set the connection properties again
            [self CameraSetOutputProperties];
            
            
            [CaptureSession commitConfiguration];
        }
    }
}




- (IBAction)StartStopButtonPressed:(id)sender{
    if (!WeAreRecording){
        [recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        WeAreRecording = YES;
        //保存する先のパスを作成
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //上書きは基本できないので、あったら削除しないとダメ
            }
        }
        //録画開始
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    }
    else{
        NSLog(@"stopbutton pushed!");
        WeAreRecording = NO;
        [MovieFileOutput stopRecording];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    NSLog(@"recording finished!");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully){
        //previewを停止
        [CaptureSession stopRunning];
        //saveするかどうか聞く
        [self saveOrCancel:nil];
        
        
        
        
    }
}

- (void)saveOrCancel:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Please enter the title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeAlphabet;
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //left button(cancel) was tapeed
            [CaptureSession startRunning];
            [recordButton setTitle:@"Rec" forState:UIControlStateNormal];
            break;
        case 1:
            //right button(done) was tapped
            //add cell which is named that user entered in alert view
            //書き込んだのは/tmp以下なのでカメラーロールの下に書き出す
        {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
            NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]){
                [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                            completionBlock:^(NSURL *assetURL, NSError *error)
                 
                 {
                     if (error)
                     {
                         
                     }
                 }];
            }
            //ローカルにも保存する
            //保存する動画の情報を保存しておく。
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //ファイルをコピーして移動
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            savePath = [[[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:textField.text] stringByAppendingString:@".mov"];
            [fileManager copyItemAtPath:outputPath toPath:savePath error:NULL];
            [self dismissModalViewControllerAnimated:YES];
            break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"きえる");
    [super viewWillDisappear:animated];
    if ( [self.delegate respondsToSelector:@selector(nextViewValueDidChanged:savePath:)] ) {
        //入力してもらったファイル名
        NSLog(@"うごいてる");
        [self.delegate nextViewValueDidChanged:textField.text savePath:savePath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
