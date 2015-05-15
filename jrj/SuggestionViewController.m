//
//  SuggestionViewController.m
//  financialDistrict
//
//  Created by USTB on 13-3-15.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import "SuggestionViewController.h"
//#import "UIColor+NavigationColor.h"
#import <QuartzCore/QuartzCore.h>
#import "StringsJsonParser.h"
#import "ApiService.h"
#import "CheckConnection.h"
#import "UIButton+Bootstrap.h"
#import "Session.h"


@interface SuggestionViewController (){

    BOOL firstWriteDescription;
    NSMutableData *dataFromRequest2;
    UIActivityIndicatorView *uploadActivity;

}
@property (nonatomic, assign) int isSel;
- (IBAction)listBtn;
@end

@implementation SuggestionViewController

@synthesize imageToUpload;
@synthesize placeInfo;
@synthesize returnedLatitude;
@synthesize returnedLongitude;
@synthesize hasPlaceInfo;
@synthesize phoneContact;
@synthesize problemDescription;
//@synthesize feedbackButton;
@synthesize needFeedback;
@synthesize audioRecorder;
@synthesize recordingButton;
@synthesize recordingData;
@synthesize audioPlayer;
@synthesize hasVoice;

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
    hasPlaceInfo = FALSE;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    self.navigationController.navigationBar.tintColor = [UIColor NaviColor];
    
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor],[UIFont systemFontOfSize:20.0f],[UIColor colorWithWhite:0.0 alpha:1], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor, nil]];
    [self customText];
    firstWriteDescription = YES;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    //add a long press gesture recognizer to recording button
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(recordingTask:)];
    //the corresponding action is in the addAnnotationForMap function
    [longPress setMinimumPressDuration:0.01];
    [recordingButton addGestureRecognizer:longPress];
    
    [self initializeAudio];
    hasVoice = NO;
    
    [recordingButton setTitle:@"按住开始录音" forState:UIControlStateNormal];
//    [recordingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordingButton setTitle:@"松开结束录音" forState:UIControlStateSelected];
//    [recordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    recordingData = [[NSData alloc] init];
    

    [self setViewStyle:recordingButton];
    [self setViewStyle:self.btn1];
    [self setViewStyle:self.btn2];
    
    
    self.phoneContact.layer.cornerRadius = 6;
    self.phoneContact.layer.masksToBounds = YES;
    self.phoneContact.layer.borderColor = [UIColor colorWithRed:237/255.0 green:134/255.0 blue:8/255.0 alpha:1].CGColor;
    self.phoneContact.layer.borderWidth = 1;
    
    self.problemDescription.layer.borderColor = [UIColor colorWithRed:237/255.0 green:134/255.0 blue:8/255.0 alpha:1].CGColor;
    self.problemDescription.layer.borderWidth = 1;
    
    [Session sharedInstance].suggestionViewController = self;
    
}
- (void)setViewStyle:(UIButton *)sender
{
    sender.layer.cornerRadius = 6;
    sender.layer.masksToBounds = YES;
}

-(void)typeSelectAction:(UIButton *)sender
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *a = @[@"行政服务",@"社区服务",@"城市管理",@"社会管理",@"应急处置",@"其它"];
    [a enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ac addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.typeBtn setTitle:obj forState:UIControlStateNormal];
        }]];
    }];
    [self presentViewController:ac animated:YES completion:nil];
    
}
- (void) initializeAudio{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:0];

    
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];//格式
    [recordSettings setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey]; //采样8000次
    [recordSettings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];//声道
    [recordSettings setValue :[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];//位深度
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    //Encoder
    [recordSettings setValue :[NSNumber numberWithInt:12000] forKey:AVEncoderBitRateKey];//采样率
    [recordSettings setValue :[NSNumber numberWithInt:8] forKey:AVEncoderBitDepthHintKey];//位深度
    [recordSettings setValue :[NSNumber numberWithInt:8] forKey:AVEncoderBitRatePerChannelKey];//声道采样率
    [recordSettings setValue :[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];//编码质量
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    audioRecorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(!hasPlaceInfo){
        [placeInfo setAlpha:0.0];
    }
    else{
        placeInfo.text = [NSString stringWithFormat:@"位置%f,%f",returnedLatitude,returnedLongitude];
        [placeInfo setAlpha:0.0];
        [UIView animateWithDuration:1.0
                              delay:0.1
                            options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){[placeInfo setAlpha:1.0];}
                         completion:^(BOOL finished){
                                    if(finished)
                                    {
                                        [UIView animateWithDuration:1.5
                                                              delay:0.5
                                                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                         animations:^(void){[placeInfo setAlpha:0.0];}
                                                         completion:^(BOOL finished){}];
                                    }
                         }
         ];
        hasPlaceInfo = FALSE;
    }
    
}


