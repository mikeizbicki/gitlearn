# system call error checking

It is recommended that you perform error checking on every system call ("syscall" for short) you use.
With proper error checking, if a syscall returns an error value, there will be a message stating why it did.

To do this, you would call the `perror` function inside the conditional statement as shown in the example below:
```
#include <stdio.h> // perror
// ...

	if (-1==execvp(argv[0],argv)) {
		perror("20: execvp");
		exit(1);
	}
```
It is also good practice to pass in the name and line number of the syscall as `perror`'s argument.
It will help you identify which syscall failed.

## the `checksyscalls.sh` script

For lengthy source files with many syscalls, the `checksyscalls.sh` script lets you keep track of all of them quickly.
This script takes in `.c`/`.cpp` files as its arguments.
If you pass in a directory, then it will call itself recursively for each file inside that directory.

To use the script, you would run:
```
$ checksyscalls.sh src/*
```
![checksyscalls.gif](../img/syscall/checksyscalls.gif)

As shown in the gif above, the `checksyscalls.sh` script lists all syscalls in your source file(s) with the associated line number and `perror` function.
You will know you've done error checking when the next line after the syscall is the `perror` function.
The summary below the list displays the total of syscalls and `perror` functions you used, and the grade penalty you receive for every syscall you did not do error checking on.
If your instructor enforces it, then the grade penalty should be an incentive to practice error checking!
