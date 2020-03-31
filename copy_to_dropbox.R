#---------------------------------------------------------------
##                        Send to dropbox                       -
##---------------------------------------------------------------

git_repo <- here::here()

dropbox <- "/Users/joellarwood/Dropbox/Joel PhD/emotion_representation_alexithymia/git_backup"

file.symlink(from = git_repo, 
            to = dropbox)
