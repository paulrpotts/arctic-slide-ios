//
//  ArcticSlideModel.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int x_pos;
    int y_pos;
} pos_t;

typedef enum {
    dir_east,
    dir_west,
    dir_south,
    dir_north
} dir_e;

static const int board_width = 24, board_height = 4;
// The short board design is part of what makes it so easy to get
// sliding objects stuck against the edges of the world or in corners
// where you can no longer get around to the other side to push them.
// We could consider a bigger board later and maybe implement the
// original puzzles surrounded by water, or something like that.

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

// Singleton factory methods
- (ArcticSlideBomb*)getBomb;
- (ArcticSlideEmpty*)getEmpty;
- (ArcticSlideHeart*)getHeart;
- (ArcticSlideHouse*)getHouse;
- (ArcticSlideIceBlock*)getIceBlock;
- (ArcticSlideMountain*)getMountain;
- (ArcticSlideTree*)getTree;

@property pos_t penguin_pos;

- (id)init;
- (id)initWithLevelIndex:(int)level_idx;
- (NSString*) description;
- (ArcticSlideTile*)getTile:(pos_t)fromPosition :(dir_e)toDirection;

@end

@interface ArcticSlideTile : NSObject
{
    ArcticSlideModel* __weak model;
}

// push is called when the penguin avatar ppushes on an instance of a tile
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;

// slide is called on the time tick after an item is successfully pushed
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;

@end

@interface ArcticSlideBomb : ArcticSlideTile
// Bombs can be pushed and will slide until they hit an object and stop.
// If the object is a mountain, both bomb and mountain are destroyed and
// there should be an animation. If another object hits a bomb it stops
// (I think -- I'm not sure it is possible to set up a board such that
// you can slide something into a bomb).

// push is called when the penguin pushes against a tile. It returns
// YES if the penguin can move onto the tile with this action. This
// is only ever the case for an empty tile. The rest of the tile actions
// are handled by callbacks to the board model
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideEmpty : ArcticSlideTile
// The penguin can always step onto an empty tile
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideHeart : ArcticSlideTile
// When a heart hits a house the heart disappears (getting all the hearts into
// the house is how you win the game). Otherwise they cannot be destroyed,
// and slide like other slidable items.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideHouse : ArcticSlideTile
// Houses cannot be pushed and stop other objects except hearts. When
// a heart hits a house the heart disappears (getting the hearts into
// the house is how you win the game). So the model should keep track
// of the number of hearts on the board and trigger a "win the level"
// behavior when the last heart is destroyed.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideIceBlock : ArcticSlideTile
// Ice blocks can be pushed and will slide until they hit an object
// and stop. If they are pushed directly against an object they will
// be crushed (there should be an animation) and disappear.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideMountain : ArcticSlideTile
// Mountains cannot be moved and are destroyed by bombs.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideTree : ArcticSlideTile
// Trees cannot be pushed or destroyed and stop all sliding objects, but
// the penguin avatar character can walk through them.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

