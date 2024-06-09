#include "bit_rotate.h"

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    uint16_t MAX_MOVE = 16;
    if (n_rotations > 0){
        n_rotations = n_rotations % MAX_MOVE;
    }else{
        n_rotations = (n_rotations % MAX_MOVE)+MAX_MOVE;
    }
    return (bits<<n_rotations | bits >>(MAX_MOVE-n_rotations));
}
