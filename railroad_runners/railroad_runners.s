################################################################################
# COMP1521 24T1 -- Assignment 1 -- Railroad Runners!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/24T1/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by ZHANG JINGYUAN (z5408280)
# on 05/03/2024
#
# Version 1.0 (2024-02-27): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
################################################################################

#![tabsize(8)]

# ------------------------------------------------------------------------------
#                                   Constants
# ------------------------------------------------------------------------------

# -------------------------------- C Constants ---------------------------------
TRUE = 1
FALSE = 0

JUMP_KEY = 'w'
LEFT_KEY = 'a'
CROUCH_KEY = 's'
RIGHT_KEY = 'd'
TICK_KEY = '\''
QUIT_KEY = 'q'

ACTION_DURATION = 3
CHUNK_DURATION = 10

SCROLL_SCORE_BONUS = 1
TRAIN_SCORE_BONUS = 1
BARRIER_SCORE_BONUS = 2
CASH_SCORE_BONUS = 3

MAP_HEIGHT = 20
MAP_WIDTH = 5
PLAYER_ROW = 1

PLAYER_RUNNING = 0
PLAYER_CROUCHING = 1
PLAYER_JUMPING = 2

STARTING_COLUMN = MAP_WIDTH / 2

TRAIN_CHAR = 't'
BARRIER_CHAR = 'b'
CASH_CHAR = 'c'
EMPTY_CHAR = ' '
WALL_CHAR = 'w'
RAIL_EDGE = '|'

SAFE_CHUNK_INDEX = 0
NUM_CHUNKS = 14

# --------------------- Useful Offset and Size Constants -----------------------

# struct BlockSpawner offsets
BLOCK_SPAWNER_NEXT_BLOCK_OFFSET = 0
BLOCK_SPAWNER_SAFE_COLUMN_OFFSET = 20
BLOCK_SPAWNER_SIZE = 24

# struct Player offsets
PLAYER_COLUMN_OFFSET = 0
PLAYER_STATE_OFFSET = 4
PLAYER_ACTION_TICKS_LEFT_OFFSET = 8
PLAYER_ON_TRAIN_OFFSET = 12
PLAYER_SCORE_OFFSET = 16
PLAYER_SIZE = 20

SIZEOF_PTR = 4


# ------------------------------------------------------------------------------
#                                 Data Segment
# ------------------------------------------------------------------------------
	.data

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

# ----------------------------- String Constants -------------------------------

print_welcome__msg_1:
	.asciiz "Welcome to Railroad Runners!\n"
print_welcome__msg_2_1:
	.asciiz "Use the following keys to control your character: ("
print_welcome__msg_2_2:
	.asciiz "):\n"
print_welcome__msg_3:
	.asciiz ": Move left\n"
print_welcome__msg_4:
	.asciiz ": Move right\n"
print_welcome__msg_5_1:
	.asciiz ": Crouch ("
print_welcome__msg_5_2:
	.asciiz ")\n"
print_welcome__msg_6_1:
	.asciiz ": Jump ("
print_welcome__msg_6_2:
	.asciiz ")\n"
print_welcome__msg_7_1:
	.asciiz "or press "
print_welcome__msg_7_2:
	.asciiz " to continue moving forward.\n"
print_welcome__msg_8_1:
	.asciiz "You must crouch under barriers ("
print_welcome__msg_8_2:
	.asciiz ")\n"
print_welcome__msg_9_1:
	.asciiz "and jump over trains ("
print_welcome__msg_9_2:
	.asciiz ").\n"
print_welcome__msg_10_1:
	.asciiz "You should avoid walls ("
print_welcome__msg_10_2:
	.asciiz ") and collect cash ("
print_welcome__msg_10_3:
	.asciiz ").\n"
print_welcome__msg_11:
	.asciiz "On top of collecting cash, running on trains and going under barriers will get you extra points.\n"
print_welcome__msg_12_1:
	.asciiz "When you've had enough, press "
print_welcome__msg_12_2:
	.asciiz " to quit. Have fun!\n"

get_command__invalid_input_msg:
	.asciiz "Invalid input!\n"

main__game_over_msg:
	.asciiz "Game over, thanks for playing 😊!\n"

display_game__score_msg:
	.asciiz "Score: "

handle_collision__barrier_msg:
	.asciiz "💥 You ran into a barrier! 😵\n"
handle_collision__train_msg:
	.asciiz "💥 You ran into a train! 😵\n"
handle_collision__wall_msg:
	.asciiz "💥 You ran into a wall! 😵\n"

maybe_pick_new_chunk__column_msg_1:
	.asciiz "Column "
maybe_pick_new_chunk__column_msg_2:
	.asciiz ": "
maybe_pick_new_chunk__safe_msg:
	.asciiz "New safe column: "

get_seed__prompt_msg:
	.asciiz "Enter a non-zero number for the seed: "
get_seed__prompt_invalid_msg:
	.asciiz "Invalid seed!\n"
get_seed__set_msg:
	.asciiz "Seed set to "

TRAIN_SPRITE:
	.asciiz "🚆"
BARRIER_SPRITE:
	.asciiz "🚧"
CASH_SPRITE:
	.asciiz "💵"
EMPTY_SPRITE:
	.asciiz "  "
WALL_SPRITE:
	.asciiz "🧱"

PLAYER_RUNNING_SPRITE:
	.asciiz "🏃"
PLAYER_CROUCHING_SPRITE:
	.asciiz "🧎"
PLAYER_JUMPING_SPRITE:
	.asciiz "🤸"

# ------------------------------- Chunk Layouts --------------------------------

SAFE_CHUNK: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, '\0',
CHUNK_1: # char[]
	.byte EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, WALL_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, BARRIER_CHAR, '\0',
CHUNK_2: # char[]
	.byte CASH_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, BARRIER_CHAR, EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_3: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_4: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_5: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, EMPTY_CHAR, TRAIN_CHAR, EMPTY_CHAR, EMPTY_CHAR, '\0',
