load(file = file.path("extdata", "dataset.rdata"));
regions.unique = unique(df$Region)
# regions.select.choices = 1:(length(regions.unique)+1);
# names(regions.select.choices) = c("World", regions.unique)
regions.select.choices = 1:length(regions.unique);
names(regions.select.choices) = regions.unique;
column.select.choices = 1:(length(colnames(df))-2);
names(column.select.choices) = colnames(df)[-(1:2)]


data.description = data.frame("Field name" = 
                                   c("Location", "Year", "PopMale", "PopFemale", "PopTotal", "GrowthRate", "PopDensity",
                                     "Deaths", "DeathsMale", "DeathsFemale", "LEx", "LExMale", "LExFemale", "Births",
                                     "TFR", "PopChange", "Region"),
                               "Description" = c("Name of country", "Calendar year (1 July)", "Total male population (thousands)",
                                                 "Total female population (thousands)", "Total population, both sexes (thousands)",
                                                 "Annual average annual rate of population change(%)",
                                                 "Population density (persons per squre km",
                                                 "Mortality indicators: Deaths per year, both sexes combined (thousands)",
                                                 "Mortality indicators: Female deaths per year (thousands)",
                                                 "Mortality indicators: Male deaths per year (thousands)",
                                                 "Mortality indicators: Life expectancy at birth [e(0)] (both sexes combined, years)",
                                                 "Mortality indicators: Male life expectancy at birth [e(0)] (years)",
                                                 "Mortality indicators: Female life expectancy at birth [e(0)] (years)",
                                                 "Fertility indicators: Births per year (thousands)",
                                                 "Fertility indicators: Total fertility (children per woman)",
                                                 "Natural change indicators: Total population natural change [i.e., Births-Deaths] (thousands)",
                                                 "Region the country can be assigned to"),
                               stringsAsFactors = FALSE)
data.description$Description = format(data.description$Description, justify = c("left"))
