library(shiny)

# Define UI for slider demo application
shinyUI(fluidPage(
  
  #  Application title
  titlePanel("Wins Above Replacement (WAR) Calculator"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarLayout(
    sidebarPanel(
   h4("Batting, Fielding & Baserunning WAR"),
   
   selectInput("Pos", label = "Position:", 
               choices = list("C","1B","2B","3B","SS", "LF","CF","RF","DH","P"), 
               selected = "C"),  
    # Decimal interval 
    sliderInput("OBP", "OBP:", 
                  min = 0, max = .5, value = 0.32, step=.001),

      # Decimal interval 
      sliderInput("SLG", "SLG:", 
                  min = 0, max = .8, value = 0.4, step=.001),
      
      # Simple integer interval
      sliderInput("PA", "Plate Appearances:", 
                  min=0, max=750, value=0, step=1),
      
      
      # Simple integer interval
      sliderInput("UZR", "Defense (relative to position):", 
                  min=20, max=80, value=50, step=5),
      # Simple integer interval
      sliderInput("BSR", "Baserunning:", 
                  min=20, max=80, value=50, step=5),
    
    tags$hr(),
    h4("Pitching WAR"),
    # Copy the line below to make a radioButton
 
   radioButtons("LG", label = "League:", 
                choices = list("NL","AL"), 
                selected = "NL"), #inline=TRUE is supposed to make horizontal
    # Copy the line below to make a select box 
    selectInput("Role", label = "Role:", 
                choices = list("Starter","Closer","Setup","Mopup","Relief"), 
                selected = "Starter"),
    # Simple integer interval
    sliderInput("IP", "Innings Pitched:", 
                min=0, max=400, value=0,step=1), 
    # Simple integer interval
    sliderInput("ERA", "ERA:", 
                min=0, max=6, value=0, step=.01)
    
    ),
    
    # Show a text for the computed answer
    mainPanel(

      h4("Total WAR:"),
      h1(textOutput("answer")),
      p(strong("Over a full season, an average player gets about 2 WAR, a good player 4, and a great player 6 or more.")),

      tags$hr(),
      h4("WAR Explained"),
      p("", em("Wins Above Replacement (WAR)"), " is an attempt by the sabermetric baseball community to summarize a player’s total contributions to their team in one statistic. You should always use more than one metric at a time when evaluating players, but WAR is all-inclusive and provides a useful reference point for comparing players. WAR offers an estimate to answer the question, “If this player got injured and their team had to replace them with a freely available minor leaguer or a AAAA player from their bench, how much value would the team be losing?” This value is expressed in a wins format, so we could say that Player X is worth +6.3 wins to their team while Player Y is only worth +3.5 wins, which means it is highly likely that Player X has been more valuable than Player Y."),
      p("WAR is not meant to be a perfectly precise indicator of a player’s contribution, but rather an estimate of their value to date. Given the imperfections of some of the available data and the assumptions made to calculate other components, WAR works best as an approximation. A 6 WAR player might be worth between 5.0 and 7.0 WAR, but it is pretty safe to say they are at least an All-Star level player and potentially an MVP."),
  
      #p("More info about WAR on ", tags$a(href= "www.fangraphs.com/library/misc/war/", "Fangraphs")),

      
        tabsetPanel(type="tabs",
                    tabPanel("Position Players",
                             h5("Position Players"),
                             em("WAR = (Batting Runs + Base Running Runs + Fielding Runs + Positional Adjustment + League Adjustment + Replacement Runs) / (Runs Per Win)")
                             
                             ),
                    tabPanel("Pitchers",
                             h5("Construction for Pitchers"),
                             em("WAR = [[([(League “FIP” – “FIP”) / Pitcher Specific Runs Per Win] + Replacement Level) * (IP/9)] * Leverage Multiplier for Relievers] + League Correction"),
                             h5("Fielding Independent Pitching with Infield Flies (ifFIP)"),
                             em("ifFIP = ((13*HR)+(3*(BB+HBP))-(2*(K+IFFB)))/IP + ifFIP constant"),br(),
                             em("ifFIP Constant = lgERA – (((13*lgHR)+(3*(lgBB+lgHBP))-(2*(lgK+lgIFFB)))/lgIP)"),
                             h5("Scaling ifFIP to RA9"),
                             em("Adjustment = lgRA9 – lgERA"),br(),
                             em("FIPR9 = ifFIP + Adjustment"),
                             h5("Park Adjustment"),
                             em("pFIPR9 = FIPR9 / (PF/100)"),
                             h5("Compare to AL/NL Average"),
                             em("Runs Above Average Per 9 (RAAP9) = AL or NL FIPR9 – pFIPR9"),
                             h5("Dynamic Runs Per Win"),
                             em("Dynamic RPW (dRPW) = ([([(18 – IP/G)*(AL or NL FIPR9)] + [(IP/G)*pFIPR9]) / 18] + 2)*1.5"),
                             h5("Converting to Games Per Win"),
                             em("Wins Per Game Above Average (WPGAA) = RAAP9 / dRPW"),
                             h5("Replacement Level"),
                             em("Replacement Level = 0.03*(1 – GS/G) + 0.12*(GS/G)"),
                             h5("Scaling to Innings Pitched"),
                             em("WPGAR = WPGAA + Replacement Level"),br(),
                             em("“WAR” = WPGAR * (IP/9)"),
                             h5("Leverage"),
                             em("LI Multiplier = (1 + gmLI) / 2"),
                             h5("Final Adjustments"),
                             em("Correction = WARIP * IP"),br(),
                             em("WAR = “WAR” + Correction")
                             ),
                    br(),
                    p("More info about WAR on ", tags$a(href= "www.fangraphs.com/library/misc/war/", "Fangraphs"))
        )
      
      
    )
  )

))