CHUNK_6: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, BARRIER_CHAR, EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, CASH_CHAR, EMPTY_CHAR, BARRIER_CHAR, '\0'
CHUNK_7: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, WALL_CHAR, '\0',
CHUNK_8: # char[]
	.byte CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, CASH_CHAR, EMPTY_CHAR, '\0',
CHUNK_9: # char[]
	.byte CASH_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_10: # char[]
	.byte CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, CASH_CHAR, '\0',
CHUNK_11: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, WALL_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, TRAIN_CHAR, '\0',
CHUNK_12: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, CASH_CHAR, '\0',
CHUNK_13: # char[]
	.byte EMPTY_CHAR, EMPTY_CHAR, EMPTY_CHAR, WALL_CHAR, WALL_CHAR, '\0',

CHUNKS:	# char*[]
	.word SAFE_CHUNK, CHUNK_1, CHUNK_2, CHUNK_3, CHUNK_4, CHUNK_5, CHUNK_6, CHUNK_7, CHUNK_8, CHUNK_9, CHUNK_10, CHUNK_11, CHUNK_12, CHUNK_13

# ----------------------------- Global Variables -------------------------------

g_block_spawner: # struct BlockSpawner
	# char *next_block[MAP_WIDTH], offset 0
	.word 0, 0, 0, 0, 0
	# int safe_column, offset 20
	.word STARTING_COLUMN

g_map: # char[MAP_HEIGHT][MAP_WIDTH]
	.space MAP_HEIGHT * MAP_WIDTH

g_player: # struct Player
	# int column, offset 0
	.word STARTING_COLUMN
	# int state, offset 4
	.word PLAYER_RUNNING
	# int action_ticks_left, offset 8
	.word 0
	# int on_train, offset 12
	.word FALSE
	# int score, offset 16
	.word 0

g_rng_state: # unsigned
	.word 1

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!

# ------------------------------------------------------------------------------
#                                 Text Segment
# ------------------------------------------------------------------------------
	.text

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [X] print_welcome
#  SUBSET 1
#  - [X] get_command
#  - [X] main
#  - [X] init_map
#  SUBSET 2
#  - [X] run_game
#  - [X] display_game
#  - [X] maybe_print_player
#  - [X] handle_command
#  SUBSET 3
#  - [X] handle_collision
#  - [X] maybe_pick_new_chunk
#  - [X] do_tick
#  PROVIDED
#  - [X] get_seed
#  - [X] rng
#  - [X] read_char
################################################################################

################################################################################
# .TEXT <print_welcome>
print_welcome:
	# Subset:   0
	#
	# Args:     None
	#
	# Returns:  None
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

print_welcome__prologue:
print_welcome__body:
	la 	$a0, print_welcome__msg_1  	# printf("Welcome to Railroad Runners!\n");
	li 	$v0, 4                      	# System call for print string
	syscall

	la	$a0, print_welcome__msg_2_1
	li	$v0, 4
	syscall					# printf("Use the following keys to control your character: (%s):\n",
	la	$a0, PLAYER_RUNNING_SPRITE	#
	li	$v0, 4				#
	syscall					# PLAYER_RUNNING_SPRITE
	la	$a0, print_welcome__msg_2_2	#
	li	$v0, 4				#
	syscall					# );

	li	$a0, LEFT_KEY
	li	$v0, 11
	syscall					# printf("a");
	la	$a0, print_welcome__msg_3	#
	li	$v0, 4				#
	syscall					# printf("%c: Move left\n",

	li	$a0, RIGHT_KEY
	li	$v0, 11
	syscall					# printf("d");
	la	$a0, print_welcome__msg_4	#
	li	$v0, 4				#
	syscall					# printf("%c: Move right\n")

	li	$a0, CROUCH_KEY
	li	$v0, 11
	syscall					# printf("s");
	la	$a0, print_welcome__msg_5_1	#
	li	$v0, 4				#
	syscall					# printf("%c: Crouch (%s)\n",
	la	$a0, PLAYER_CROUCHING_SPRITE	#
	li	$v0, 4				#
	syscall					# PLAYER_CROUCHING_SPRITE
	la	$a0, print_welcome__msg_5_2	#
	li	$v0, 4				#
	syscall					# );

	li	$a0, JUMP_KEY
	li	$v0, 11
	syscall					# printf("w");
	la	$a0, print_welcome__msg_6_1	#
	li	$v0, 4				#
	syscall					# printf("%c: Jump (%s)\n",
	la	$a0, PLAYER_JUMPING_SPRITE	#
	li	$v0, 4				#
	syscall					# PLAYER_JUMPING_SPRITE
	la	$a0, print_welcome__msg_6_2	#
	li	$v0, 4				#
	syscall					# );

	la	$a0, print_welcome__msg_7_1
	li	$v0, 4
	syscall					# printf("or press 
	li	$a0, TICK_KEY			#
	li	$v0, 11				#
	syscall					# TICK_KEY;
	la	$a0, print_welcome__msg_7_2	#
	li	$v0, 4				#
	syscall					# to continue moving forward.\n");

	la	$a0, print_welcome__msg_8_1
	li	$v0, 4
	syscall					# printf("You must crouch under barriers (%s)\n",
	la	$a0, BARRIER_SPRITE		#
	li	$v0, 4				#
	syscall					# BARRIER_SPRITE
	la	$a0, print_welcome__msg_8_2	#
	li	$v0, 4				# );
	syscall

	la	$a0, print_welcome__msg_9_1
	li	$v0, 4
	syscall					# printf("and jump over trains (%s).\n",
	la	$a0, TRAIN_SPRITE		#
	li	$v0, 4				#
	syscall					# TRAIN_SPRITE
	la	$a0, print_welcome__msg_9_2	#
	li	$v0, 4				#
	syscall					# );

	la	$a0, print_welcome__msg_10_1
	li	$v0, 4
	syscall					# printf("You should avoid walls (%s), 
	la	$a0, WALL_SPRITE		#
	li	$v0, 4				#
	syscall					# TRAIN_SPRITE
	la	$a0, print_welcome__msg_10_2	#
	li	$v0, 4				#
	syscall					# and collect cash (%s),
	la	$a0, CASH_SPRITE		#
	li	$v0, 4				#
	syscall					# CASH_SPRITE
	la	$a0, print_welcome__msg_10_3	#
	li	$v0, 4				#
	syscall					# );

	la	$a0, print_welcome__msg_11
	li	$v0, 4
	syscall					# printf("On top of collecting cash, running on trains and"
						#  "going under barriers will get you extra points.\n");

	la	$a0, print_welcome__msg_12_1
	li	$v0, 4
	syscall					# printf("When you've had enough, press 
	li	$a0, QUIT_KEY			#
	li	$v0, 11				#
	syscall					# QUIT_KEY
	la	$a0, print_welcome__msg_12_2	#
	li	$v0, 4				#
	syscall					# to quit. Have fun!\n")
	
