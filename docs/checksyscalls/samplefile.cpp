#include <iostream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
        int pid = fork();
        if (pid == -1)
        {
                perror("fork() error!");
                exit(1);
        }
        else if(pid == 0)
        {
                if(-1 == execvp(argv[0], argv))
                {
                        perror("execvp error!");
                        exit(1);
                }
        }
        else if(pid > 0)
        {
                if(-1 == wait(0))
                {
                        perror("wait() error!");
                }
        }

        return 0;
}

