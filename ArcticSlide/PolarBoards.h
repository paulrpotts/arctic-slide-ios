//
//  PolarBoards.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/7/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#define POLAR_DATA_NUM_TILE_VALS 7 // values 0-6 inclusive

extern const int num_polar_levels;
extern const int polar_data_len;
extern const int polar_data_max_tile_val;

extern const char *polar_levels[POLAR_DATA_NUM_TILE_VALS];

#define POLAR_TILE_EMPTY '0'
#define POLAR_TILE_TREE '1'
#define POLAR_TILE_MOUNTAIN '2'
#define POLAR_TILE_HOUSE '3'
#define POLAR_TILE_ICE_BLOCK '4'
#define POLAR_TILE_HEART '5'
#define POLAR_TILE_BOMB '6'