print_welcome__epilogue:
	jr	$ra


################################################################################
# .TEXT <get_command>
	.text
get_command:
	# Subset:   1
	#
	# Args:     None
	#
	# Returns:  $v0: char
	#
	# Frame:    [$ra]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   get_command
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

get_command__prologue:
	push	$ra					# move current $ra into stack
get_command__body:	
	jal	read_char
	beq 	$v0, QUIT_KEY, get_command__epilogue 	# if (input != QUIT_KEY) {goto get_command__epilogue};
        beq 	$v0, JUMP_KEY, get_command__epilogue 	# if (input != JUMP_KEY) {goto get_command__epilogue};
        beq 	$v0, LEFT_KEY, get_command__epilogue	# if (input != LEFT_KEY) {goto get_command__epilogue};
        beq 	$v0, CROUCH_KEY, get_command__epilogue 	# if (input != CROUCH_KEY) {goto get_command__epilogue};
        beq 	$v0, RIGHT_KEY, get_command__epilogue	# if (input != RIGHT_KEY) {goto get_command__epilogue};
        beq 	$v0, TICK_KEY, get_command__epilogue	# if (input != TICK_KEY) {goto get_command__epilogue};

	# Input was invalid
        li 	$v0, 4
        la 	$a0, get_command__invalid_input_msg
        syscall						# printf("Invalid input!\n");
        j 	get_command__body                 	# Jump back to start of loop
	
get_command__epilogue:
	pop	$ra					# return $ra from stack
	jr	$ra


################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   1
	#
	# Args:     None
	#
	# Returns:  $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [...]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   main
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

main__prologue:
	push	$ra				# move current $ra into stack
main__body:
	jal	print_welcome			# print_welcome();
	jal	get_seed			# get_seed();

	la	$a0, g_map			# init_map requires "g_map" in $a0;
	jal	init_map			# init_map(g_map);

	la	$a0, g_map			# display_game requires a new "g_map" in a0;
	la	$a1, g_player			# display game requires "g_player" in a1;
	jal	display_game			# display_game(g_map, &g_player);

main_run_game:
	jal	get_command

	la	$a0, g_map			# run_game requires a new "g_map" in a0;
	la	$a1, g_player			# run_game requires a new "g_player" in a1;
	la	$a2, g_block_spawner		# run_game requires "g_block_spawner" in a2;
	move	$a3, $v0			# run_game requires return value from get_command in a3;
	jal	run_game

	beq	$v0, FALSE, main__epilogue	# if run_game returns FALSE goto main_epilogue;
	
	la	$a0, g_map			# display_game requries a new "g_map" in a0;
	la	$a1, g_player			# display_game requries a new "g_player" in a1;
	jal	display_game

	j	main_run_game			# continue while loop;

main__epilogue:
	li	$v0, 4
	la	$a0, main__game_over_msg
	syscall					# printf("Game over, thanks for playing 😊!\n");
	li	$v0, 0				# set return value to 0;
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <init_map>
	.text
init_map:
	# Subset:   1
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $t0: int i
	#   - $t1: int j
	#
	# Returns:  None
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [$t2]
	#
	# Locals:
	#   - 'i' in $t0
	#   - 'j' in $t1
	#   - 'map[MAP_HEIGHT][MAP_WIDTH]' in $t2
	#   - 'address of map[i][j]' in $t3
	#   - 'EMPTY CHAR' in $t4
	#   - 'Hard coded address offset' in $t5
	#   - 'Hard coded char' in $t6
	#
	# Structure:
	#   init_map
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

init_map__prologue:
init_map__body:
init_map_i_loop_init:
	li	$t0, 0					# $t0 = int i;
init_map_i_loop_cond:
	bge	$t0, MAP_HEIGHT, init_map_i_loop_end	# if (i >= Map_height) goto init_map_i_loop_end
init_map_i_loop_body:
init_map_j_loop_init:
	li	$t1, 0					# $t1 = int j;
init_map_j_loop_cond:
	bge	$t1, MAP_WIDTH, init_map_j_loop_end	# if (j >= MAP_WIDTH) goto init_map_j_loop_end
init_map_j_loop_body:
	move	$t2, $a0				# load array of map into $t2
	mul	$t3, $t0, MAP_WIDTH			# address of i in map (i * MAP_WIDTH)
	add	$t3, $t3, $t1				# address of i and j in map (i * MAP_WIDTH + j * 1)	
	add	$t2, $t2, $t3				# load address into map
	li	$t4, EMPTY_CHAR
	sb	$t4, 0($t2)				# map[i][j] = EMPTY_CHAR;
init_map_j_loop_iter:
	addi	$t1, $t1, 1				# j++
	j	init_map_j_loop_cond
init_map_j_loop_end:
init_map_i_loop_iter:
	addi	$t0, $t0, 1				# i++
	j	init_map_i_loop_cond
init_map_i_loop_end:

init_map_hard_code_map:
init_map_wall_char:
	move	$t2, $a0
	li	$t5, 30					# map[6][0]
	add	$t2, $t2, $t5
	li	$t6, WALL_CHAR
	sb	$t6, ($t2)				# map[6][0] = WALL_CHAR;
