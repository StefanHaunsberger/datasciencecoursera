
setwd("~/r-workspace/coursera/data-science-jhu/09_DevelopingDataProducts/shiny-app")

require(googleVis)

## Please note that by default the googleVis plot command
## will open a browser window and requires Flash and Internet
## connection to display the visualisation.

# Read data from csv file
## Source: http://esa.un.org/unpd/wpp/DVD
## --> Database (CSV) format
pop = read.csv(file.path("extdata", "WPP2015_DB02_Populations_Annual.csv"), header = TRUE, stringsAsFactors = FALSE);
dei = read.csv(file.path("extdata", "WPP2015_INT_F1_Annual_Demographic_Indicators.csv"), header = TRUE, stringsAsFactors = FALSE);
# Build subset with following criterias
#   - countries (LocID >= 900 are Groupings, such as Europe)
#   - medium population projection
## dei has less entries so pop has to be cut dow, so they have the same number of records.
dei.sub = subset.data.frame(dei, VarID == 2 & LocID < 900,
                            c(LocID, Location, Time, TFR));
pop.sub = subset.data.frame(pop, VarID == 2 & LocID < 900 & LocID %in% unique(dei.sub$LocID),
                            c(LocID, Location, Time, PopTotal));

d = cbind.data.frame(LocID = dei.sub$LocID, Location = dei.sub$Location, Time = dei.sub$Time, TFR = dei.sub$TFR, PopTotal = pop.sub$PopTotal);
trans = c("\xe7" = "c", "\xf4" = "o", "\xe9" = "e");
for (i in 1:length(trans)) {
  d$Location = gsub(pattern = names(trans)[i], replacement = trans[i], x = d$Location)
}

# d.s = d[1:200, c("Location","TFR", "PopTotal")];
d.s = d[1:200,];

d.avg = aggregate(d[,c("TFR", "PopTotal")], d[,c("LocID", "Location")], FUN = mean, na.rm = TRUE)
tbl1 <- gvisTable(head(d.avg, n=200));
plot(tbl1)

G1 <- gvisGeoChart(d.avg, locationvar='Location', colorvar='PopTotal') 
G1 <- gvisGeoMap(d.avg, locationvar='Location', numvar ='PopTotal')
# G1 <- gvisMap(d.avg, locationvar='Location')

plot(G1)





