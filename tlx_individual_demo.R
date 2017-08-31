# R script: NASA TLX analysis for individual participant who completed individual task

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

### 1. enter weight and raw rating values for session analysis

# indexes:
# 1 -> mental demand (MD)
# 2 -> physical demand (PD)
# 3 -> temporal demand (TD)
# 4 -> own performance (OP)
# 5 -> effort (EF)
# 6 -> frustration (FR)

# NOTE: hard coded example data
participantID = "42; virtual reality"
collectedData = data.frame(
  weight = c(3, 1, 3, 4, 3, 1),
  rawRating = c(45, 30, 5, 95, 25, 50)
)

### 2. run analysis and write results into "tlxAnalyzed" value
tlxAnalyzed = tlx.individual(collectedData, participantID)

### 3. show calculated workload
cat("Workload:  ", tlxAnalyzed$workload)

### 4. show data summary of all TLX factors (dimensions)
show(tlxAnalyzed$factorData)

### 5. show TLX plot (factors only)
#show(tlxAnalyzed$factorPlot)

### 6. show TLX plot (workload only)
#show(tlxAnalyzed$workloadPlot)

### 7. show TLX plot (factors and workload side-by-side)
show(tlxAnalyzed$combinedPlot)

### 8. save / export plot to pdf (plot = factors and workload side-by-side, landscape, A4)
pdfFileName = paste(participantID, ".pdf", sep = "")
pdf(pdfFileName, width=29.7/2.54, height=21.0/2.54)
plot(tlxAnalyzed$combinedPlot)
dev.off()