init_map_train_char:
	move	$t2, $a0
	li	$t5, 31
	add	$t2, $t2, $t5
	li	$t6, TRAIN_CHAR
	sb	$t6, ($t2)				# map[6][1] = TRAIN_CHAR;
init_map_cash_char:
	move	$t2, $a0
	li	$t5, 32
	add	$t2, $t2, $t5
	li	$t6, CASH_CHAR
	sb	$t6, ($t2)				# map[6][2] = CASH_CHAR;
init_map_barrier_char:
	move	$t2, $a0
	li	$t5, 42
	add	$t2, $t2, $t5
	li	$t6, BARRIER_CHAR
	sb	$t6, ($t2)				# map[8][2] = BARRIER_CHAR;

init_map__epilogue:
	jr	$ra


################################################################################
# .TEXT <run_game>
	.text
run_game:
	# Subset:   2
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $a1: struct Player *player
	#   - $a2: struct BlockSpawner *block_spawner
	#   - $a3: char input
	#
	# Returns:  $v0: int
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [...]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
	#   - '$a0' in $s0
	#   - '$a1' in $s1
	#
	# Structure:
	#   run_game
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

run_game__prologue:
	push	$ra					# push $ra into stack
	push	$s0					# push $s0 into stack
	push	$s1					# push $s1 into stack
run_game__body:
	bne	$a3, QUIT_KEY, run_game_continue	# if (input == QUIT_KEY) {
	li	$v0, FALSE				# return FALSE;
	j	run_game__epilogue			# }
run_game_continue:
	move	$s0, $a0				# prevent clobbering $a0
	move	$s1, $a1				# prevent cloberring $a1

	jal	handle_command				# handle_command(map, player, block_spawner, input);

	move	$a0, $s0				# return $a0
	move	$a1, $s1				# return $a1
	jal	handle_collision			# return handle_collision(map, player);
run_game__epilogue:
	pop	$s1					# pop $s1 from stack
	pop	$s0					# pop $s0 from stack
	pop	$ra					# pop $a0 from stack
	jr	$ra


################################################################################
# .TEXT <display_game>
	.text
display_game:
	# Subset:   2
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $a1: struct Player *player
	#
	# Returns:  None
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]
	# Uses:     [...]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
	#   - 'i' in $s0
	#   - 'j' in $s1
	#   - '$a0' in $s0
	#   - '$a1' in $s1
	#   - 'return value of maybe_print_player' in $t0
	#   - 'address of $a0' in $t1
	#   - 'offset of i and j' in $t2
	#   - 'map[i][j]' in $t3
	#
	# Structure:
	#   display_game
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

display_game__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	move	$s2, $a0				# save $a0 into $s2
	move	$s3, $a1				# save $a1 into $s3
display_game__body:
display_outer_loop_init:
	li	$s0, MAP_HEIGHT
	addi	$s0, $s0, -1				# int i = MAP_HEIGHT - 1;
display_outer_loop_cond:
	bltz	$s0, display_outer_loop_end		# if (i < 0) goto outer_loop_end;
display_outer_loop_body:
display_inner_loop_init:
	li	$s1, 0					# int j = 0;
display_inner_loop_cond:
	bge	$s1, MAP_WIDTH, display_inner_loop_end	# if (j >= 5) goto inner_loop_end
display_inner_loop_body:
	li	$v0, 11					# syscall 11: print_char
	li	$a0, RAIL_EDGE			
	syscall						# printf("%c", RAIL_EDGE);
	
	move	$a0, $s3				# restore $a0 from $s3
	move	$a1, $s0				# $a1 = int i
	move	$a2, $s1				# $a2 = int j
	jal	maybe_print_player			#
	move	$t0, $v0				# move return value into $t0

	beq	$t0, FALSE, display_continue_inner_loop	# if ($t0 == FALSE) goto display_continue_inner_loop;
	j	inner_loop_iter
display_continue_inner_loop:
	move	$t1, $s2				# move map into $t1
	mul	$t2, $s0, MAP_WIDTH			# calculate offset of i
	add	$t2, $t2, $s1				# calculate and add offset of j
	add	$t1, $t1, $t2				# add offset to address
	lb	$t3, ($t1)				# char map_char = map[i][j];

	beq	$t3, EMPTY_CHAR, print_empty_sprite	# if (map_char == EMPTY_CHAR) {goto print_empty_sprite};
	beq	$t3, BARRIER_CHAR, print_barrier_sprite	# elif (map_char == BARRIER_CHAR) {goto print_barrier_sprite};
	beq	$t3, TRAIN_CHAR, print_train_sprite	# elif (map_char == TRAIN_CHAR) {goto print_train_sprite};
	beq	$t3, CASH_CHAR, print_cash_sprite	# elif (map_char == CASH_CHAR) {goto print_cash_sprite};
	beq	$t3, WALL_CHAR, print_wall_sprite	# elif (map_char == WALL_CHAR) {goto print_wall_sprite};
	j	inner_loop_iter				# else {goto inner_loop_iter}
print_empty_sprite:
	la	$a0, EMPTY_SPRITE	
	li	$v0, 4
	syscall						# printf(EMPTY_SPRITE);
	j	inner_loop_iter
print_barrier_sprite:
	la	$a0, BARRIER_SPRITE	
	li	$v0, 4
	syscall						# printf(BARRIER_SPRITE);
	j	inner_loop_iter
print_train_sprite:
	la	$a0, TRAIN_SPRITE	
	li	$v0, 4
	syscall						# printf(TRAIN_SPRITE);
	j	inner_loop_iter
print_cash_sprite:
	la	$a0, CASH_SPRITE	
	li	$v0, 4
	syscall						# printf(CASH_SPRITE);
	j	inner_loop_iter
print_wall_sprite:
	la	$a0, WALL_SPRITE	
	li	$v0, 4
	syscall						# printf(WALL_SPRITE);
	j	inner_loop_iter
