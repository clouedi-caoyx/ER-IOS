//
//  BreakManager.m
//  er
//
//  Created by 喻静 on 11-7-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BreakManager.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSKeyValueCoding.h>
#import <Foundation/NSString.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>


@implementation BreakManager

-(id)init{
    if((self=[super init]))
    {
        current = -1;
        total = 0;
        bookmarks=[[NSMutableDictionary alloc] init];
        change=0;
        
    }
    return self;
}

-(void)Move
{
    if (action != nil)
        [action run];
}

-(int)Total{
    return total;
}

-(int)Change{
    return change;
}

-(void)init:(NSString*)src{
    
    NSArray *points = [src componentsSeparatedByString:@":"];
    
    [bookmarks removeAllObjects];
    current = 0;
    total = 0;
    change=0;
    ;
    int index=0;
    for(NSString * point in points)
    {
        if(point==nil)
            return;
        NSRange find=[point rangeOfString:@"+"];
        if(find.length>0)  
        {
            
            NSString *sbp=[point substringToIndex:find.location];
            int bp=[sbp intValue];
            breaks[index]=bp;
            [bookmarks setValue:@"0" forKey:[NSString stringWithFormat:@"%d", bp]];
        }
        else
        {            
            NSString *sbp=point;
            int bp=[sbp intValue];
            breaks[index]=bp;            
            
            
        }
        index++;
        
    }
    total=index;
    
    [self Move];
    
}

-(NSString*)ToString{
    int i;
    NSString* result = @"";

    for (i = 0; i < [self Total]; i++)
    {
        if (i == [self Total] - 1)
        {
            
            NSString* bookmark=[bookmarks objectForKey:[NSString stringWithFormat:@"%d", breaks[i]]];
            if(bookmark)
            {
                
                //result = [result componentsJoinedByString:[NSString stringWithFormat:@"%d+0",breaks[i]]];
                result=[NSString stringWithFormat:@"%@%@", result, [NSString stringWithFormat:@"%d+0",breaks[i]]];
                
            }
            else
                //result = [result componentsJoinedByString:[NSString stringWithFormat:@"%d",breaks[i]]];
                result=[NSString stringWithFormat:@"%@%@", result, [NSString stringWithFormat:@"%d",breaks[i]]];
        }
        else
        {
            
            result=[NSString stringWithFormat:@"%@%@", result, [NSString stringWithFormat:@"%d",breaks[i]]];
            NSString* bookmark=[bookmarks objectForKey:[NSString stringWithFormat:@"%d", breaks[i]]];
            
            if(bookmark)
            {
                result=[NSString stringWithFormat:@"%@%@", result, @"+0"];
            }
            result =[NSString stringWithFormat:@"%@%@", result, @":"];

        }
    }
    return result;
}


-(void)Add:(int)p{
    int i;
    change=1;
    i = total - 1;
    while ((i >= 0) && (breaks[i] > p))
    {
        breaks[i + 1] = breaks[i];
        i--;
    }
    breaks[i + 1] = p;
    current = i + 1;          
    total++;
    [self Move];
}


-(int)CurrentVal
{
    int result;
    
    if ((total == 0) || current == total)
    {
        result = 99999999;
    }
    else
    {
        result = breaks[current];
    }
    return result;
}

-(void) First
{
    current = 0;
    [self Move];
}

-(int)Current
{
    return current;
}


-(void) Last
{
    if ([self Total] > 0)
    {
        current = [self Total] - 1;
        [self Move];
    }
    else
    {
        current = 0;
    }
}


-(void) Next
{
    if (current <[self Total])
        current++;
    [self Move];
}

-(int)NextVal
{
    int result;
    if ([self Total] == 0)
    {
        result = 99999999;
    }
    else
    {
        if (current < [self Total] - 1)
        {
            result = breaks[current + 1];
        }
        else
        {
            result = 99999999;
        }
        
    }
    return result;
}

-(int) PreviousVal
{
    int result;
    if (current <= 0)
    {
        result = 1;
    }
    else
    {
        result = breaks[current - 1];
    }
    return result;
}