- (void)customText{
    phoneContact.backgroundColor = [UIColor whiteColor];
    phoneContact.delegate = self;
    UIView *paddingView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    phoneContact.leftView             = paddingView;
    phoneContact.leftViewMode         = UITextFieldViewModeAlways;
    
    [[problemDescription layer] setBorderColor:[UIColor clearColor].CGColor];
    problemDescription.layer.borderWidth = 1.5f;
    problemDescription.text = @"描述";
    problemDescription.textColor = [UIColor lightGrayColor];
    problemDescription.delegate = self;
       
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
//    phoneContact.layer.borderWidth = 1.5f;
//    phoneContact.layer.borderColor = [UIColor orangeColor].CGColor;
}


-(void) textFieldDidEndEditing:(UITextField *)textField
{
//    phoneContact.layer.borderColor = [UIColor clearColor].CGColor;
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
//    [[problemDescription layer] setBorderColor:[UIColor orangeColor].CGColor];
//    problemDescription.textColor = [UIColor blackColor];
    
    if(firstWriteDescription){
            problemDescription.text = @"";
    }
}


- (void) textViewDidChange:(UITextView *)textView
{
    if([problemDescription.text isEqualToString:@""]){
        problemDescription.textColor = [UIColor lightGrayColor];
        problemDescription.text = @"描述";
        [problemDescription resignFirstResponder];
        firstWriteDescription = YES;
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
//    [[problemDescription layer] setBorderColor:[UIColor clearColor].CGColor];
    firstWriteDescription = NO;
    if([problemDescription.text isEqualToString:@""]){
        problemDescription.textColor = [UIColor lightGrayColor];
        problemDescription.text = @"描述";
        [problemDescription resignFirstResponder];
        firstWriteDescription = YES;
    }
}

//close the keyboard
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneContact endEditing:YES];
    [self.problemDescription endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)useCamera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"相机无法使用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)usePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"无法启用照片" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }

}


#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    imageToUpload.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}


//- (IBAction)feedbackNeeded:(id)sender {
//    
//    if (needFeedback == 0){
//        [feedbackButton setSelected:YES];
//        needFeedback = YES;
//    }
//    else {
//        [feedbackButton setSelected:NO];
//        needFeedback = NO;
//        }
//
//}

- (void) recordingTask:(UILongPressGestureRecognizer*)press {
    
    if (press.state == UIGestureRecognizerStateBegan) {
        //start recording
        [recordingButton setTitle:@"松开结束录音" forState:UIControlStateNormal];
        [recordingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recordingButton setTitle:@"松开结束录音" forState:UIControlStateSelected];
        [recordingButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"icon_end_sound"] forState:UIControlStateNormal];
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"icon_end_sound"] forState:UIControlStateSelected];
        [audioRecorder record];
        NSLog(@"begin!!!");
    }
    else if (press.state == UIGestureRecognizerStateEnded) {
        //finish recording
        [recordingButton setTitle:@"按住开始录音" forState:UIControlStateNormal];
        [recordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [recordingButton setTitle:@"按住开始录音" forState:UIControlStateSelected];
        [recordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"icon_background"] forState:UIControlStateNormal];
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"icon_background"] forState:UIControlStateSelected];
        [audioRecorder stop];
        NSLog(@"finish!!!");
    }
}


