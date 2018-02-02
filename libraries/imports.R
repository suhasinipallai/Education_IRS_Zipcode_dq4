packages <- c(
  "readxl",
  "readr",
  "dplyr",
  "tidyr",
  "stringr"
)

install.packages("packrat")
packrat::init()

for (p in packages) {
  if(p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  } 
}