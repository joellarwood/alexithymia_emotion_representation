##################################################################
##                        Face Selection                        ##
##################################################################

# The emotions presented are:
# anger 
#   contempt 
#   disgust 
#   embarrassment 
#   fear 
#   joy
#   pride 
#   sadness 
#   surprise
#   neutral

library(here)

# I will keep 6 examples per category. This gives 38 stimuli.

emotion<- c("Neutral", 
            "Fear", 
            "Sadness", 
            "Joy", 
            "Pride", 
            "Anger") 


# I will have 3 male and 3 female examples. Of one person per turn in, turn out, front on. 
# female codes are F01, F02, F03, F04, and F05 
# male codes are M02, M03, M04, M06, M08, M11, and M12

male <- c("M02", "M03", "M04","M06","M11", "M12")

female <- c("F01", "F02", "F03", "F04", "F05")

direction <- c("Face Forward", "Turn Away", "Turn Forward")

##################################################################
##                      Male Randomisation                      ##
##################################################################

male_a <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_m <- sample(male, 1)
    tmp_file <- paste0(tmp_m, "-", tmp_e, "-", tmp_d, ".mpeg")
    male_a <- append(male_a, tmp_file)
  }
}

male_b <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_m <- sample(male, 1)
    tmp_file <- paste0(tmp_m, "-", tmp_e, "-", tmp_d, ".mpeg")
    male_b <- append(male_b, tmp_file)
  }
}


##################################################################
##                     Female Randomisation                     ##
##################################################################

female_a <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_f <- sample(female, 1)
    tmp_file <- paste0(tmp_f, "-", tmp_e, "-", tmp_d, ".mpeg")
    female_a <- append(female_a, tmp_file)
  }
}

female_b <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_f <- sample(female, 1)
    tmp_file <- paste0(tmp_f, "-", tmp_e, "-", tmp_d, ".mpeg")
    female_b <- append(female_b, tmp_file)
  }
}


##################################################################
##                          Move Files                          ##
##################################################################

###  Create locations                                                  

a_set <- append(female_a, male_a)

b_set <- append(female_b, male_b)

file_loc <- "/Users/joellarwood/Desktop/ADFES"

dest_a <- here::here( #set destination folder
  "exp_files",
  "face_a"
) 

dest_b <- here::here( #set destination folder
  "exp_files",
  "face_b"
) 

###  Move A set    

for(i in 1:36){
  tmp_file <- paste0("/Users/joellarwood/Desktop/ADFES/", a_set[i])
  file.copy(from = tmp_file, 
            to = dest_a)
}


###  Move B set

for(i in 1:36){
  tmp_file <- b_set[i]
  loc_tmp <- paste0(file_loc, "/", tmp_file)
  file.copy(from = loc_tmp, 
            to = dest_b)
}


