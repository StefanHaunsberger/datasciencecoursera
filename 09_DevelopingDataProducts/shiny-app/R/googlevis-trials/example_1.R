
require(googleVis)

# Example from:
# http://www.inside-r.org/packages/cran/googleVis/docs/gvisTable

## Please note that by default the googleVis plot command
## will open a browser window and requires Flash and Internet
## connection to display the visualisation.

## Table with links to wikipedia (flags) 
tbl1 <- gvisTable(Population)
plot(tbl1)

## Table with enabled paging
tbl2 <- gvisTable(Population, options=list(page='enable', height=500))

plot(tbl2)

## Table with formating options
tbl3 <- gvisTable(Population, formats=list(Population="#,###"))

Population[['% of World Population']] <- Population[['% of World Population']]/100 
tbl4 <- gvisTable(Population, formats=list(Population="#,###", 
                                           '% of World Population'='#.#%'))
plot(tbl4)
