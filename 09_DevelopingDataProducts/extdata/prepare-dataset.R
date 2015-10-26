
# setwd("~/r-workspace/coursera/data-science-jhu/09_DevelopingDataProducts/shiny-app")

require(googleVis)
require(dplyr)

## Please note that by default the googleVis plot command
## will open a browser window and requires Flash and Internet
## connection to display the visualisation.

# Read data from csv file
## Source: http://esa.un.org/unpd/wpp/DVD
## --> Database (CSV) format
pop = read.csv(file.path("..", "extdata", "WPP2015_DB02_Populations_Annual.csv"), header = TRUE, stringsAsFactors = FALSE);
dei = read.csv(file.path("..", "extdata", "WPP2015_INT_F1_Annual_Demographic_Indicators.csv"), header = TRUE, stringsAsFactors = FALSE);
# Build subset with following criterias
#   - countries (LocID >= 900 are Groupings, such as Europe)
#   - medium population projection
## dei has less entries so pop has to be cut dow, so they have the same number of records.
### Next two commands are equal
# dei.sub = subset.data.frame(dei, VarID == 2 & LocID < 900,
#                             c(LocID, Country, Time, TFR));
dei.sub = dei %>%
          filter(VarID == 2, LocID < 900, Year <= 2030) %>%
          select(Country, Year, Deaths:DeathsFemale, LEx:LExFemale, Births, TFR, PopChange);
# pop.sub = subset.data.frame(pop, VarID == 2 & LocID < 900 & Country %in% unique(dei.sub$Country),
#                             c(Country, Time, PopMale:PopDensity));
pop.sub = pop %>%
          filter(VarID == 2, LocID < 900, Year <= 2030, Country %in% unique(dei.sub$Country)) %>%
          select(Country, Year, PopMale:PopDensity);
# Merge both data frames
df = merge(pop.sub, dei.sub);


# df.2 = df[!(df$Country %in% c("China, Hong Kong SAR", "China, Macao SAR")),]
df = filter(df, !(Country %in% c("China, Hong Kong SAR", "China, Macao SAR")))

# trans = c("\xe7" = "c", "\xf4" = "o", "\xe9" = "e");
trans = c("\xe7" = "ç", "\xf4" = "ô", "\xe9" = "é",
          "Viet Nam" = "Vietnam",
          "United States of America" = "United States",
          "Republic of Moldova" = "Moldova",
          # "Bolivia (Plurinational State of)" = "Bolivia ,Plurinational State of",
          "Cabo Verde" = "Cape Verde",
          "United Republic of Tanzania" = "Tanzania (United Republic of)",
          "Dem. People's Republic of Korea" = "North Korea",
          "Democratic Republic of the Congo" = "Congo (The Democratic Republic)",
          "United States Virgin Islands" = "Virgin Islands (United States)",
          "TFYR Macedonia" = "Macedonia (The former Yugoslav Republic of)"
          );
for (i in 1:length(trans)) {
  df$Country = gsub(pattern = names(trans)[i], replacement = trans[i], x = df$Country)
}

rm(list = c("pop", "dei"))
#######
# Load country-2-region table and process it
d = readLines(file.path("..", "extdata", "country2region.txt"));
d.s = sapply(d, function(x) {strsplit(x, " – to ", TRUE)}, simplify = TRUE)

c2r = character(length(d.s));

for (i in 1:length(d.s)) {
    c2r[i] = d.s[[i]][2];
}

names(c2r) = as.character(lapply(d.s, "[[", 1));

names(c2r) = gsub("\\s\\[.*\\]", "", names(c2r))
names(c2r)[244] = "Vietnam";
names(c2r)[121] = "Republic of Korea";
names(c2r)[243] = "Venezuela (Bolivarian Republic of)";
names(c2r)[222] = "Tanzania (United Republic of)";
names(c2r)[107] = "Iran (Islamic Republic of)";
names(c2r)[27] = "Bolivia (Plurinational State of)";
names(c2r)[147] = "Micronesia (Fed. States of)";
names(c2r)[14] = "Australia";
names(c2r)[45] = "Chile"
names(c2r)[172] = "State of Palestine";
names(c2r)[246] = "Virgin Islands (United States)"
names(c2r)[134] = "Macedonia (The former Yugoslav Republic of)"
names(c2r)[120] = "North Korea"
names(c2r)[53] = "Congo (The Democratic Republic)"

# Only take countries that are contained in the c2r as well!
df = df[df$Country %in% names(c2r),]

df$Region = c2r[(df$Country)];

# df2 = df[1:5,]

# df = mutate(df,
#     PopMale = as.integer(gsub("\\.", "", PopMale)),
#     PopFemale = as.integer(gsub("\\.", "", PopFemale)),
#     PopTotal = as.integer(gsub("\\.", "", PopTotal)),
#     Deaths = as.integer(gsub("\\.", "", Deaths)),
#     DeathsMale = as.integer(gsub("\\.", "", DeathsMale)),
#     DeathsFemale = as.integer(gsub("\\.", "", DeathsFemale)),
#     # InfantDeaths = gsub("\\.", "", InfantDeaths),
#     # Survivors1 = gsub("\\.", "", Survivors1),
#     Births = as.integer(gsub("\\.", "", Births)),
#     # TotPopChange = gsub("\\.", "", TotPopChange),
#     PopChange = as.integer(gsub("\\.", "", PopChange))
# )


save(df, file = file.path("..", "extdata", "dataset.rdata"), compress = "xz");

# d.s = d[1:200, c("Country","TFR", "PopTotal")];
# d.s = d[1:200,];
# 
# d.avg = aggregate(d[,c("TFR", "PopTotal")], d[,c("LocID", "Country")], FUN = mean, na.rm = TRUE)
# tbl1 <- gvisTable(head(d.avg, n=200));
# plot(tbl1)
# 
# G1 <- gvisGeoChart(d.avg, Countryvar='Country', colorvar='PopTotal') 
# G1 <- gvisGeoMap(d.avg, Countryvar='Country', numvar ='PopTotal')
# # G1 <- gvisMap(d.avg, Countryvar='Country')
# 
# plot(G1)

# fileConn = file("table.html")
# writeLines(gt$html$chart, fileConn)
# close(fileConn)



