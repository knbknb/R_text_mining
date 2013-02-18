Step 10 - Data Preparation
=============


Steps to get a data file with conference abstracts (Comma separaed value file, .csv):

 - (Optional) Go to http://fallmeeting.agu.org/2012/
 - (Optional) Click "Scientific Program" in Pull Down Menu. Pulldown will "fly down"-
 - (Optional) In expanded PullDown, beneath thumbnail pic, click "Scientific Program" (again)
 - (Optional) On [Scientific Program Page][1], click "2012 Fall Meeting Scientific Program"
 - This should lead you to the [itinerary planner page][2] from conference service-provider abstractcentral.com 
 - You may have to permit pop-up windows in your browser, accept cookies and accept a terms-of-service form.

From here on, direct URLs can not longer provided, as abstractcentral.com relies on javascript to generate pages.
 
 - Click on "Browse he program" (see left margin of page)

Now you are on an itinerary page. There are 5 rows, one for each week day. The rows are empty for now, because your itinerary is empty. 

To fill the itinerary:

 - Click on Select-Box "Select topic" (see right margin of page). A  menu will fly out.
 - In the menu, choose one or more "session topics": These are subcategories of Earth Science according to the conference organizers.
 - The page will be dynamically updated. The lower half of the page will be filled with conference sessions. each session comprises several talks, which are not visible by default. Click on a checkbox next to a single session/name subtopic that you are interested in. This will select *all* talks of that session.
 - Just after this first click on this checkbox, a pop-up box will open. 
 - To create a new itinerary: fill in the two text fields: 
  - In field, 1, invent a short title for your itinerary
  - In field 2, provide your email address. 
 - Click on "Create itinerary". The pop-up box will disappear. 
 - (Optional) Take a note of the name of your itinerary for future reference. Write it down somewhere.

Now export the data:

  - Click on "View Your Itinerary" (see left margin of page)
  - Click "Export Itinerary + Abstracts Excel" (see center right of page)
  - A pop-up box will open. Your CSV file will be generated. It will take less than ten minutes. The estimate given on the pop-up box will be much higher. The page will refresh itself periodically. When it is done, another pop-up box will open, with a "download file" notification. The default filename will be itinerary.csv
  - Download the data file. Rename it after you downloaded it. Copy or move it to your working directory of your R Session.
  - A sample data file is provided with this github repo. It is called ""itinerary--nonlin-geophys--sample-data-file.csv" and has 470 kB.

 [1]:  http://fallmeeting.agu.org/2012/scientific-program/
 [2]:  http://agu-fm12.abstractcentral.com/planner.jsp
