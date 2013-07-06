//
//  erViewController.h
//  er
//
//  Created by caowf on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomUIView.h"
#import "BreakManager.h"

@interface erViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
	
	IBOutlet UIButton *btn;
    IBOutlet CustomView  *image;

    BreakManager *bm;
    PlayMode *mode;
    NSString *fileName;
    NSString *hashFile;
    IBOutlet UIPickerView *pickerView;
    NSArray *fileList;
    NSString *chooseFile;
    AVAudioPlayer *real;
    IBOutlet UISlider *slider;
    
    
}



-(IBAction)btnPressed:(id)sender;
-(IBAction)stopPressed:(id)sender;
-(IBAction)deletePressed:(id)sender;
-(IBAction)fowardPressed:(id)sender;
-(IBAction)openPressed:(id)sender;
-(IBAction)markPressed:(id)sender;

-(BOOL)writeToFile:(NSData *)data:(NSString *)fileName:(NSString *)extensio; 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

-(void)moveBreakPoint;

@end