- (IBAction)uploadSuggestion:(id)sender {
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
    
    NSData *imageData = UIImageJPEGRepresentation(imageToUpload.image, 80);
    NSData *phoneData = [[NSString stringWithFormat:@"%@",phoneContact.text] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *problemData = [[NSString stringWithFormat:@"%@",problemDescription.text] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithObjects:imageData,phoneData,problemData,recordingData,nil];
    
    if (dataArray == nil) {
        [self showAlert:@"上传内容不能为空！"];
        return;
    } else {
        if([CheckConnection connected]){
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"正在上传";
            [HUD showWhileExecuting:@selector(uploadTask:) onTarget:self withObject:dataArray animated:YES];
        }
    }
}


-(void) uploadTask:(NSMutableArray *) infoArray{

//    needFeedback = self.feedbackSwitch.on;
	// setting up the URL to post to
    NSString *urlString =[NSString stringWithFormat:@"http://%@/jrj/receiveMessage.php",[ApiService sharedInstance].host];
    NSString *imageName = @"problemImage.jpg";
    NSString *voiceName = @"problemVoice.amr";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 might change to random boundary
     */
	NSString *boundary = @"---------------------------147378098314664";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    
    /*
     set latitude,longitude,feedback,name,mobile,address,create_time value
     */
    
    //latitude
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"latitude\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%f",returnedLatitude] dataUsingEncoding:NSUTF8StringEncoding]];
    //longitude
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"longitude\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%f",returnedLongitude] dataUsingEncoding:NSUTF8StringEncoding]];
    //feedback
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"feedback\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%d",needFeedback] dataUsingEncoding:NSUTF8StringEncoding]];
    //mobile
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"mobile\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:infoArray[1]];
    //address
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"address\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:infoArray[2]];
    //create_time
    NSDate* currentDate = [NSDate date];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"create_time\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",[currentDate description]] dataUsingEncoding:NSUTF8StringEncoding]];
    //uid
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"uid\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
    //name
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"name\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"MyName"] dataUsingEncoding:NSUTF8StringEncoding]];
    //hasVoice
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"hasvoice\"\n\n " dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%d",hasVoice] dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
     set picture
     */
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:infoArray[0]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    /*
     set voice
     */
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"voice\"; filename=\"%@\"\r\n",voiceName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:infoArray[3]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@",returnString);
    
    
    /*
     Picture has been uploaded, and info has been inserted
     Now parse the return dictionary using JSON parser
     send to feedback.php if success
     */
    if(returnString != nil){
        NSDictionary *outputDic = [[NSDictionary alloc] init];
        
        NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(jsonObject != nil && error == nil){
            if([jsonObject isKindOfClass:[NSDictionary class]]){
                outputDic = (NSDictionary *)jsonObject;
            }
        }
        
        if([[outputDic objectForKey:@"code"] integerValue] == 1){
            [self showAlert:@"上传成功"];
            
            //connect to feedback.php
            
            [self performSelectorOnMainThread:@selector(connectFeedback) withObject:nil waitUntilDone:YES];

            
        }
        else {
            NSLog(@"The return value from receiveMessage is failure");
            [self showAlert:@"上传不成功"];
        }
    }
    else{
        [self showAlert:@"上传失败"];
    }

}

-(void) connectFeedback{
    
    //Everything back to normal
    problemDescription.text = @"";
    phoneContact.text = @"";
    imageToUpload.image = [UIImage imageNamed:@"no_image"];
    
    //connect to feedback.php
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
    NSString *url2 = [[NSString alloc] init];
    if([ApiService sharedInstance].isLogin == false){
        url2 =[NSString stringWithFormat:@"http://%@/jrj/feedback.php",[ApiService sharedInstance].host];
    }
    else{
        url2 =[NSString stringWithFormat:@"http://%@/jrj/feedback.php?uid=%d",[ApiService sharedInstance].host,[ApiService sharedInstance].userID];
    }
    
    
    [request2 setURL:[NSURL URLWithString:url2]];
    [request2 setHTTPMethod:@"GET"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request2 delegate:self startImmediately:YES];
    
    if(!connection) {
        NSLog(@"connection to feedback failed :(");
    } else {
        NSLog(@"connection to feedback is set... :)");
        
    }
}

#pragma mark showAlert

- (void) showAlert:(NSString *)messageToDisplay{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:messageToDisplay delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertV performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}


#pragma mark NSURLConnection delegate methods

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    dataFromRequest2 = [[NSMutableData alloc] init];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataFromRequest2 appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Done with Feedback!");
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}


#pragma mark AVAudioPlayerDelegate methods
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{

}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

#pragma mark AVAudioRecorderDelegate methods
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Finished Recording...");
    recordingData = [NSData dataWithContentsOfURL:recorder.url];
    hasVoice = YES;
    
    //Testing!!!!Using a player to see if the recorder is okay... turns out yes.. delete these lines
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:audioRecorder.url
                    error:&error];
    
    audioPlayer.delegate = self;
    
    if (error)
        NSLog(@"Error: %@",
              [error localizedDescription]);
    else
        [audioPlayer play];
}

- (void) audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Audio Recorder Encode Error Occured");
}

- (IBAction)feedbackBtn:(UIButton *)sender {
    if (self.isSel == 0) {
        [self.feedbackBtn setBackgroundImage:[UIImage imageNamed:@"icon_feedback_sel"] forState:UIControlStateNormal];
        self.isSel = 1;
    } else {
        [self.feedbackBtn setBackgroundImage:[UIImage imageNamed:@"icon_feedback"] forState:UIControlStateNormal];
        self.isSel = 0;
    }
}
- (IBAction)listBtn {
    [self typeSelectAction:self.typeBtn];
}
@end
