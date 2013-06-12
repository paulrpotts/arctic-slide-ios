//
//  ArcticSlideModel.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int y_idx;
    int x_idx;
} pos_t;

typedef enum {
    dir_east,
    dir_west,
    dir_south,
    dir_north
} dir_e;

// Plain old C helper functions
pos_t getAdjacentPos( pos_t original_pos, dir_e dir );
BOOL posValid( pos_t pos );
NSString *dirToString( dir_e dir );

static const int board_width = 24, board_height = 4;
// The short board design is part of what makes it so
// easy to get sliding objects stuck against the edges
// of the world or in corners where you can't get the
// penguin avatar around to the other side to push them.
// We could consider a bigger board later and maybe
// implement the original puzzles surrounded by water,
// or something like that.

// Equivalent of C++ class forward declaration
@class ArcticSlideTile; // common base class
@class ArcticSlideBomb;
@class ArcticSlideEmpty;
@class ArcticSlideHeart;
@class ArcticSlideHouse;
@class ArcticSlideIceBlock;
@class ArcticSlideMountain;
@class ArcticSlideTree;

// A struct that wraps up a position and object pointer,
// to use as a return value. It might be valuable for objects
// to know their coordinates, but I'm not fully clear on
// whether that is a win. We'll try it as an experiment.

@interface ArcticSlideModel : NSObject
{
    ArcticSlideTile* board[board_height][board_width];
    pos_t penguinPos;
    dir_e penguinDir;
    int heartCount;
}

- (id)init;
- (id)initWithLevelIndex:(int)level_idx;
- (NSString*) description;

// Getters
- (pos_t)penguinPos;
- (int)heartCount;

// Setters
- (void)setPenguinPos:(pos_t)pos;
- (void)decrementHeartCount;

// The direction it is facing is part of the penguin state.
// If we push the penguin in a direction other than the one
// it is facing, it changes the direction it is facing. If
// we push it in the same direction, it attempts to walk.
- (void)penguinMove:(dir_e)dir;
- (BOOL)penguinPush:(dir_e)dir;
- (ArcticSlideTile*)getTileAdjacentToPenguin:(dir_e)dir;
- (ArcticSlideTile*)getTileAdjacentToPosition:(pos_t)pos
                                  inDirection:(dir_e)dir;
// Change board to support sliding and destruction of
// mountains, ice blocks, and hearts
- (ArcticSlideTile*)setBombAt:(pos_t)pos;
- (ArcticSlideTile*)setHeartAt:(pos_t)pos;
- (ArcticSlideTile*)setIceBlockAt:(pos_t)pos;
- (ArcticSlideTile*)setEmptyAt:(pos_t)pos;

// This cries out for some generic/template/parameterized type support
// so that we can pass in a type as a paramter to a single slide
// method.
- (ArcticSlideTile*)slideBomb:(ArcticSlideBomb**)bomb_p_p
                        inDir:(dir_e)dir
                    withModel:(ArcticSlideModel*)model_p;

- (ArcticSlideTile*)slideHeart:(ArcticSlideHeart**)heart_p_p
                         inDir:(dir_e)dir
                     withModel:(ArcticSlideModel*)model_p;

- (ArcticSlideTile*)slideIceBlock:(ArcticSlideIceBlock**)ice_block_p_p
                            inDir:(dir_e)dir
                        withModel:(ArcticSlideModel*)model_p;

// Temporarily: log queued events
- (void)queueTransition:(NSString*)str_p;

@end

@interface ArcticSlideTile : NSObject
{
    // Must be set on creation
    pos_t pos;
    BOOL is_sliding_accessible;
    BOOL is_penguin_accessible;
    BOOL is_blowupable;
    BOOL is_crushable;
    BOOL is_goal;
}

- (id)init;
- (id)initWithPos:(pos_t)initial_pos;
- (pos_t)pos;
- (BOOL) is_sliding_accessible; // can something slide on this tile?
- (BOOL) is_penguin_accessible; // can a penguin walk on this tile?
- (BOOL) is_blowupable; // can a bomb blow up this tile?
- (BOOL) is_crushable; // can the penguin slide this tile?
- (BOOL) is_goal; // is this tile the goal (home) for hearts?
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
@end

@interface ArcticSlideBomb : ArcticSlideTile
- (id)init;
// Bombs can be pushed and will slide until they hit an
// object and stop. If the object is a mountain, both bomb
// and mountain are destroyed. If another object hits a bomb
// it stops (I think -- I'm not sure it is possible to set
// up a board such that you can slide something into a bomb).

// push is called when the penguin pushes against a tile.
// It returns YES if the penguin can move onto the tile with
// this action. This is only ever the case for a tree or empty
// tile.
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
- (NSString*) description;
@end

@interface ArcticSlideEmpty : ArcticSlideTile
// The penguin can always step onto an empty tile
- (id)init;
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
- (NSString*) description;
@end

@interface ArcticSlideHeart : ArcticSlideTile
- (id)init;
// When a heart hits a house the heart disappears (getting
// all the hearts into the house is how you win the game).
// Otherwise they cannot be destroyed, and slide like other
// slidable items.
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
- (NSString*) description;
@end

@interface ArcticSlideHouse : ArcticSlideTile
- (id)init;
// Houses cannot be pushed and stop other objects except
// hearts. When a heart hits a house the heart disappears
// (getting the hearts into the house is how you win the game).
// So the model should keep track of the number of hearts
// on the board and trigger a "win the level" behavior when
// the last heart is removed.
- (NSString*) description;
// Do we want a "hit with heart" method?
@end

@interface ArcticSlideIceBlock : ArcticSlideTile
- (id)init;
// Ice blocks can be pushed and will slide until they hit
// an object or the edge of the world and stop. If they are pushed
// directly against an object they will be crushed (there should be
// an animation) and disappear.
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
- (NSString*) description;
@end

@interface ArcticSlideMountain : ArcticSlideTile
// Mountains cannot be moved and are destroyed by bombs.
- (NSString*) description;
// Do we want a generic "hit with bomb" method?
@end

@interface ArcticSlideTree : ArcticSlideTile
- (id)init;
// Trees cannot be pushed or destroyed and stop all sliding
// objects, but the penguin avatar character can walk through
// them.
- (BOOL)pushMeInDir:(dir_e)dir
          withModel:(ArcticSlideModel*)model_p;
- (NSString*) description;
@end

