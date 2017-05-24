library(tidyverse)
library(readxl)
## Meta data
# A
# "1.a US54.xlsx": 
# "1.b US57.xlsx":
# "1.c US58.xlsx":
# OBSERVACAOES DA CONSULTA:
# "2.a US com lab 37.xlsx":
# "2.b US com lab 40.xlsx":
# "2.c US com lab.xlsx":
# TEST
# "3.a Cons.lab.xlsx":
# "3.b Cons.s.lab.xlsx":
# "Armazem.xlsx":
# "Condicoes_Gerais_da_US.xlsx":
# "Entrevista a saida.xlsx":
# "RDTs no lab.xlsx":
# "Tudo Junto.xlsx":
files <- dir('data')
for (i in 1:length(files)){
  this_file <- files[i]
  this_name <- gsub('.xlsx', '', this_file)
  x <- read_excel(paste0('data/', this_file))
  assign(this_name,
         x)
}

# Combine all of the observations from US without labs
us <- bind_rows(`1.a US54`,
                `1.b US57`,
                `1.c US58`)
# 
# # Create a dictionary for all databases, for Lurdes to fill out later
# results_list <- list()
# for (i in 1:length(files)){
#   this_file <- files[i]
#   this_name <- gsub('.xlsx', '', this_file)
#   these_data <- get(this_name)
#   # Create a dataframe
#   out <- data_frame(db = this_file,
#                     variable = names(these_data),
#                     name = '')
#   results_list[[i]] <- out
#   
# }
# results <- bind_rows(results_list)
# write_csv(results, '~/Desktop/rdt_dictionary.csv')

# Use dictionary to translate names
need_transation <-
  files[files != 'rdt_dictionary.xlsx']

for (i in 1:length(need_transation)){
  this_file <- need_transation[i]
  this_object_name <- gsub('.xlsx', '', this_file)
  this_object <- get(this_object_name)
  this_dictionary <- rdt_dictionary %>%
    filter(db == this_file)
  new_column_names <- 
    this_dictionary$name[this_dictionary$variable == names(this_object)]
  names(this_object) <- new_column_names
  this_object <- data.frame(this_object)
  for (j in 1:ncol(this_object)){
    this_object[,j] <- as.character(this_object[,j])
  }
  assign(this_object_name,
         this_object)
  }

# Combine into one master dataset
master <- 
  bind_rows(
  `1.a US54`,
  `1.b US57`,
  `1.c US58`,
  `2.a US com lab 37`,
  `2.b US com lab 40`,
  `2.c US com lab`,
  `3.a Cons.lab`,
  `3.b Cons.s.lab`,
  # `Armazem`,
  # `Condicoes_Gerais_da_US`,
  # `Entrevista a saida`,
  `RDTs no lab`#,
  # `Tudo Junto`
)
