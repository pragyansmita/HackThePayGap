Part of figuring out how to be a working mother involves making the right decisions as to how to care for her child while she is at work. Her options vary depending on location, industry, income level and family structure. 

[1] "In the United States, 80.6% of single parents are mothers. Among this percentage of single mothers: 45% of single mothers are currently divorced or separated, 1.7% are widowed, 34% of single mothers never have been married." (Reference: https://en.wikipedia.org/wiki/Single_parent) 

[2] "Around 49% of single mothers have never married, 51% are either divorced, separated or widowed. Half have one child, 30% have two. About two thirds are White, one third Black, one quarter Hispanic."(Reference: https://singlemotherguide.com/single-mother-statistics/). 

This HackThePayGap application for workers titled "BumpAhead" is an attempt at better understanding the dynamics involved and help initiate further steps required to address it.


Installation Instructions

1) Download and install R (as of 7/4/2016, the latest R version is 3.3.1 and this was used to test this app)
	- Windows: https://cran.r-project.org/bin/windows/base/
	- Mac - https://cran.r-project.org/bin/macosx/
	
2) Download and install R Studio
	- https://www.rstudio.com/products/rstudio/download/

3) Clone (or download) the R\Shiny code for the BumpAhead application from the GitHub repository.
	- https://github.com/pragyansmita/HackThePayGap
	
4) Unzip the code and open either paygap_Shiny\server.r or paygap_Shiny\ui.r in R Studio for the BumpAhead application. 
	- Explore the other applications available in the different folders.
		- MIDAAS_RScripts is a R script to perform REST API call to MIDAAS APIs. Replace the input values in the MIDAAS_API_Requester.r script and execute it from R console.
		- paygap_Shiny_MIDAAS is a reduced R\Shiny application compared to the BumpAhead application. It provides only a R\Shiny interface to work with MIDAAS APIs for reuse in other applications in future.
		- socialAnalytics is an experimental R\Shiny application to search for tweets matching a particular keyword. It performs sentiment analysis to categorize the tweets as Positive, Negative or Neutral in it's tone. Wordcloud is presented for each category to highlight the most frequently occuring words in each category.
		- wordcloud_twitteR is a R script to generate a high resolution wordcloud for recent N tweets matching a particular keyword.

5) Click on "Run App". It will open a new popup window with the app. 
	- Click on "Open in browser" option in the new popup window if you want to work in the app in browser.
	- Working in the popup window from R Studio is same as working in browser. Only exception is that the video links are *not* enabled in the popup window.
	
6) To close the app, close the popup window.	