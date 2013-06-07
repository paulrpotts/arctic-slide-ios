//
//  ArcticSlideModel.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int x_idx;
    int y_idx;
} pos_t;

typedef enum {
    dir_east,
    dir_west,
    dir_south,
    dir_north
} dir_e;

// A straight C function to return a pos_t updated with a dir_e;
// the result may be out of bounds
pos_t getUpdatedPos( pos_t original_pos, dir_e dir );
BOOL posValid( pos_t pos );

static const int board_width = 24, board_height = 4;
// The short board design is part of what makes it so
// easy to get sliding objects stuck against the edges
// of the world or in corners where you can't get the
// penguin avatar around to the other side to push them.
// We could consider a bigger board later and maybe
// implement the original puzzles surrounded by water,
// or something like that.

// Equivalent of C++ class forward declaration
@class ArcticSlideTile;
@class ArcticSlideBomb;
@class ArcticSlideEmpty;
@class ArcticSlideHeart;
@class ArcticSlideHouse;
@class ArcticSlideIceBlock;
@class ArcticSlideMountain;
@class ArcticSlideTree;

@interface ArcticSlideModel : NSObject
{
    ArcticSlideTile* board[board_height][board_width];
}

+ (ArcticSlideModel*)getModel;

// Singleton factory methods
- (ArcticSlideBomb*)getBomb;
- (ArcticSlideEmpty*)getEmpty;
- (ArcticSlideHeart*)getHeart;
- (ArcticSlideHouse*)getHouse;
- (ArcticSlideIceBlock*)getIceBlock;
- (ArcticSlideMountain*)getMountain;
- (ArcticSlideTree*)getTree;

- (id)init;
- (id)initWithLevelIndex:(int)level_idx;
- (NSString*) description;
- (ArcticSlideTile*)getTileFromPosition:(pos_t)pos
                            inDirection:(dir_e)dir;
- (void)setTileAtPosition:(pos_t)pos
                       to:(ArcticSlideTile*)type;

@end

@interface ArcticSlideTile : NSObject

// push is called when the penguin avatar pushes on an
// instance of a tile
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;

@end

@interface ArcticSlideBomb : ArcticSlideTile
// Bombs can be pushed and will slide until they hit an
// object and stop. If the object is a mountain, both bomb
// and mountain are destroyed. If another object hits a bomb
// it stops (I think -- I'm not sure it is possible to set
// up a board such that you can slide something into a bomb).

// push is called when the penguin pushes against a tile.
// It returns YES if the penguin can move onto the tile with
// this action. This is only ever the case for a tree or empty
// tile.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideEmpty : ArcticSlideTile
// The penguin can always step onto an empty tile
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (BOOL)slideFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideHeart : ArcticSlideTile
// When a heart hits a house the heart disappears (getting
// all the hearts into the house is how you win the game).
// Otherwise they cannot be destroyed, and slide like other
// slidable items.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideHouse : ArcticSlideTile
// Houses cannot be pushed and stop other objects except
// hearts. When a heart hits a house the heart disappears
// (getting the hearts into the house is how you win the game).
// So the model should keep track of the number of hearts
// on the board and trigger a "win the level" behavior when
// the last heart is removed.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideIceBlock : ArcticSlideTile
// Ice blocks can be pushed and will slide until they hit
// an object and stop. If they are pushed directly against
// an object they will be crushed (there should be an animation)
// and disappear.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideMountain : ArcticSlideTile
// Mountains cannot be moved and are destroyed by bombs.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

@interface ArcticSlideTree : ArcticSlideTile
// Trees cannot be pushed or destroyed and stop all sliding
// objects, but the penguin avatar character can walk through
// them.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir;
- (NSString*) description;
@end

