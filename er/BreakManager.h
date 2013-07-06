//
//  BreakManager.h
//  er
//
//  Created by 喻静 on 11-7-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSKeyValueCoding.h>

#import <Foundation/NSString.h>
#import <AVFoundation/AVFoundation.h>

@interface IBreakAction :  NSObject {
}
-(void)run;
@end




@interface BreakManager : NSObject {
   	int breaks[15*13];
	NSMutableDictionary *bookmarks;
	int current;	
    int total;
    int change;
	IBreakAction* action;
	
    
}

-(id)init;
-(void)init:(NSString*)src;
-(int)Total;
-(NSString*)ToString;
-(void)Add:(int)p;
-(int)CurrentVal;
-(void)First;
-(void)Last;
-(void)Next;
-(int)NextVal;
-(int)PreviousVal;
-(void)Remove;
-(void)Previous;
-(void)Move;
-(void)setListener:(IBreakAction*)listener;
-(void)MoveTo:(int)n;
-(void)Bookmark;
-(bool)IsMarked:(int)p;
-(int)Current;
-(int)Change;
@end

/*
@interface BreakPointScreen :IBreakAction
{
@private
	UIView * image;
	BreakManager * bm;
}

-(BreakPointScreen*) init:(UIView*)i bmanager:(BreakManager*) _bm;
-(void)run;
-(void)run:(UIView*)g;

@end
*/

@interface PlayMode: NSObject
{
@protected
	AVAudioPlayer *real;
	BreakManager * bm;
}

-(id)init:(AVAudioPlayer *)_real bmanager:(BreakManager*)_bm;
-(void)onPause;
-(void)onPositionChange;
-(void)onAdd;
-(void)onDelete;
-(void)onFoward;
-(void)onBookmark;
@end

@interface MakePlayMode:PlayMode
{
@private
	bool paused;

    
}
-(id)init:(AVAudioPlayer*)_real bmanager:(BreakManager *)_bm;
-(void)onPause;
-(void)onPositionChange;
-(void)onAdd;
-(void)onDelete;
-(void)onFoward;
-(void)onBookmark;
@end

@interface NSData(MD5)
- (NSString *)MD5;
@end

