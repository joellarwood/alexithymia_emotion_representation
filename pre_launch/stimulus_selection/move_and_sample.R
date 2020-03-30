#################################################################
##                Moving and Manipulating Songs                ##
#################################################################
install.packages("av")
library("av")

###  Move Songs                

chosen <- selected_songs$file_name # this requires the Rmd file to have been run
dest <- here::here( #set destination folder
  "pre_launch",
  "stimulus_selection",
  "full_files"
) 

for (i in (1:32)) { #moves files from my download folder to the project folder 
  name_tmp <- chosen[i]
  file_tmp <- paste0("/Users/joellarwood/Downloads/clips_45seconds/", name_tmp)
  file.copy(file_tmp, dest)
}


###  Split songs block A                                         
# For the first block I will take a random 5 second chunk of the song that occurs between 15 and 23 seconds
# I will generate 32 random numbers for this 

base_dir_samples_a <- here::here( #set destination folder
 "exp_files",
 "audio_a"
) 

set.seed(1234)

start_pos_block_a <- runif(32, min = 15, max = 23)

start_times_a <- data.frame()

for (i in 1:32){ # This loop create the files for set a
  name_tmp <- chosen[i]
  input_tmp <- paste0(dest, "/", name_tmp)
  output_tmp <- paste0(base_dir_samples_a, "/", name_tmp)
  start_tmp <- start_pos_block_a[i]
  start_times_a <- rbind(start_tmp, start_times_a)
  av::av_audio_convert(audio = input_tmp, 
                       output = output_tmp, 
                       start_time = start_tmp, 
                       total_time = 5)
} 

write.csv(start_times_a, paste0(base_dir_samples_a, "/start_times_a.csv"))

###  Split songs block B                                         
# For the first block I will take a random 5 second chunk of the song that occurs between 30 and 38 seconds
# I will generate 32 random numbers for this 

base_dir_samples_b <- here::here( #set destination folder
  "exp_files",
  "audio_b"
) 

start_pos_block_b <- runif(32, min = 30, max = 38)

start_times_b <- data.frame()

for (i in 1:32){ # This loop create the files for set a
  name_tmp <- chosen[i]
  input_tmp <- paste0(dest, "/", name_tmp)
  output_tmp <- paste0(base_dir_samples_b, "/", name_tmp)
  start_tmp <- start_pos_block_b[i]
  start_times_b <- rbind(start_tmp, start_times_b)
  av::av_audio_convert(audio = input_tmp, 
                       output = output_tmp, 
                       start_time = start_tmp, 
                       total_time = 5)
} 


write.csv(start_times_b, paste0(base_dir_samples_b, "/start_times_b.csv"))


