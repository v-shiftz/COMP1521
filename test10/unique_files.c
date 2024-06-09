#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct inode_node {
    ino_t inode;
    struct inode_node *next;
} inode_node;

int inode_in_list(inode_node *head, ino_t inode) {
    inode_node *current = head;
    while (current != NULL) {
        if (current->inode == inode) {
            return 1;
        }
        current = current->next;
    }
    return 0;
}

void add_inode(inode_node **head, ino_t inode) {
    inode_node *new_node = malloc(sizeof(inode_node));
    if (new_node == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    new_node->inode = inode;
    new_node->next = *head;
    *head = new_node;
}


int main(int argc, char **argv)
{
    if (argc < 2) {
        printf("Usage: %s <file1> [file2] ...\n", argv[0]);
        return 1;
    }
    struct stat stats;
    inode_node *head = NULL;
    int i;

    for (i = 1; i < argc; i++) {
        if (stat(argv[i], &stats) != 0) {
            continue;
        }

        if (!inode_in_list(head, stats.st_ino)) {
            add_inode(&head, stats.st_ino);
            printf("%s\n", argv[i]);
        }
    }

    // Freeing the linked list
    inode_node *current = head;
    inode_node *tmp;
    while (current != NULL) {
        tmp = current;
        current = current->next;
        free(tmp);
    }
    return 0;
}
