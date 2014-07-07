//
//  Grid.m
//  GameOfLife
//
//  Created by Lex Lehr on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}
- (void)onEnter{
    [super onEnter];
    [self setupGrid];
    
    //accept touches on the grid
    self.userInteractionEnabled = YES;
}
-(void)setupGrid{
    //divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width/ GRID_COLUMNS;
    _cellWidth = self.contentSize.width/ GRID_COLUMNS;
    
}

@end