-(void) Remove
{
    int i;
    change=1;
    if (total > 1)
    {
        [bookmarks removeObjectForKey:[NSString stringWithFormat:@"%d", [self CurrentVal]]];
        
        i = current + 1;
        while (i < total)
        {
            breaks[i - 1] = breaks[i];
            i = i + 1;
        }
        
        if (current > total)
            current--;
        total--;
        [self Move];
    }
}

-(void)Previous
{
    if (current > 0) current--;
    [self Move];
}


-(void) setListener:(IBreakAction*)listener
{
    action = listener;
}


-(void)MoveTo:(int)n
{
    if (n <= total)
    {
        current = n;
        [self Move];
    }
    
}


-(void)Bookmark
{
    change=1;
    if (current >= 0)
    {
        //NSInteger bookmark=[bookmarks objectForKey:[self CurrentVal]];
        NSString* bookmark=[bookmarks objectForKey:[NSString stringWithFormat:@"%d", [self CurrentVal]]];
        if (!bookmark)
            [bookmarks setValue:@"0" forKey:[NSString stringWithFormat:@"%d", [self CurrentVal]]];
        else
            [bookmarks removeObjectForKey:[NSString stringWithFormat:@"%d", [self CurrentVal]]];
        
        NSLog(@"%d",[bookmarks count]);
          
    }
}

-(bool)IsMarked:(int)p{
    if (p < total)
        return [bookmarks objectForKey:[NSString stringWithFormat:@"%d", breaks[p]]]!=nil;
    else
        return false;
}
@end



/*
@implementation BreakPointScreen




BreakPointScreen::BreakPointScreen(UiCanvas& i,BreakManager& _bm):image(i),bm(_bm)
{
    
}

-(void) BreakPointScreen::run()
{
    run(image);
}


-(void) BreakPointScreen::run(UiCanvas& g)
{
    HDC hdc = g.m_dcCanvas.GetDC();
    HBRUSH Current =  CreateSolidBrush(RGB(255,0,0));
    HBRUSH Used =  CreateSolidBrush(RGB(0,255,0));
    HBRUSH NotUsed = CreateSolidBrush(RGB(80,80,80));
    HBRUSH Marked =  CreateSolidBrush(RGB(0,0,255));
    
    
    RECT r;
    
    
    
    for (int i = 0; i < 13; i++)
    {
        for (int j = 0; j < 15; j++)
        {
            
            int index = i * 15 + j;
            HBRUSH* b;
            
            if (index >= bm.Total())
                b = &NotUsed;
            else
            {
                if (index == bm.Current())
                    b = &Current;
                else if (bm.IsMarked(index))
                    b = &Marked;
                else
                    b = &Used;
            }
            
            r.left=15+j * (28 + 2);
            r.top=10+i * (38 + 2);
            r.right=15+j * (28 + 2)+28;
            r.bottom=10+i * (38 + 2)+38;
            
            FillRect(hdc, &r, *b);
            
        }
    }
    
    
    
    DeleteObject(Current);
    DeleteObject(Used);
    DeleteObject(NotUsed);
    DeleteObject(Marked);
    image.Invalidate();
    image.Update();
}

@end
*/

@implementation PlayMode
-(id)init:(AVAudioPlayer *)_real bmanager:(BreakManager *)_bm
{
    if((self=[super init]))
    {
        real=_real;
        bm=_bm;
    }
    return self;

}

@end

@implementation MakePlayMode

-(id)init:(AVAudioPlayer *)_real bmanager:(BreakManager *)_bm{
    if((self=[super init:_real bmanager:_bm]))
    {
        paused=false;
    }
    return self;
    
}
-(void) onPause
{
    if(paused)
        [real play];
    else
        [real pause];
    paused=!paused;
    
}

-(void) onPositionChange
{
    
    if (([real currentTime]*1000)> [bm CurrentVal])
        real.currentTime=0.001*[bm PreviousVal];
         //SeekTo();
}

-(void) onAdd
{
    NSLog(@"%f",real.currentTime*1000);
    
    [bm Add:real.currentTime*1000];
    real.currentTime=0.001*[bm PreviousVal];
}
-(void) onDelete
{
    [bm Remove];
}
-(void) onFoward
{
    [bm MoveTo:([bm Current] + 1)];
}

-(void) onBookmark
{
    [bm Bookmark];
}

@end

@implementation NSData(MD5)

- (NSString*)MD5
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end