#include <pthread.h>
#include "thread_chain.h"

void *my_thread(void *data) {
    int thread_num = *((int *)data);
    thread_hello();  // Call the function to say "Hello from thread N!"

    if (thread_num < 50) {  // Check if there are more threads to spawn
        pthread_t next_thread;
        int next_thread_num = thread_num + 1;
        pthread_create(&next_thread, NULL, my_thread, &next_thread_num);
        pthread_join(next_thread, NULL);  // Wait for the next thread to finish
    }

    return NULL;
}

void my_main(void) {
    pthread_t thread_handle;
    int initial_thread_num = 1;  // Start from thread 1
    pthread_create(&thread_handle, NULL, my_thread, &initial_thread_num);
    pthread_join(thread_handle, NULL);
}