inner_loop_iter:
	li	$v0, 11					# syscall 11: print_char
	li	$a0, RAIL_EDGE				
	syscall						# printf("%c", RAIL_EDGE);

	addi	$s1, $s1, 1				# ++j
	j	display_inner_loop_cond
display_inner_loop_end:
	li	$v0, 11					# syscall 11: print_char
	li	$a0, '\n'				#
	syscall						# printf("%c", "\n");
display_outer_loop_iter:
	addi	$s0, $s0, -1				# i--;
	j	display_outer_loop_cond
display_outer_loop_end:
	li	$v0, 4
	la	$a0, display_game__score_msg
	syscall						# printf("Score: ");
	li	$v0, 1					#
	lw	$a0, PLAYER_SCORE_OFFSET($s3)		#
	syscall						# printf("%d", player->score);
	li	$v0, 11					# syscall 11: print_char
	li	$a0, '\n'				#
	syscall						# printf("%c", "\n");
display_game__epilogue:
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <maybe_print_player>
	.text
maybe_print_player:
	# Subset:   2
	#
	# Args:
	#   - $a0: struct Player *player
	#   - $a1: int row
	#   - $a2: int column
	#
	# Returns:  $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - '$a0' in $t0
	#   - '$a1' in $t1
	#   - '$a2' in $t2
	#   - 'player->column' in $t3
	#   - 'player->state' in $t4
	#
	# Structure:
	#   maybe_print_player
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

maybe_print_player__prologue:
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
maybe_print_player__body:
maybe_check_row:
	beq	$t1, PLAYER_ROW, maybe_check_column 			# if (row == PLAYER_ROW) {goto maybe_check_column};
	j	maybe_print_player_false				# return FALSE;
maybe_check_column:
	lw	$t3, PLAYER_COLUMN_OFFSET($t0)				# load player->column into $t3;
	beq	$t2, $t3, maybe_check_player_state			# if (column == player->column) { 
									# goto maybe check_player_state};
	j	maybe_print_player_false				# return FALSE;
maybe_check_player_state:
	lw	$t4, PLAYER_STATE_OFFSET($t0)				# load player->state into $t4
	beq	$t4, PLAYER_RUNNING, maybe_print_player_running		# if (player->state == PLAYER_RUNNING) {
									# goto {maybe_print_player_running};
	beq	$t4, PLAYER_CROUCHING, maybe_print_player_crouching	# else if (player->state == PLAYER_CROUCHING) {
									# goto maybe_print_player_crouching};
	beq	$t4, PLAYER_JUMPING, maybe_print_player_jumping		# else if (player->state == PLAYER_JUMPING) {
									# goto maybe_print_player_jumping};
	j	maybe_return_true					# else {return true}
maybe_print_player_running:
	li	$a0, PLAYER_RUNNING_SPRITE
	li	$v0, 4
	syscall								# printf(PLAYER_RUNNING_SPRITE);
	j	maybe_return_true
maybe_print_player_crouching:
	li	$a0, PLAYER_CROUCHING_SPRITE
	li	$v0, 4
	syscall								# printf(PLAYER_CROUCHING_SPRITE);
	j	maybe_return_true
maybe_print_player_jumping:
	li	$a0, PLAYER_JUMPING_SPRITE
	li	$v0, 4
	syscall								# printf(PLAYER_JUMPING_SPRITE);
	j	maybe_return_true
maybe_return_true:
	li	$v0, TRUE						# return TRUE
	j	maybe_print_player__epilogue
maybe_print_player_false:
	li	$v0, FALSE						# return FALSE
maybe_print_player__epilogue:
	jr	$ra


################################################################################
# .TEXT <handle_command>
	.text
handle_command:
	# Subset:   2
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $a1: struct Player *player
	#   - $a2: struct BlockSpawner *block_spawner
	#   - $a3: char input
	#
	# Returns:  None
	#
	# Frame:    [$ra]
	# Uses:     [...]
	# Clobbers: [$t0, $t1, $t2]
	#
	# Locals:
	#   - 'player->column' in $t0
	#   - 'player->state' in $t1
	#   - 'player->action_ticks_left' in $t2
	#
	# Structure:
	#   handle_command
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

handle_command__prologue:
	push	$ra
handle_command__body:
	lw	$t0, PLAYER_COLUMN_OFFSET($a1)
	lw	$t1, PLAYER_STATE_OFFSET($a1)
	lw	$t2, PLAYER_ACTION_TICKS_LEFT_OFFSET($a1)
handle_command_check_left_key:
	bne	$a3, LEFT_KEY, handle_command_check_right_key		#if (input == LEFT_KEY) {
	ble	$t0, 0, handle_command_check_right_key			# if (player->column > 0) {
	addi	$t0, $t0, -1						#
	sw	$t0, PLAYER_COLUMN_OFFSET($a1)				#  --player->column;
	j	handle_command__epilogue				# }
handle_command_check_right_key:
	bne	$a3, RIGHT_KEY, handle_command_check_jump_key		# } else if (input == RIGHT_KEY) {
	li	$t2, MAP_WIDTH						#	
	addi	$t2, $t2, -1						#
	bge	$t0, $t2, handle_command_check_jump_key			#   if (player->column < MAP_WIDTH - 1) {
	addi	$t0, $t0, 1						#		
	sw	$t0, PLAYER_COLUMN_OFFSET($a1)				#    ++player->column;
	j	handle_command__epilogue				# }
handle_command_check_jump_key:
	bne	$a3, JUMP_KEY, handle_command_check_crouch_key		# } else if (input == JUMP_KEY) {
	bne	$t1, PLAYER_RUNNING, handle_command_check_crouch_key	# if (player->state == PLAYER_RUNNING) {
	li	$t1, PLAYER_JUMPING					#		
	li	$t2, ACTION_DURATION					#		
	sw	$t1, PLAYER_STATE_OFFSET($a1)				#  player->state = PLAYER_JUMPING;
	sw	$t2, PLAYER_ACTION_TICKS_LEFT_OFFSET($a1)		#  player->action_ticks_left = ACTION_DURATION;
	j	handle_command__epilogue				# }
