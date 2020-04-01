#---------------------------------------------------------------
##                        Send to dropbox                       -
##---------------------------------------------------------------

git_files <- list.files(here::here())

dropbox <- "/Users/joellarwood/Dropbox/Joel PhD/emotion_representation_alexithymia/git_backup"

file.copy(from = git_files, 
             to = dropbox, 
          overwrite= TRUE, 
          recursive = TRUE )
