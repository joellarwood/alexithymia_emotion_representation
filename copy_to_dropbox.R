#---------------------------------------------------------------
##                        Send to dropbox                       -
##---------------------------------------------------------------

git_repo <- here::here()

dropbox <- "/Users/joellarwood/Dropbox/Joel PhD/Emotion Representation in Alexithymia/git_backup"

file.symlink(from = git_repo, 
            to = dropbox)
