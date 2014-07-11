//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//
#import "MainScene.h"
#import "Grid.h"

@implementation MainScene {
    Grid* _grid;
    CCTimer *_timer;
    CCLabelTTF *_generationLabel;
    CCLabelTTF *_populationLabel;
    int seqno;
}

- (id)init {
    printf( "MainScene::init - self => [%p]\n", self );
    self = [super init];
    printf( "MainScene::init - self => [%p]\n", self );
    seqno = 0;
    
    if (self) {
        _timer = [[CCTimer alloc] init];
        // XXX - why did I have to add this?  is this correct?
        _grid = [[Grid alloc] init];
        //_grid = [Grid alloc];
    }
    printf( "MainScene::init - self => [%p]; _grid => [%p]\n", self, _grid );
    
    return self;
}
- (void)play {
    printf("MainScene::play called - self => [%p] \n", self );
    //[_grid evolveStep];
    //this tells the game to call a method called 'step' every half second.
    [self schedule:@selector(step) interval:0.5f];
}
- (void)pause {
    printf("MainScene::pause called - self => [%p]\n", self );
    [self unschedule:@selector(step)];
}
// this method will get called every half second when you hit the play button and will stop getting called when you hit the pause button
- (void)step {
    printf("MainScene::step called - self => [%p]; seqno => [%d]; _grid => [%p]\n", self, seqno, _grid);
    ++seqno;
    [_grid evolveStep];
   // _generationLabel.string = [NSString stringWithFormat:@"%d", _grid.generation];
   // _populationLabel.string = [NSString stringWithFormat:@"%d", _grid.totalAlive];
}

@end