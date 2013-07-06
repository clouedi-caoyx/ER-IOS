//
//  CustomView.m
//  UseDrawApi
//
//  Created by jiaqiu on 10-10-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomUIView.h"
#import "BreakManager.h"


@implementation CustomView

@synthesize width;
@synthesize bm;
@synthesize controller;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)initProperties{
	width=2.0;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(bm==nil)
        return;
	
    CGContextRef context=UIGraphicsGetCurrentContext();

	CGColorRef Current = [[UIColor redColor] CGColor];
	CGColorRef Used = [[UIColor greenColor] CGColor];
	CGColorRef NotUsed = [[UIColor grayColor] CGColor];
	CGColorRef Marked = [[UIColor blueColor] CGColor];
    //480:320 3:2
    //640:480 4:3
    
	for (int i = 0; i < 12; i++)
	{
		for (int j = 0; j < 15; j++)
		{
            
			int index = i * 15 + j;
			CGColorRef b;
            
			if (index >= [bm Total])
				b = NotUsed;
			else
			{
				if (index == [bm Current])
					b = Current;
				else if ([bm IsMarked:index])
					b = Marked;
				else
					b = Used;
			}
            
            CGRect r=CGRectMake(10+j * (18 + 2), 10+i * (28 + 2), 18, 28);
            CGContextSetFillColorWithColor(context,b);
            CGContextFillRect(context, r);

            
		}
	}
    
    CGContextStrokePath(context);
    CGContextFillPath(context);    
   
    
	}

-(void)drawWithCustomShape:(CustomShape)shape{
	currentShape=shape;
	[self setNeedsDisplay];
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent*)event 
{
    UITouch *touch = [touches anyObject];
    CGPoint lastTouch = [touch locationInView:self];
    int x=lastTouch.x;
    int y=lastTouch.y;
    int col=(x-10)/(18+2);
    int row=(y-10)/(28+2);
    int index=row*15+col;
    if(index<=[bm Total])
    {
        [bm MoveTo:index];
        [controller moveBreakPoint];
        [self drawWithCustomShape:CustomCircle];
        
    }
}





- (void)dealloc {
    [super dealloc];
}


@end
