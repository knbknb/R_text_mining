R_text_mining
=============

#### tl;dr: For a visualization see https://rapps.shinyapps.io/wordcloud01/

Please wait 1-2 minutes for the app to startup, and load the corpora. 

This repo contains the preprocessing-scripts for the above-mentioned Shiny-App (whose code is hosted in an [extra repository](https://github.com/knbknb/wordcloud-01) here on Github) 

#### R project from 2013, abandoned

 (Part 1) Perform *text-mining* on  abstracts of science contributions, 
presented at the [AGU Fall Meeting 2012][0], San Francisco. 
This was a big annual conference for Earth scientists, in particular geophysicists and geologists.

Use R to draw interesting conclusions from a subset of the 23000 abstracts submitted. (These are *not* included with this repository.)

 (Part 2) Perform *text-mining* on  abstracts of science contributions, 
to be presented at the [EGU General Assembly 2013][1], Vienna (see below). 
This is also a big annual conference for Earth scientists, in particular geophysicists and geologists.

Both [AGU][4]  and [EGU][2]  conferences have the same target audience, and they even share a similar classification system of scientific subfields. That means the conference tracks/sessions have the same titles. 
So the two datasets could be merged.

Use R to draw interesting conclusions from a subset of the 11000 abstracts submitted. (These are also *not* included with this repository.)



[Results from this project were presented][3] at EGU General Assembly 2013, a conference in Vienna to happen in April 2013. 
There will be a poster about text-mining in R, on beginner level.

For more information about the code, read the [CONFIGURATION_AND_USAGE.md](CONFIGURATION_AND_USAGE.md) file.
To learn even more, please read the documentation in the ["doc"](doc) directory of this repo for an explanation of  *what* the scripts are doing.


[0]: http://agu-fm12.abstractcentral.com/planner.jsp
[1]: http://www.egu2013.eu/
[2]: http://www.egu.eu/
[3]: http://meetingorganizer.copernicus.org/EGU2013/EGU2013-6217.pdf
[4]: http://www.agu.org/
