EXERCISES	+= 22t3final_q9
CLEAN_FILES	+= 22t3final_q9

22t3final_q9:	22t3final_q9.c 22t3final_q9_main.c
	$(CC) $(CFLAGS) -pthread 22t3final_q9.c 22t3final_q9_main.c -o $@
