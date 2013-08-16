//
//  RecordViewController.h
//  Talking Toga
//
//  Created by SystemTOGA on 8/11/13.
//  Copyright (c) 2013 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>
#define CAPTURE_FRAMES_PER_SECOND       20

@interface RecordViewController : UIViewController<AVCaptureFileOutputRecordingDelegate>{
    BOOL WeAreRecording;
    
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
//    AVCaptureVideoPreviewLayer *PreviewLayer;
}
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;
- (void) CameraSetOutputProperties;
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position;
// 録画を始めたり終えたりするイベント
- (IBAction)StartStopButtonPressed:(id)sender;
// Back CameraとFront Cameraを切り替えるやつ
- (IBAction)CameraToggleButtonPressed:(id)sender;


//-(IBAction)recordAndPlay:(id)sender;
//-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
//                                 usingDelegate:(id )delegate;
//-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
