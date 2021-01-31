library(rmarkdown)
library(mailR)

# required to get pandoc to work properly when using Windows to schedule
# https://beta.rstudioconnect.com/content/3132/Job_Scheduling_R_Markdown_Reports_via_R.html
Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")

# Clean up old file if it exists
# Assign filename
fn <- "coronavirus.html"

if (file.exists(fn)) {
  file.remove(fn)
}

# Render a single format, weekly report to email myself
render("coronavirus.Rmd", "html_document")

# If the above worked, email to myself
# if (TRUE %in% (list.files() == fn)) {
#   # Send email to myself with plots attached.
#   print("email")
#   send.mail(from = "<grantchalmers@yahoo.com>",
#             to = c("<grantlchalmers@hotmail.com>"),
#             bcc = c("<grant.chalmers@uq.edu.au>",
#                     "<meganchalmers@hotmail.com>",
#                     "<tillara.station@yahoo.com.au>",
#                     "<rosschalmers@yahoo.com>",
#                     "<paul@chalmersfinancial.com.au>",
#                     "<Jamesridley188@hotmail.com>",
#                     "<timothy86walsh@gmail.com>"),
#             # "<chapg9@gmail.com>"),
#             subject = "Coronavirus Snapshot",
#             body = "Weekly Coronavirus Snapshot, send return email if you want to opt out!",
#             smtp = list(host.name = "smtp.mail.yahoo.com", ssl = TRUE,
#                         user.name = "grantchalmers",
#                         passwd = "cachebyter998"),
#             authenticate = TRUE,
#             send = TRUE,
#             attach.files = fn,
#             debug = TRUE)
# } 

