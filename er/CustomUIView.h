//
//  CustomUIView.h
//  er
//
//  Created by 喻静 on 11-6-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreakManager.h"
#import "erAppDelegate.h"


#define PI 3.141592653

typedef enum{
	CustomRect=1,
	CustomCircle=2,
} CustomShape;

@interface CustomView : UIView {
	CustomShape currentShape;
	CGFloat width;
}

@property CGFloat width;
@property BreakManager* bm;
@property erViewController* controller;

-(void)drawWithCustomShape:(CustomShape)shape;
-(void)initProperties;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
