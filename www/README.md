# `gitlearn` Website

Files in this folder are responsible for the structure of the website version of `gitlearn`.

To launch the website, open a terminal, and, once you are in the `gitlearn` repository, run the following commands:
```
$ cd rapache
$ export webroot=../website
$ ./http.sh
```
This will launch the `rapache` webserver.
You can then view the website by opening your internet browser, and navigating to `http://localhost:8080`.
This will take you to the homepage, where you can sign in to view your grades.

### Description of Files

##### `authuser.exp`

An `expect` script that checks if the username and password entered are valid credentials.
It takes username and password as arguments.

Usage:
```
./authuser.exp someuser somepassword
```
This script is called by `grades`.

##### `calcgrade.sh`

A `bash` script that calculates the grades of the user passed to it as an argument.
Grades are formatted in an html table.

Usage:
```
./calcgrade.sh user
```
This script is also called by `grades`.

##### `grades`

This bash script is the webpage that users will be directed to in order to view their grades.
It can be viewed directly by navigating to `http://localhost:8080/grades`.
You will then be prompted to log in.

`grades` calls `authuser.exp` to authenticate username and password, and then once authenticated, calls `calcgrade.sh` to get the user's grades formatted in a table.
It then sends this information as a formatted html page to the browser.

##### `index.html`

This is the homepage for the website.

##### `README.md`

This is the file you are currently reading

##### `stylesheet.css`

This contains css formatting for the website.
