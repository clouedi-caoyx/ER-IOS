//
//  erViewController.m
//  er
//
//  Created by caowf on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "erViewController.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation erViewController


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void) showFileChooser {
    if(pickerView)
        [pickerView release];
    
    
    
    pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 160.0f, 320.0f, 216.0f)];
	pickerView.delegate = self;
    pickerView.dataSource=self;
	pickerView.showsSelectionIndicator = YES; 
    [self.view addSubview:pickerView];
    if(chooseFile)
    {
        for(int i=0;i<[fileList count];i++)
        {
            if([fileList objectAtIndex:i]==chooseFile)
            {
                [pickerView selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
    
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	if (real) {
		[real release];
	}
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:bundleRoot];
    
    NSString *_filename;
    while ((_filename = [direnum nextObject] )) {
        if ([_filename hasSuffix:@".mp3"]) {
            [arr addObject:_filename];
        }
    }
    
    
    
    
    fileList = arr;
    
    bm=[[BreakManager alloc] init];
    [image initProperties];
    image.bm=bm;
    image.controller=self;
    
    NSNumber *myInt = [NSNumber numberWithInt:4];    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fireTimer:) userInfo:myInt repeats:YES];
    
    
    
    //[self showFileChooser];
    
    
    [super viewDidLoad];
    
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    int size=[fileList count];
    return size;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [fileList objectAtIndex:row];
} 

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    chooseFile=[fileList objectAtIndex:row];
    NSLog(@"%d",row);
}



- (void) fireTimer:(NSTimer*)theTimer {
    if(real&&[real isPlaying])
    {
        [mode onPositionChange];
        [slider setValue:real.currentTime];
            
    }
    
    //NSLog(@" %i ", [[theTimer userInfo] integerValue]);
    //[theTimer invalidate];
    //theTimer = nil;
}

-(void)btnPressed:(id)sender{
    [mode onAdd];
	[real play];
    //[bm Add:[real currentTime]];
    [image drawWithCustomShape:CustomCircle];
    
}

-(void)stopPressed:(id)sender{
	[mode onPause];
    //[bm Add:[real currentTime]];
    //[image drawWithCustomShape:CustomCircle];
    
}

-(void)deletePressed:(id)sender{
    [mode onDelete];
    [image drawWithCustomShape:CustomCircle];
    
}

-(void)fowardPressed:(id)sender{
    [mode onFoward];
    [image drawWithCustomShape:CustomCircle];
    
}

- (BOOL)writeToFile:(NSData *)data:(NSString *)file:(NSString *)extension 
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//NSString *appFile = [[NSBundle mainBundle] pathForResource:file ofType:extension];
	NSLog(@"%@",file);
    [fileManager createFileAtPath:file contents:data attributes:nil];
    return true;
    /*
     if (!file)  
     {
     return ([fm createFileAtPath:file contents:data attributes:nil]);
     }
     else
     return ([data writeToFile:file atomically:YES]); 	
     */
}


-(void)openPressed:(id)sender{
    
    if (!pickerView) {
        [self showFileChooser];
        
        
        return;
    }
    
    
    
    
    [pickerView removeFromSuperview];
    [pickerView release];
    pickerView=nil;
    
    
    NSLog(@"%@",chooseFile);
    
    
    
    
    //NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:i];
    //NSString* path = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"txt"];
    //NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    //NSFileManager *manager = [NSFileManager defaultManager];
    //NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:bundleRoot];
    
    NSString *_filename=chooseFile;
    
    //while ((_filename = [direnum nextObject] )) {
    
    
    //if ([_filename hasSuffix:@".mp3"]) {
    
    
    if (real) {
        //[real stop];
        if([bm Change]>0)
            [self writeToFile:[[bm ToString] dataUsingEncoding: NSASCIIStringEncoding]:hashFile :@" "];
        NSLog(@"%@",[bm ToString]);
        [real release];
        
        if(fileName)
            [fileName release];
        
        if(hashFile)
            [hashFile release];
    }
    
    
    
    
    fileName=[NSString stringWithFormat:@"%@/%@", bundleRoot, _filename];
    NSLog(@"%@",fileName);
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath: fileName];
    NSData *data = [fileHandle readDataOfLength:1024*1024*2];
    hashFile=[[NSString stringWithFormat:@"%@/%@", bundleRoot, [data MD5]] retain];
    
    NSLog(@"Hash File Name:%@",hashFile);
    NSString* content = [NSString stringWithContentsOfFile:hashFile
                                                  encoding:NSASCIIStringEncoding
                                                     error:NULL];
    NSLog(@"Break Point:%@",content);
    [bm init:content];
    
    
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:fileName];
    real=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    slider.minimumValue=0.0;
    slider.maximumValue=real.duration;
    
    if(mode)
        [mode release];
    
    
    mode=[[MakePlayMode alloc] init:real bmanager:bm];
    [real prepareToPlay];
    [real play];
    
    [image drawWithCustomShape:CustomCircle];
    
    
    
    
    //}
    
    //}
    
    
    
}

-(void)markPressed:(id)sender{
    [mode onBookmark];
    [image drawWithCustomShape:CustomCircle];
    
}




/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)moveBreakPoint{
    if(real)
    {
        real.currentTime=0.001*[bm PreviousVal];
    }
}


- (void)dealloc {
    
    [real release];
    
    
    [super dealloc];
}

@end