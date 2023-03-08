# SHERLOCK PACKAGE 

library(tidyverse)
library(sherlock)

# Sherlock provides engineers working in a manufacturing setting with graphical tools and techniques to help diagnose 
# product or manufacturing process performance related problems. Many of the plots sherlock provides are based on the 
# concept of small multiples, a powerful concept for visualizing contrast.



# 1. MULTIVARI PLOTS ----
# A type of small multiples plot used for problem diagnosis. Can be used for diagnosing both manufacturing and transactional type of prpoblems.
# A stratified sample is taken and plotted where each group of observations is plotted separately and conrasted against one another.
# Answers the question: Which group varies the most? This provides clues for the investigator to continue their search.
# For diagnosing problems in manufacturing, the following nested grouping structure is best (bottom to top):
# 1. elemental (within one machine cycle or one part)
# 2. cyclical (consecutive machine cycles)
# 3. structural (between parallel streams) and 
# 4. temporal (time-related)

# 1.1 MANUFACTURING EXAMPLE ----
bond_strength_multivari <- 
    sherlock::load_file("https://raw.githubusercontent.com/gaboraszabo/datasets-for-sherlock/main/bond_strength_multivari.csv", 
              filetype = ".csv")

bond_strength_multivari %>% 
    draw_multivari_plot(response = `Bond Strength`, factor_1 = Cycle, factor_2 = `Bonding Station`, factor_3 = Time) +
    draw_horizontal_reference_line(reference_line = 12, color = "red", linetype = "dashed") +
    labs(y = "Bond Strength [lbf]")

# Bond strength results from manufacturing run
# Red dashed line drawn at lower specification limit of 12 lbf
# This plot shows that cyclical group shows most variation (i.e. we are already seeing most of the variation 
# show up between two consecutive machine cycles, although only some of the time)
# This provides information to the engineer as to where they should continue their search




# 2. YOUDEN PLOTS ----

# Another small multiples type of plot
# A special kind of scatter plot where paired measurements are captured, one on the X axis, the other on the Y axis
# The diagonal line is called the line of perfect agreement or 1:1 line (when the two measurements are identical)
# Departures from the 45-degree line signify differences between the paired measurements
# Can be used for measurement system analysis, problem diagnosis and other experimental studies


# 2.1 YOUDEN PLOT EXAMPLE - Canned dataset from sherlock
youden_plot_data_2 %>% 
    draw_youden_plot(x_axis_var = gage_1, 
                     y_axis_var = gage_2, 
                     lsl = 80, 
                     usl = 110, 
                     analysis_desc_label = "Method Comparison, line 1 and 2 gages")

# Method comparison study for the end-of-the-line-gages that measure a critical product characteristic on two parallel manufacturing lines 
# The plot shows that there are systemic differences between gage 1 and gage 2; measurements from gage 2 tend to come in 
# consistenly higher than those from gage 2 - METHOD BIAS 
# Red rectangle represents specification limits
# Risk of one gage accepting units close to spec limit and the other gage rejecting the same units


# 2.2 RE-PLOTTED WITH MEDIAN LINE
plot_method_comparison <- youden_plot_data_2 %>% 
    draw_youden_plot(x_axis_var = gage_1, 
                     y_axis_var = gage_2, 
                     analysis_desc_label = "Method Comparison, line 1 and 2 gages", 
                     median_line = TRUE)

# Median line added to visualize amount of bias
# Bias seems to be linear
# This information provides the investigator with clues as to what the cause of the bias could be


sherlock::save_analysis(data = youden_plot_data_2, 
              plot = plot_method_comparison, 
              filename = "method_comparison", filepath = "put_your_local_filepath_here")

# save_analysis() function to save data and plot into an Excel file.




