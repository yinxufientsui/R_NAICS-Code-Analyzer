# R_NAICS-Code-Analyzer
## About the project
Given a startup's description of the business as a text file, the industry code analyzer will search the NAICS industry code database to identify the startup's industry classification. The tool will help the entrepreneur identify the industry for the startup more efficiently and perform a market analysis more easily. The project will expand on existing preliminary work done in Python. The project will carry on additional experiments and test to increase the accuracy of analytical results. The shiny app regarding industry code analyzer will serve as an efficient search tool to find the right industry code and benefit both professional and academic uses.


### About shiny 
"Shiny is an open source R package that provides an elegant and powerful web framework for building web applications using R. Shiny helps you turn your analyses into interactive web applications without requiring HTML, CSS, or JavaScript knowledge".(Resource: https://www.rstudio.com/products/shiny/)



## Getting Started
These instructions will get you a copy a the project up and running on your local machine for development and testing purpose. 

### Prerequisites
* R Studio 
* Microsoft Office Excel 
* Text file for business description
* Valid Account on ShinyApp

### Installation
* Integrated Development Environment for R (e.g. RStudio, R Tools for Visual Studio, Rattle, PyCharm, Eclipse)
https://www.rstudio.com/products/rstudio/

### Testing
* Open "Naics.r" for test the original result 
* Install necessary package before running 
install.packages("dplyr")
install.packages("readr")
install.packages("tm")
install.packages('SnowballC')
install.packages("shiny")
* Run the codes and view the result in environment

### Running the project locally
* Download the neccessary industry code data under same directory as your r file 
* Create a copy of the business description as text file and save in local 
* Open the server.r and ui.r in local IDE and click the buttom "Run App" 
* Upload the text file
* The shiny app will display the result and allow users to download the analysis to local directory


### Run the project on web powered by ShinyApp.io
* Open the shinyapp using link https://ranalyzer.shinyapps.io/Industrycode/
* Create a copy of the business description as text file and save in local 
* Upload the text file
* The shiny app will display the result and allow users to download the analysis to local directory

Note: The instance size for this project is over 1GB, and users need to upgrade shiny app version to at least "Basic Plan" which release the instance size of 5GB to run the app without any re-load problem. In order to upgrade, please log in/sign up to Shinyapp.io with valid account and password.

## Usage 
![Screen Shot 2021-04-17 at 2 59 39 PM](https://user-images.githubusercontent.com/82678386/115124038-13207a00-9f8e-11eb-8d7f-d5d4fd221385.png)

## Contact 
Fien - yinxufien@gmail.com

