//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode
@property (nonatomic,assign) Grid* grid
-(id)init;
-(void)play;
-(void)pause;
-(void)step;
@end
