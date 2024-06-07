# Weekly deaths visualization for 2024 # 

# Data from ONS 
# Some of the visulisation code from BBC visuals - https://bbc.github.io/rcookbook/#how_to_create_bbc_style_graphics
# Load packages - tidyverse (various data manipulation and visualisation packages), scales (graphical scales to map aesthetics), 
# bbplot (bbc plot function) and readxl (package for loading xls/xlsx documents into R)
pacman::p_load('tidyverse',
               'scales',
               'bbplot', 
               'readxl')

# Set working directory
setwd("C:/Users/MarkE/OneDrive/Desktop")

# Weekly deaths data - from ONS https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales 
Deaths <- read_excel("weeklydeathsweek212024.xlsx", sheet = "Table_3", skip = 5) 

# Split the data into two separate datasets for example visuals. 
# These are, East Midlands - cases involving disease of the respiratory system and England data for all cause deaths. 

# Filter dataset for just those in East Midlands - involving disease of the respiratory system 
Deaths_EM_2024 <- Deaths %>% 
  filter(`Area of usual residence` == "East Midlands", 
         `Cause of death` == 'Deaths involving diseases of the respiratory system (J00 to J99)')

# Filter dataset for records of England and casuse of death being 'all causes' 
Deaths_Eng_All_2024 <- Deaths %>% 
  filter(`Area of usual residence` == "England", 
         `Cause of death` == 'All causes')


# Change the week ending into date format - East Midlands data 
Deaths_EM_2024$`Week ending` <- as.Date(as.character(Deaths_EM_2024$`Week ending`), "%d %B %Y")

# Change the date format to Posix ct for visualisation - East Midlands data 
Deaths_EM_2024$`Week ending` <- as.POSIXct.Date(Deaths_EM_2024$`Week ending`)

# Change the week ending into date format - England data 
Deaths_Eng_All_2024$`Week ending` <- as.Date(as.character(Deaths_Eng_All_2024$`Week ending`), "%d %B %Y")

# Change the date format to Posix ct for visualisation - England data
Deaths_Eng_All_2024$`Week ending` <- as.POSIXct.Date(Deaths_Eng_All_2024$`Week ending`)


# Plot a time series of respiratory deaths over time - East Midlands 2024
ggplot(data = Deaths_EM_2024, aes(x = `Week ending`, y = `Number of deaths`)) + # First layer of the visual, includes dataset, and the x & y you would like to include 
  geom_line(linewidth = 1.2, color = "blue") + # Geom_line for adding a line to the chart, for this example we've used a linewidth of 1.2 and coloured it blue
  geom_point(size = 2) + # add points to the visual to see how many data points there are. Make this size 2 in this example 
  geom_hline(yintercept = 0, size = 1, colour="#333333") + # add bottom line on the x axis, along the zero
  theme_classic() + # use a classic theme
  ggtitle("Number of Deaths Involving Disease of the Respiratory System in the East Midlands - 2024") + # add a title to the plot
  ylab("Number of Deaths") + # Change the name of the y axis - not included in BBC style
  xlab("Date") + # Change the name of the x axis - not included in BBC style 
  ylim(0, 500) + # Include the limits of the y axis, between 0 and 500
  bbc_style() + # Use the BBC styling to the chart 
  scale_x_datetime(labels = date_format("%d %b %Y")) # Format the dates on the x axis as 2 digit day, 3 letter month, and full year. 


# Plot a time series of all cause deaths over time - England 2024
ggplot(data = Deaths_Eng_All_2024, aes(x = `Week ending`, y = `Number of deaths`)) + # First layer of the visual, includes dataset, and the x & y you would like to include 
  geom_line(linewidth = 1.2, color = "blue") + # Geom_line for adding a line to the chart, for this example we've used a linewidth of 1.2 and coloured it blue
  geom_point(size = 2) + # add points to the visual to see how many data points there are. Make this size 2 in this example 
  geom_hline(yintercept = 0, size = 1, colour="#333333") + # add bottom line on the x axis, along the zero
  theme_classic() + # use a classic theme
  ggtitle("Number of Deaths All Causes in England - 2024") + # add a title to the plot
  ylab("Number of Deaths") + # Change the name of the y axis - not included in BBC style
  xlab("Date") + # Change the name of the x axis - not included in BBC style 
  ylim(0, 15000) + # Include the limits for the y axis - between 0 and 15,000
  bbc_style() + # Use the BBC styling to the chart 
  scale_x_datetime(labels = date_format("%d %b %Y")) # Format the dates on the x axis as 2 digit day, 3 letter month, and full year. 
