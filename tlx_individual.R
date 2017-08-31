# R function: NASA TLX analysis for individual participant who completed individual task
#
#   NASA Task Load Index (TLX); url = https://humansystems.arc.nasa.gov/groups/tlx/
#   Visualization outcome according to graph presented on page 7 of NASA TLX Instruction Manual; url = https://humansystems.arc.nasa.gov/groups/tlx/downloads/TLX_pappen_manual.pdf
#
#   R version: 3.4.0
#   RStudio version: Version 1.0.153 (OS X)
#   gridExtra version: 2.2.1
#   ggplot2 version: 2.2.1
#
#   Author: Nico Reski
#   Web: http://reski.nicoversity.com
#   Twitter: @nicoversity

tlx.individual = function (collectedData, participantID) {

  library("ggplot2")        # plot / visualization library; url = https://cran.r-project.org/web/packages/ggplot2/
  library("gridExtra")      # arrange multiple plots side-by-side; url = https://cran.r-project.org/web/packages/gridExtra/


  ## TLX data validation

  # 1. Sum of all weights should be exactly 15
  if(sum(collectedData$weight) != 15){
    warning(paste("TLX DATA VALIDATION WARNING. Sum of all weights should be 15, but is", sum(collectedData$weight), sep = " "))
  }

  # 2. Check raw rating values...
  for(rawRat in collectedData$rawRating){
    # 2.1 as they should be a value between 0 and 100 (incl.)
    if(rawRat < 0 || rawRat > 100){
      warning(paste("TLX DATA VALIDATION WARNING. Raw rating value should be between 0 and 100, but is", rawRat, sep = " "))
    }
    #  2.2 as it modulo 5 should be equal to 0
    else if(rawRat%%5 != 0) {
      warning(paste("TLX DATA VALIDATION WARNING. Raw rating value modulo 5 should be 0, but it is not. Check value ", rawRat, sep = " "))
    }
  }


  ## TLX data handling

  # indexes:
  # 1 -> mental demand (MD)
  # 2 -> physical demand (PD)
  # 3 -> temporal demand (TD)
  # 4 -> own performance (OP)
  # 5 -> effort (EF)
  # 6 -> frustration (FR)

  tlxFactor = c("Mental Demand",
                "Physical Demand",
                "Temporal Demand",
                "Own Performance",
                "Effort",
                "Frustration")

  tlxFactorShort = c("MD",
                     "PD",
                     "TD",
                     "OP",
                     "EF",
                     "FR")

  # tlx factors are already ordered
  tlxFactor = factor(tlxFactor, levels = tlxFactor)
  tlxFactorShort = factor(tlxFactorShort, levels = tlxFactorShort)

  # calculate adjusted ratings
  adjustedRating = c(collectedData$weight[1]*collectedData$rawRating[1],
                     collectedData$weight[2]*collectedData$rawRating[2],
                     collectedData$weight[3]*collectedData$rawRating[3],
                     collectedData$weight[4]*collectedData$rawRating[4],
                     collectedData$weight[5]*collectedData$rawRating[5],
                     collectedData$weight[6]*collectedData$rawRating[6])

  # calculate weighted rating (= workload; in percentage)
  weightedRating = sum(adjustedRating)/15.0

  # summarize all numerical TLX data into one data frame
  factorSummary = data.frame(
    tlxFactor,
    tlxFactorShort,
    weight = collectedData$weight,
    rawRating = collectedData$rawRating,
    adjustedRating
  )


  ## TLX plotting

  ## factor plot (displaying all individual TLX factors)

  # color palette for TLX factors
  # via http://colorbrewer2.org/#type=qualitative&scheme=Pastel1&n=6
  factorCP <- c("#fbb4ae", "#b3cde3", "#ccebc5", "#decbe4", "#fed9a6", "#ffffcc")

  # helper variable: calculate bar chart position along x axis according to width
  # via https://stackoverflow.com/a/20690333
  # last + half(previous_width) + half(current_width)
  weightPos = 0.5 * (cumsum(factorSummary$weight) + cumsum(c(0, factorSummary$weight[-length(factorSummary$weight)])))

  fPlot = ggplot(data = factorSummary, aes(x = weightPos,
                                           y = rawRating,
                                           fill = factor(tlxFactor))) +
    geom_bar(width = factorSummary$weight, stat = "identity") +
    scale_x_continuous(labels = tlxFactorShort, breaks = weightPos, expand = c(0,0)) +
    scale_y_continuous(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80, 100), expand = c(0,0)) +
    scale_fill_manual("TLX Factors", values = factorCP) +
    labs(x="IMPORTANCE WEIGHT", y="RATING") +
    ggtitle(paste("OVERALL WORKLOAD (OW) = MEAN OF WEIGHTED RATINGS \n Participant ID:", participantID, sep = " ")) +
    theme(axis.line = element_line(size = 0.4, color = "black"),
          axis.ticks.y = element_line(size = 0.4, color = "black"),
          axis.ticks.x = element_blank(),
          panel.background = element_rect(fill = "white"),
          plot.title = element_text(hjust = 0.5, size = 11)) +
    # manual x-axis tick drawing (quick and dirty)
    geom_segment(aes(x=1.0, y=0.0, xend=1.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=2.0, y=0.0, xend=2.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=3.0, y=0.0, xend=3.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=4.0, y=0.0, xend=4.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=5.0, y=0.0, xend=5.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=6.0, y=0.0, xend=6.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=7.0, y=0.0, xend=7.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=8.0, y=0.0, xend=8.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=9.0, y=0.0, xend=9.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=10.0, y=0.0, xend=10.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=11.0, y=0.0, xend=11.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=12.0, y=0.0, xend=12.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=13.0, y=0.0, xend=13.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=14.0, y=0.0, xend=14.0, yend=1.0), size = 0.4) +
    geom_segment(aes(x=15.0, y=0.0, xend=15.0, yend=1.0), size = 0.4)


  ## workload plot (displaying only the weighted rating = overall workload)

  # helper data frame containing workload
  workloadSummary = data.frame(
    weightedRating = c(weightedRating)
  )

  # color palette for workload
  # via http://colorbrewer2.org/#type=qualitative&scheme=Pastel1&n=6
  workloadCP <- c("#cccccc")

  wPlot = ggplot(data = workloadSummary, aes(x = c(1),
                                             y = weightedRating,
                                             fill = factor(weightedRating),
                                             label = factor(c("OVERALL\nWORKLOAD")))) +
    geom_bar(width = 1.0, stat = "identity") +
    geom_text(size = 3.5, vjust = -0.6) +
    scale_x_continuous(limits = c(0,2), breaks = c(0, 1, 2)) +
    scale_y_continuous(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80, 100), expand = c(0,0)) +
    scale_fill_manual(values = workloadCP) +
    theme(axis.title = element_blank(),
          axis.line = element_line(size = 0.4, color = "black"),
          axis.ticks.y = element_line(size = 0.4, color = "black"),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          panel.background = element_rect(fill = "white"),
          legend.position = "none",
          plot.margin = margin(35, 50, 25, 10, "pt"))


  ## combined plot showing factors and overall workload side by side
  cPlot = grid.arrange(fPlot, wPlot, widths = c(2,1))


  ## return statement
  return(list(factorData=factorSummary,
              workload=weightedRating,
              factorPlot=fPlot,
              workloadPlot=wPlot,
              combinedPlot=cPlot))
}


## Documentation
# 1. valueName = tlx.individual(data, participant ID)     # runs function and writes it into value named "valueName" in current session; takes a "data" data frame with "weight" and "rawRating" number collections, as well as a variable "participant ID"
# 2. valueName$factorData                 # shows "factorData" ("factorSummary") data frame
# 3. valueName$factorData$weight          # shows "weight" row of "factorData" data frame
# 4. valueName$factorData$weight[4]       # shows 4th value in "weight" row of "factorData" data frame
# 5. valueName$workload                   # shows the calculated workload (in percentage)
# 6. valueName$factorPlot                 # shows TLX plot displaying the individual factors
# 7. valueName$workloadPlot               # shows TLX plot displaying the overall workload (weighted rating of all individual factors)
# 8. valueName$combinedPlot               # shows TLX plots (factorPlot + workloadPlot) side-by-side