handle_command_check_crouch_key:
	bne	$a3, CROUCH_KEY, handle_command_check_tick_key		# } else if (input == CROUCH_KEY) {
	bne	$t1, PLAYER_RUNNING, handle_command_check_tick_key	# if (player->state == PLAYER_RUNNING) {
	li	$t1, PLAYER_CROUCHING					#
	li	$t2, ACTION_DURATION					#
	sw	$t1, PLAYER_STATE_OFFSET($a1)				#  player->state = PLAYER_CROUCHING;
	sw	$t2, PLAYER_ACTION_TICKS_LEFT_OFFSET($a1)		#  player->action_ticks_left = ACTION_DURATION;
	j	handle_command__epilogue				# }
handle_command_check_tick_key:
	bne	$a3, TICK_KEY, handle_command__epilogue			# } else if (input == TICK_KEY) {
	jal	do_tick							#   do_tick(map, player, block_spawner);
									# }
handle_command__epilogue:						#}				
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <handle_collision>
	.text
handle_collision:
	# Subset:   3
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $a1: struct Player *player
	#
	# Returns:  $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - 'player -> column' in $t0
	#   - 'player -> state' in $t2
	#   - 'player -> score' in $t3
	#   - 'player -> on_train' in $t4
	#   - 
	#
	# Structure:
	#   handle_collision
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

handle_collision__prologue:
	lw	$t0, PLAYER_COLUMN_OFFSET($a1)
	lw	$t1, PLAYER_STATE_OFFSET($a1)
	lw	$t2, PLAYER_SCORE_OFFSET($a1)
	lw	$t3, PLAYER_ON_TRAIN_OFFSET($a1)

handle_collision__body:
	move	$t4, $a0
	li	$t5, PLAYER_ROW
	mul	$t5, $t5, MAP_WIDTH
	add	$t6, $t0, $t5
	add	$t4, $t4, $t6
	lb	$t7, ($t4)						# char *map_char = 
									# &map[PLAYER_ROW][player->column];

	bne	$t7, BARRIER_CHAR, handle_collision_check_train		# if (*map_char != BARRIER_CHAR) {
									# goto handle_collision_check_train};

	beq	$t1, PLAYER_CROUCHING, handle_collision_barrier_score	# if (player->state != PLAYER_CROUCHING) {
	li	$v0, 4							#
	li	$a0, handle_collision__barrier_msg			#  printf("💥 You ran into a barrier! 😵\n");
	syscall								#
	li	$v0, FALSE						#  return FALSE;
	j	handle_collision__epilogue				#}
handle_collision_barrier_score:
	addi	$t2, $t2, BARRIER_SCORE_BONUS
	sw	$t2, PLAYER_SCORE_OFFSET($a1)				# player->score += BARRIER_SCORE_BONUS;
handle_collision_check_train:
	bne	$t7, TRAIN_CHAR, handle_collision_not_on_train		# if (*map_char !=TRAIN_CHAR){
									# goto handle_collision_not_on_train};

	bne	$t1, PLAYER_JUMPING, handle_collision_check_on_train	# if (player->state != PLAYER_JUMPING) {
									# goto handle_collision_check_on_train};
	j	handle_collision_on_train_true				# else {goto handle_collision_on_train_true};
handle_collision_check_on_train:
	beq	$t3, TRUE, handle_collision_on_train_true		# if (!player->on_train) {
									# goto handle_collision_on_train_true};
	li	$a0, handle_collision__train_msg			
	li	$v0, 4
	syscall								# printf("💥 You ran into a train! 😵\n");
	li	$v0, FALSE						# return FALSE;
	j	handle_collision__epilogue
handle_collision_on_train_true:
	li	$t9, TRUE
	sb	$t9, PLAYER_ON_TRAIN_OFFSET($a1)			# player->on_train = TRUE;

	beq	$t1, PLAYER_JUMPING, handle_collision_check_wall 	# if (player->state != PLAYER_JUMPING) {
	addi	$t2, $t2, TRAIN_SCORE_BONUS				#
	sw	$t2, PLAYER_SCORE_OFFSET($a1)				#  player->score += TRAIN_SCORE_BONUS;
	j	handle_collision_check_wall				# }
handle_collision_not_on_train:
	li	$9, FALSE						#} else {
	sb	$9, PLAYER_ON_TRAIN_OFFSET($a1)				#  player->on_train = FALSE;
									#}
handle_collision_check_wall:
	bne	$t7, WALL_CHAR, handle_collision_check_cash		# if (*map_char == WALL_CHAR) {
	li	$v0, 4							#
	la	$a0, handle_collision__wall_msg				#
	syscall								#  printf("💥 You ran into a wall! 😵\n");
	li	$v0, FALSE						#  return FALSE;
	j	handle_collision__epilogue				#}
handle_collision_check_cash:
	bne	$t7, CASH_CHAR, handle_collision_return_true		# if (*map_char == CASH_CHAR) {
	addi	$t2, $t2, CASH_SCORE_BONUS				#
	sw	$t2, PLAYER_SCORE_OFFSET($a1)				#  player->score += CASH_SCORE_BONUS;
	li	$t8, EMPTY_CHAR						#
	sb	$t8, ($t4)						#  *map_char = EMPTY_CHAR;
									#}
handle_collision_return_true:
	li	$v0, TRUE						# return TRUE;
handle_collision__epilogue:
	jr	$ra


################################################################################
# .TEXT <maybe_pick_new_chunk>
	.text
maybe_pick_new_chunk:
	# Subset:   3
	#
	# Args:
	#   - $a0: struct BlockSpawner *block_spawner
	#
	# Returns:  None
	#
	# Frame:    [$r0, $s0, $s1, $s2, $s3, $s4, $s5, $s6]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   maybe_pick_new_chunk
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

maybe_pick_new_chunk__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push 	$s4
	push	$s5
	push	$s6
