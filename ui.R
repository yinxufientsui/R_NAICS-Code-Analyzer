library(shiny)

navbarPage(
  "Naics Code Analyzer",
  tabPanel(
    "Upload a text file with the business description",
    fluidPage(
      wellPanel(p("Please upload a text file of the business description."),
                p("When finished, please download or copy your result.")),
      fluidRow(
        # Upload business description
        column(fileInput("uploaded_business_description",
                       label = h5("Upload your data")),
                       width =  6),
      ),
      
      # Download section 
      fluidRow(
        column(
          downloadButton("download_code_bs_similarity_6digit",
                         "Download result of similarity score of 6 digit"),
          width =  6),
        column(
          downloadButton("download_code_bs_similarity_4digit",
                         "Download result of similarity score of 4 digit"),
          width = 12)
      ),
      
      sidebarLayout(
        sidebarPanel(p("View Your Result"),
          conditionalPanel(
            'input.dataset ==="code_bs_similarity6"'
          ),
          conditionalPanel(
            'input.dataset ==="code_bs_similarity4"'
          )
        ),
        mainPanel(
          tabsetPanel(
            id = 'dataset',
            tabPanel("Industry_code_for_6_digit",DT::dataTableOutput("mytable1")),
            tabPanel("Industry_code_for_4_digit",DT::dataTableOutput("mytable2"))
          )
        )
      )
    )
  ),
  collapsible = TRUE
)
