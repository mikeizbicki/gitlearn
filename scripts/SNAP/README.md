S.N.A.P.
---
**SNAP** is a tree of bash scripts that gather and present student social networking information. SNAP also gathers grade information so we can compare the two. **Social Networking Analysis Program**.

**What can it do?**
SNAP hightlights trends bewtween aspects of social networking and accededemic success. 

Even though SNAP is just a young program (does not have many parameters or data), SNAP can provide very interesting/powerful data. Maybe I'm a sucker for data, but there's some really fun possibilities!

These are some of my favourite examples. 

Github
---

Student grade vs.  # of repositories tied to their account


![](http://i.imgur.com/Uudb5iq.png)


Student grade vs. # of repositories tied to their account that are forks


![](http://i.imgur.com/uNcCegK.png)


Sudent grade vs. # of stars on every repository linked to their account


![](http://i.imgur.com/0evv6QA.png)


Github offers the option to add your name in your profile. The following is a comparison 

Student grade vs. their profile has their real name (1 means yes, 0 means no)


![](http://i.imgur.com/lmxokVZ.png)


Student grade vs. their username is some combination of letters then numbers (eg. dimitri001) (1 means yes, 0 means no)


![](http://i.imgur.com/nd2F3R4.png)


Student grade vs. size of website file 


![](http://i.imgur.com/rj09s7z.png)

Student grade vs. # of times their username was mentioned


![](http://i.imgur.com/MOZ3AkO.png)

Reddit
---
Student grade vs. comment karma


![](http://i.imgur.com/S1gv6T1.png)

Student grade vs. link karma


![](http://i.imgur.com/h3IbAm1.png)

Student grade vs. Student grade vs. their username is some combination of letters then numbers (eg. dimitri001) (1 means yes, 0 means no)


![](http://i.imgur.com/1aKnNTw.png)


You can look at more of the examples [here](http://imgur.com/a/KOzDP#0). 

How does it work? 
---
SNAP was designed to be very easy to add upon. The picture demonstrates the tree structure.

![](http://i.imgur.com/wmvG0Ua.jpg)

BUILD calls on each website's 'make', each make calls it's parameter 'make's. Websites can have a as many parameters as we want. 

Parameter 'make's take information from the website and return a numerical value. 

Each of these is appended to the total csv file, which is made on executing BUILD. From there, you can use the data however you'd like!

How do I use it?
--
SNAP **requires** 2 things to function properly. 

* [gitlearn](https://github.com/mikeizbicki/gitlearn) must be correctly installed and must be accessible as calcgrade.sh (This is how grades are fetched) As this project is now within gitlearn, down
* student information must be formatted correctly. Currently SNAP looks at student information posted in https://github.com/mikeizbicki/ucr-cs100/tree/2015winter/people/students .
If you want to change the location, the file is SNAP/start/res/namesmake.

Once these conditions are met, run ./BUILD while in the SNAP folder. After a good wait, you will have the data in a CSV file named "total.csv"

Future Plans
--
SNAP has some very cool possibilities but it's lacking in two big ways. Low student count means low confidence in the data. Also, very few parameters makes it hard to represent every aspect of a website.

Trying SNAP on more students solves our first issue, it's my hope that SNAP is easy enough to add to that other people might want to get involved. I think if you could accurately estimate a grade from the data, there could be huge potential gains in student performance. 

I've been offered to keep working on SNAP alongside the instructor for the class. I'm really really excited to see how SNAP grows. 

I would love for anyone to get involved, making parameters is as easy as printing out a value following a comma. Any questions or feedback you have, just pop me a message. It helps alot!