maybe_pick_new_chunk__body:
	move	$s0, $a0
	li	$s5, FALSE					# int new_safe_column_required = FALSE;
maybe_column_loop_init:
	li	$s1, 0						# int column = 0
maybe_column_loop_cond:
	bge	$s1, MAP_WIDTH, maybe_column_loop_end		# if (column >= MAP_WIDTH) {goto maybe_oclumn_loop_end};
maybe_column_loop_body:
	la	$s6, BLOCK_SPAWNER_NEXT_BLOCK_OFFSET($s0)
	mul	$t2, $s1, 4
	add	$s6, $t2
	lw	$t3, ($s6)					# char const **next_block_ptr = 
								# &block_spawner->next_block[column];
	beqz	$t3, maybe_generate_chunk			# if (*next_block_ptr < 0) {goto maybe_generate_chunk}
	lb	$t3, ($t3)					 
	beqz	$t3, maybe_generate_chunk			# if (**next_block_ptr < 0) {goto maybe_generate_chunk}
	j	maybe_column_loop_iter
maybe_generate_chunk:
	jal	rng
	move	$s3, $v0
	remu	$s3, $s3, NUM_CHUNKS				# int chunk = rng() % NUM_CHUNKS;

	li	$v0, 4
	la	$a0, maybe_pick_new_chunk__column_msg_1
	syscall							#
	li	$v0, 1						#
	move	$a0, $s1					#
	syscall							#
	li	$v0, 4						#
	la	$a0, maybe_pick_new_chunk__column_msg_2		#
	syscall							# 
	li	$v0, 1						#
	move	$a0, $s3					#
	syscall							# printf("Column %d: %d", column, chunk);
	li	$v0, 11						# syscall 11: print_char
	li	$a0, '\n'					#
	syscall							# printf("%c", '\n');

	la	$t7, CHUNKS
	mul	$s3, $s3, 4
	add	$s3, $s3, $t7
	lw	$t3, ($s3)					# CHUNKS[chunk]

	move	$t2, $t3
	sw	$t2, ($s6)					# *next_block_ptr = CHUNKS[chunk];
maybe_check_column_safe:
	lw	$s4, BLOCK_SPAWNER_SAFE_COLUMN_OFFSET($s0)
	bne	$s1, $s4, maybe_column_loop_iter		# if (column == block_spawner->safe_column) {
	li	$s5, TRUE					# new_safe_column_required = TRUE;
								#}
maybe_column_loop_iter:
	addi	$s1, $s1, 1					# ++column
	j	maybe_column_loop_cond
maybe_column_loop_end:
maybe_new_safe_column_required:
	beq	$s5, FALSE, maybe_pick_new_chunk__epilogue	# if (new_safe_column_required) {
	jal	rng						# 
	move	$t8, $v0					#
	remu	$t8, $t8, MAP_WIDTH				# int safe_column = rng() % MAP_WIDTH;
	
	li	$v0, 4						#
	la	$a0, maybe_pick_new_chunk__safe_msg		#
	syscall							#
	li	$v0, 1						#
	move	$a0, $t8					#
	syscall							# printf("New safe column: %d", safe_column);
	li	$v0, 11						#   syscall 11: print_char
	li	$a0, '\n'					#
	syscall							#   printf("%c", '\n');

	sw	$t8, BLOCK_SPAWNER_SAFE_COLUMN_OFFSET($s0)	# block_spawner->safe_column = safe_column;

	la	$t1, BLOCK_SPAWNER_NEXT_BLOCK_OFFSET($s0)	#
	mul	$t8, $t8, 4					#
	add	$t8, $t8, $t1					# block_spawner->next_block[safe_column]
	la	$t7, CHUNKS					#
	li	$t2, SAFE_CHUNK_INDEX				# 
	mul	$t2, $t2, 4					#
	add	$t7, $t7, $t2					#
	lw	$t9, ($t7)					# $t9 = CHUNKS[SAFE_CHUNK_INDEX]
	sw	$t9, ($t8)					# block_spawner->next_block[safe_column] = 
								# CHUNKS[SAFE_CHUNK_INDEX];
								#}

maybe_pick_new_chunk__epilogue:
	pop	$s6
	pop	$s5
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <do_tick>
	.text
do_tick:
	# Subset:   3
	#
	# Args:
	#   - $a0: char map[MAP_HEIGHT][MAP_WIDTH]
	#   - $a1: struct Player *player
	#   - $a2: struct BlockSpawner *block_spawner
	#
	# Returns:  None
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4]
	# Uses:     [...]
	# Clobbers: [$a0]
	#
	# Locals:
	#   - '$a0' in $s0
	#   - '$a1' in $s1
	#   - '$a2' in $s2
	#   - 'sprites' in $t1
	#   - 'scores' in $t2
	#
	# Structure:
	#   do_tick
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

do_tick__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
do_tick__body:
	lw	$s4, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)	# player -. action_ticks_left
	blez	$s4, do_tick_change_state			# if (player->action_ticks_left <= 0) {
	addi	$s4, $s4, -1					#	-player->action_ticks_left;
								# }
	sw	$s4, PLAYER_ACTION_TICKS_LEFT_OFFSET($s1)
	j	do_tick_pick_new_chunk
do_tick_change_state:						# } else {
	li	$t1, PLAYER_RUNNING				#	player->state = PLAYER_RUNNING;
	sw	$t1, PLAYER_STATE_OFFSET($s1)			#}
do_tick_pick_new_chunk:
	lw	$t2, PLAYER_SCORE_OFFSET($s1)
	addi	$t2, $t2, SCROLL_SCORE_BONUS
	sw	$t2, PLAYER_SCORE_OFFSET($s1)			# player->score += SCROLL_SCORE_BONUS;

	move	$a0, $s2
	jal	maybe_pick_new_chunk				# maybe_pick_new_chunk(block_spawner);
do_tick_i_loop_init:
	li	$t3, 0						# int i = 0;
