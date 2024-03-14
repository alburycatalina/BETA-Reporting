



# Setup -------------------------------------------------------------------
# Load required packages 
library(kable)

# Set wd
setwd("~/OneDrive/Documents/Life/Coding-Projects/BETA-Reporting/RAW")


participant_df <- read.csv("BETA Camp 2021 Applicants - General.csv")



# Island of Residence -----------------------------------------------------

isl_res_table <- participant_df %>%
  select(Island) %>%
  count(Island, name = "n_students") %>%
  sort("n_students")

ggplot(data = isl_res_table, aes(x = reorder(Island, -n_students), 
                                 y = n_students, 
                                 fill = n_students)) +
  geom_bar(stat="identity") +
  scale_fill_gradient(low = "#e0baab",
                      high = "#f36c34",
                      guide = NULL) +
  geom_text(aes(label = n_students), 
            vjust=-.75, 
            size = 6) +
  theme_classic() +
  theme(text = element_text(size = 20),
        axis.text.x = element_text(angle = 30, hjust = 1)) +
  ylab("Number of Students") +
  xlab("Island of Residence") +
  ylim(0,50)




