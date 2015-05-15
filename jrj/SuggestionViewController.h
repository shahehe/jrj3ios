//
//  SuggestionViewController.h
//  financialDistrict
//
//  Created by USTB on 13-3-15.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"


@interface SuggestionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer  *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *recordingButton;
//@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@property(nonatomic,retain) IBOutlet UIButton *btn1;
@property(nonatomic,retain) IBOutlet UIButton *btn2;
@property(nonatomic,retain) IBOutlet UIButton *typeBtn;
@property(nonatomic,retain) IBOutlet UISwitch *feedbackSwitch;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
- (IBAction)feedbackBtn:(UIButton *)sender;

//@property (nonatomic, retain) UIImageView *imageToUpload;
@property (weak, nonatomic) IBOutlet UIImageView *imageToUpload;
@property (weak, nonatomic) IBOutlet UILabel *placeInfo;
@property (weak, nonatomic) IBOutlet UITextField *phoneContact;
@property (weak, nonatomic) IBOutlet UITextView *problemDescription;

@property double returnedLatitude;
@property double returnedLongitude;
@property NSData *recordingData;
@property BOOL hasPlaceInfo;
@property BOOL needFeedback;
@property BOOL hasVoice;

-(IBAction)typeSelectAction:(UIButton *)sender;

@end