do_tick_i_loop_cond:
	li	$t4, MAP_HEIGHT					
	addi	$t4, $t4, -1
	bge	$t3, $t4, do_tick_i_loop_end			# i < MAP_HEIGHT - 1;
do_tick_i_loop_body:
do_tick_j_loop_init:
	li	$t5, 0						# int j = 0;
do_tick_j_loop_cond:
	bge	$t5, MAP_WIDTH, do_tick_j_loop_end		# j < MAP_WIDTH;
do_tick_j_loop_body:
	move	$t6, $t3
	addi	$t6, $t6, 1					# [i + 1];
	mul	$t6, $t6, MAP_WIDTH
	add	$t7, $t6, $t5					# [i + 1][j];
	add	$t7, $t7, $s0					# map[i + 1][j];
	lb	$t8, ($t7)					# load map[i + 1][j];

	move	$t6, $t3
	mul	$t6, $t6, MAP_WIDTH
	add	$t7, $t6, $t5					# [i][j];
	add	$t7, $t7, $s0					# map[i][j];
	sb	$t8, ($t7)					# map[i][j] = map[i + 1][j];
	j	do_tick_j_loop_iter
do_tick_j_loop_iter:
	addi	$t5, $t5, 1					# ++j
	j	do_tick_j_loop_cond
do_tick_j_loop_end:
do_tick_i_loop_iter:
	addi	$t3, $t3, 1					# ++i
	j	do_tick_i_loop_cond
do_tick_i_loop_end:
do_tick_column_loop_init:
	li	$t3, 0						# int column = 0;
do_tick_column_loop_cond:
	bge	$t3, MAP_WIDTH, do_tick_column_loop_end		# column < MAP_WIDTH;
do_tick_column_loop_body:
	la	$t4, BLOCK_SPAWNER_NEXT_BLOCK_OFFSET($s2)	# block_spawner->next_block;
	mul	$t6, $t3, 4					# 
	add	$t6, $t6, $t4					# block_spawner->next_block[column];
	lw	$t5, ($t6)					# *next_block = &block_spawner->next_block[column];
	lb	$t7, ($t5)					# **next_block

	li	$t8, MAP_HEIGHT
	addi	$t8, $t8, -1					# 
	mul	$t8, $t8, MAP_WIDTH				#
	add	$t8, $t8, $t3					# [MAP_HEIGHT - 1][column]
	add	$t8, $t8, $s0					# map[MAP_HEIGHT - 1][column]
	sb	$t7, ($t8)					# map[MAP_HEIGHT - 1][column] = **next_block;

	add	$t5, $t5, 1					# ++*next_block;
	sw	$t5, ($t6)
do_tick_column_loop_iter:
	addi	$t3, $t3, 1					# ++column;
	j	do_tick_column_loop_cond
do_tick_column_loop_end:

do_tick__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <get_seed>
get_seed:
	# Args:     None
	#
	# Returns:  None
	#
	# Frame:    []
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#   - $v0: seed
	#
	# Structure:
	#   get_seed
	#   -> [prologue]
	#     -> body
	#       -> invalid_seed
	#       -> seed_ok
	#   -> [epilogue]

get_seed__prologue:
get_seed__body:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, get_seed__prompt_msg
	syscall					# printf("Enter a non-zero number for the seed: ")

	li	$v0, 5				# syscall 5: read_int
	syscall					# scanf("%d", &seed);
	sw	$v0, g_rng_state		# g_rng_state = seed;

	bnez	$v0, get_seed__seed_ok		# if (seed == 0) {
get_seed__invalid_seed:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, get_seed__prompt_invalid_msg
	syscall					#   printf("Invalid seed!\n");

	li	$v0, 10				#   syscall 10: exit
	li	$a0, 1
	syscall					#   exit(1);

get_seed__seed_ok:				# }
	li	$v0, 4				# sycall 4: print_string
	la	$a0, get_seed__set_msg
	syscall					# printf("Seed set to ");

	li	$v0, 1				# syscall 1: print_int
	lw	$a0, g_rng_state
	syscall					# printf("%d", g_rng_state);

	li	$v0, 11				# syscall 11: print_char
	la	$a0, '\n'
	syscall					# putchar('\n');

get_seed__epilogue:
	jr	$ra				# return;


################################################################################
# .TEXT <rng>
rng:
	# Args:     None
	#
	# Returns:  $v0: unsigned
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2]
	#
	# Locals:
	#   - $t0 = copy of g_rng_state
	#   - $t1 = bit
	#   - $t2 = temporary register for bit operations
	#
	# Structure:
	#   rng
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

rng__prologue:
rng__body:
	lw	$t0, g_rng_state

	srl	$t1, $t0, 31		# g_rng_state >> 31
	srl	$t2, $t0, 30		# g_rng_state >> 30
	xor	$t1, $t2		# bit = (g_rng_state >> 31) ^ (g_rng_state >> 30)

	srl	$t2, $t0, 28		# g_rng_state >> 28
	xor	$t1, $t2		# bit ^= (g_rng_state >> 28)

	srl	$t2, $t0, 0		# g_rng_state >> 0
	xor	$t1, $t2		# bit ^= (g_rng_state >> 0)

	sll	$t1, 31			# bit << 31
	srl	$t0, 1			# g_rng_state >> 1
	or	$t0, $t1		# g_rng_state = (g_rng_state >> 1) | (bit << 31)

	sw	$t0, g_rng_state	# store g_rng_state

	move	$v0, $t0		# return g_rng_state

rng__epilogue:
	jr	$ra


################################################################################
# .TEXT <read_char>
read_char:
	# Args:     None
	#
	# Returns:  $v0: unsigned
	#
	# Frame:    []
	# Uses:     [$v0]
	# Clobbers: [$v0]
	#
	# Locals:   None
	#
	# Structure:
	#   read_char
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

read_char__prologue:
read_char__body:
	li	$v0, 12			# syscall 12: read_char
	syscall				# return getchar();

read_char__epilogue:
	jr	$ra
