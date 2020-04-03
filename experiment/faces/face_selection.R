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

emotion <- c("Neutral", 
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

male_faces <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_m <- sample(male, 1)
    tmp_file <- paste0(tmp_m, "-", tmp_e, "-", tmp_d, ".mpeg")
    male_faces <- append(male_faces, tmp_file)
  }
}

##################################################################
##                     Female Randomisation                     ##
##################################################################

female_faces <- vector()

for (e in c(1:6)){
  for (d in c(1:3)){
    tmp_e <- emotion[e]
    tmp_d <- direction[d]
    tmp_f <- sample(female, 1)
    tmp_file <- paste0(tmp_f, "-", tmp_e, "-", tmp_d, ".mpeg")
    female_faces <- append(female_faces, tmp_file)
  }
}

faces <- append(male_faces, female_faces)

##----------------------------------
##  Move to destination and recode  
##----------------------------------
library(av)


dest_faces <- here::here(
  "experiment", 
  "faces"
)

unlink(
  paste0(
    dest_faces, "/*"
    )
)


for(i in 1:36){
  tmp_file <- faces[i]
  tmp_input <- paste0("/Users/joellarwood/Desktop/ADFES/", tmp_file) # set file to import
  tmp_rename <- stringr::str_replace( #recode for output
    tmp_file, 
    ".mpeg", 
    ".mp4"
  ) 
  tmp_out <- paste0(dest_faces, "/", tmp_rename) #path to converted video
  av_encode_video(
    input = tmp_input, #imports from desktop
    output = tmp_out, # outputs to experiment file folder 
  )
}
