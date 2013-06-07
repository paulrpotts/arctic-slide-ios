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

@interface ArcticSlideTile : NSObject
// Not necessarily useful yet, but I am guessing it might be helpful to
// have a separate base class at some point.

// slide is called on the time tick after an item is successfully
// moved by pushing
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
@end

@interface ArcticSlideTileStateless : ArcticSlideTile
// In implementation, there will be a single shared instance.
@end

@interface ArcticSlideBomb : ArcticSlideTileStateless
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

@interface ArcticSlideEmpty : ArcticSlideTileStateless
// Bombs can be pushed and will slide until they hit an object and stop.
// If the object is a mountain, both bomb and mountain are destroyed and
// there should be an animation. If another object hits a bomb it stops
// (I think -- I'm not sure it is possible to set up a board such that
// you can slide something into a bomb).
- (void)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideHeart : ArcticSlideTileStateless
// When a heart hits a house the heart disappears (getting all the hearts into
// the house is how you win the game). Otherwise they cannot be destroyed,
// and slide like other slidable items.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideHouse : ArcticSlideTileStateless
// Houses cannot be pushed and stop other objects except hearts. When
// a heart hits a house the heart disappears (getting the hearts into
// the house is how you win the game). So the model should keep track
// of the number of hearts on the board and trigger a "win the level"
// behavior when the last heart is destroyed.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideIceBlock : ArcticSlideTileStateless
// Ice blocks can be pushed and will slide until they hit an object
// and stop. If they are pushed directly against an object they will
// be crushed (there should be an animation) and disappear.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlideMountain : ArcticSlideTileStateless
// Mountains cannot be moved and are destroyed by bombs.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

@interface ArcticSlidePenguin : ArcticSlideTile
// The penguin is the avatar. It has the special quality of being able
// to face different directions in the original game, although that's
// because you can click near him to turn him and make him walk in
// different directions. In a touchscreen implementation I'm not sure
// how this should be implemented -- maybe he can slide in discreet steps.
// The penguin has the ability to walk through trees. We might want to
// implement this temporary state using using an "override" object
// reference in the model. Sliding objects might be implemented the
// same way.
@property dir_e penguin_dir;

- (NSString*) description;
@end

@interface ArcticSlideTree : ArcticSlideTile
// Trees cannot be pushed or destroyed and stop all sliding objects, but
// the penguin avatar character can walk through them.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection;
- (NSString*) description;
@end

static const int board_width = 24, board_height = 4;
// The short board design is part of what makes it so easy to get
// sliding objects stuck against the edges of the world or in corners
// where you can no longer get around to the other side to push them.
// We could consider a bigger board later and maybe implement the
// original puzzles surrounded by water, or something like that.

@interface ArcticSlideModel : NSObject
{
    ArcticSlideTile* board[board_height][board_width];
}

// Level layouts are taken from the original Macintosh Polar game
// created by Go Endo. These were originally MacOS resources of
// type 'STGE.' Let's see if we can decode them. Using ResEdit, the
// raw data for 'STGE' resource ID -16000 looks like:
//
// 0x0000 0x0000 0x0003 0x0001
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0001 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0004 0x0000 0x0000 0x0001
// 0x0000 0x0006 0x0000 0x0002
// 0x0000 0x0005 0x0004 0x0005
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0001 0x0000 0x0000
// 0x0001 0x0000 0x0000 0x0001
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0005
// 0x0000 0x0000 0x0000 0x0002
// 0x0003 0x0000 0x0000 0x0001
// 0x0001 0x0000 0x0000 0x0000
// 0x0000 0x0001 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000 0x0000
// 0x0000 0x0000 0x0000
//
// There are 99 16-bit values. My best guess is that this corresponds
// to the 24x4 grid (96 board positions) plus 3 extras for some kind of
// of header of footer data (maybe the total number of hearts is indicated,
// for example). There are 7 unique values, so it seems extremely likely
// that they correspond to our seven different tile types, with zero
// representing a blank space. But the counts of each type don't _quite_
// match up. The first board has:
//
// 8 trees
// 1 bomb
// 2 hearts
// 2 ice blocks
// 2 mountains
// 3 hearts
// 1 house
// 1 penguin (there is always 1 penguin)
//
// While this 'STGE' resource has:
//
// 9 ones,
// 2 twos,
// 2 threes,
// 2 fours,
// 3 fives, and
// 1 six
//
// The counts are very close, so I'm betting that 5 is a heart.
//
// On the first board, the first vertical column goes penguin, tree,
// tree, tree. I don't quite see that, but resources -1599 and -15996
// give me a hint that the "extra" data is at the front: they contain
// 0x0007 and 0x0008 in the 3rd position. So let's try rearranging
// resource -16000 without the first 6 bytes, remove redundant zeroes
// for clarity and look at the values aligned by groups of 24 instead
// of four:
//
// 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 4 0 0
// 1 0 6 0 2 0 5 4 5 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0
// 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 0 0 0 2 3 0 0
// 1 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
//
// Oh yeah. There it is. The left column is actually all trees. There
// are actually nine trees. The rest comes into focus quickly:
//
// empty = 0
// tree = 1
// mountain = 2
// home = 3
// ice block = 4
// heart = 5
// bomb = 6
//
// and the initial 3 values, 0, 0, and 3, I'm betting, indicate
// that the penguin starts at 0,0, most likely encoded as row index,
// column index to correspond to row-major indexing, and there are
// 3 hearts to count down.
//
// Can we validate this with the second board? Yes, it looks
// like there's a 4 indicating 4 hearts. In all the boards I've
// seen so far, the first four, the penguin is in the upper left.
// The fifth resource has 0, 1 for its first two values, so I'm
// guessing I can confirm whether this is horizontal offset first
// or vertical offset first if and when I get to that stage.

@property pos_t penguin_pos;

- (id)init;
- (id)initWithLevelIndex:(int)level_idx;
- (NSString*) description;

- (ArcticSlideTile*)geNeighborTo:(dir_e)dir;
@end

