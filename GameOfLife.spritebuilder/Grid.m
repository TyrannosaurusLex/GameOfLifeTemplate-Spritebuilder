//
//  Grid.m
//  GameOfLife
//
//  Created by Lex Lehr on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
//#define ANSI_COLOR_RED     "\x1b[31m"
//#define ANSI_COLOR_GREEN   "\x1b[32m"
//#define ANSI_COLOR_YELLOW  "\x1b[33m"
//#define ANSI_COLOR_BLUE    "\x1b[34m"
//#define ANSI_COLOR_MAGENTA "\x1b[35m"
//#define ANSI_COLOR_CYAN    "\x1b[36m"
//#define ANSI_COLOR_RESET   "\x1b[0m"


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
-(void)onEnter{
    printf("Grid::onEnter Called \n");
    [super onEnter];
    [self setupGrid];
    printf("_gridArray = [%p]\n",_gridArray);
    //accept touches on the grid
    self.userInteractionEnabled = YES;
}
- (void)setupGrid
{
    printf("Grid::setupGrid called \n");
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    printf("_cellWidth: [%f] --- _cellHeight: [%f]\n",_cellWidth,_cellHeight);
    float x = 0;
    float y = 0;
    
    struct { unsigned rows; unsigned columns; } foo = { GRID_ROWS, GRID_COLUMNS };
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray arrayWithCapacity:foo.rows];
    
    // initialize Creatures
    for (int i = 0; i < foo.rows; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray arrayWithCapacity:foo.columns];
        x = 0;
        
        for (int j = 0; j < foo.columns; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid properly
            //creature.isAlive = YES;
            x+=_cellWidth;
        }
        
        y += _cellHeight;
    }
  //  printf("_gridArray count === [%d] --- _gridArray[] count === [%d]",(_gridArray.count), (_gridArray[0].count));
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert it's state - kill it if it's alive, bring it to life if it's dead.
    creature.isAlive = !creature.isAlive;
}
- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    return _gridArray[row][column];
}
-(void)evolveStep{
    //update each Creature's neighbor count
    printf("Grid::evolveStep called \n");
    [self countNeighbors];
    
    //update each Creature's state
    [self updateCreatures];
    
    //update the generation so the label's text will display the correct generation
    _generation++;
}
-(void)countNeighbors{
    // iterate through the rows
    // note that NSArray has a method 'count' that will return the number of elements in the array
    printf("Grid::countNeighbors called --- _gridArray count == [%d]\n", _gridArray.count);
    for (int i = 0; i < GRID_ROWS; i++)
    {
        // iterate through all the columns for a given row
        for (int j = 0; j < GRID_COLUMNS; j++)
        {
            //printf("Grid::countNeighbors innerloop at i: [%d] j: [%d]\n",i,j);
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a 'livingNeighbors' property that we created earlier
            currentCreature.livingNeighbors = 0;
            printf("Grid::countNeighbors - currentCreature => [%p]; currentCreature.isAlive => [%d]\n", currentCreature,currentCreature.isAlive);
           
            // now examine every cell around the current one
            
            // go through the row on top of the current cell, the row the cell is in, and the row past the current cell
            for (int x = (i-1); x <= (i+1); x++)
            {
                // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                for (int y = (j-1); y <= (j+1); y++)
                {
                    //printf("Grid::countNeighbors inner-innerloop at x: [%d] y: [%d] \n",x,y);
                    // check that the cell we're checking isn't off the screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    //printf("isIndexValid: [%d]\n",isIndexValid);
                    // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid)
                    {
                        Creature *neighbor = _gridArray[x][y];
                        printf("Grid::countNeighbors - neighbor[%p], neighbor.isAlive === [%d]\n",neighbor,neighbor.isAlive);
                      //  printf("Grid::countNeighbors -    !((x == i) && (y == j)) && isIndexValid ----- neighbor.isAlive == [%d]\n",neighbor.isAlive);
                        if (neighbor.isAlive)
                        {
                            //neighbor.isAlive doesn't work, but needs to, to meet the above condition
                            currentCreature.livingNeighbors += 1;
                            if(currentCreature.livingNeighbors != 0){
                                printf("Grid::countNeighbros - currentCreature @ [%d][%d], livingNeighbor += 1:currentValue == [%d]\n",x,y,currentCreature.livingNeighbors);
                            }
                        }
                    }
                }
            }
        }
    }
}
-(void)updateCreatures{
    printf("Grid::updateCreatures - called --- _gridArray count == [%d] \n",(_gridArray.count));
    for (int i = 0;i < GRID_ROWS; i++){
        printf("Grid::updateCreatures - entered outer loop @[%d]\n",i);
        for (int j =0; j < GRID_COLUMNS; j++){
            printf("entered inner loop @[%d]",j);
            Creature *currentCreature = _gridArray[i][j];
            printf("Grid::updateCreatures - currentCreature.livingNeighbors@ [%d][%d] == [%d] [%s]\n",i,j,currentCreature.livingNeighbors, (currentCreature.isAlive?"alive":"not alive"));
            if ( ! currentCreature.isAlive ) {
                printf("Grid::updateCreatures - currentCreature.isAlive is NOT alive \n");
                if ( currentCreature.livingNeighbors == 3){
                    [currentCreature setIsAlive:(YES)];
                printf("Grid::updateCreatures - currentCreature.isAlive set to true \n");
                }
            } else { // creature is alive
                printf("Grid::updateCreatures - currentCreature.isAlive is alive \n");
                if ( currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4){
                    [currentCreature setIsAlive: (NO)];
                    printf("Grid::updateCreatures - currentCreature.isAlive set to false \n");
                }
            }
        }
    }
}
- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}
//-(void)colorPrintReference{
//    printf(ANSI_COLOR_RED     "This text is RED!"     ANSI_COLOR_RESET "\n");
//    printf(ANSI_COLOR_GREEN   "This text is GREEN!"   ANSI_COLOR_RESET "\n");
//    printf(ANSI_COLOR_YELLOW  "This text is YELLOW!"  ANSI_COLOR_RESET "\n");
//    printf(ANSI_COLOR_BLUE    "This text is BLUE!"    ANSI_COLOR_RESET "\n");
//    printf(ANSI_COLOR_MAGENTA "This text is MAGENTA!" ANSI_COLOR_RESET "\n");
//    printf(ANSI_COLOR_CYAN    "This text is CYAN!"    ANSI_COLOR_RESET "\n");
//}
@end