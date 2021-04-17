# R_NAICS-Code-Analyzer

Given a startup's description of the business as a text file, the industry code analyzer will search the NAICS industry code database to identify the startup's industry classification. The tool will help the entrepreneur identify the industry for the startup more efficiently and perform a market analysis more easily. The project will expand on existing preliminary work done in Python. The project will carry on additional experiments and test to increase the accuracy of analytical results. The shiny app regarding industry code analyzer will serve as an efficient search tool to find the right industry code and benefit both professional and academic uses.

## Getting Started
These instructions will get you a copy a the project up and running on your local machine for development and testing purpose. 

## Prerequisites
* R Studio 
* Microsoft Office Excel 
* Text file for business description

## Installing 
* Integrated Development Environment for R (e.g. RStudio, R Tools for Visual Studio, Rattle, PyCharm, Eclipse)

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

Note: The instance size for this project is over 1GB, and users need to upgrade shiny app version to at least "Basic Plan" which release the instance size of 5GB to run the app without any re-load problem 

## Testing
Open "Naics.r" for test the original result 

# Built with 
