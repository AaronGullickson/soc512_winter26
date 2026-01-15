####################
# Soc 412/512      #
# Learning R       #
# Week 2           #
# Winter 2026      #
# Aaron Gullickson #
####################

# Conventions to remember:
# use lower_snake_case, not CamelCase and no SHOUTING
# leave space between operators (assignment, commas, boolean symbols, etc.)
# lines should be 80 characters or less

# Basic Object Types ------------------------------------------------------

# numeric value
a <- 2 # integer
d <- 2.01 # double

# character (string)
b <- "hot dog"

# logical
c <- TRUE

# mathematical operations on basic types
a+2
b*12
c*12
12*FALSE

# recasting types
as.character(a)
as.numeric("42")
as.logical(1)
as.numeric(c)
as.numeric(b)

# Vectors -----------------------------------------------------------------

name <- c("Martha", "Bilbo", "Vern", "Geoffrey", "Wilma")
age <- c(54, 111, 67, 14, 78)
age*2
gender <- c('Female', 'Male', 'Male', 'Male', 'Female')
like_soccer <- c(FALSE, TRUE, TRUE, FALSE, FALSE)

length(age)
mean(age)
mean(gender)
mean(like_soccer)

# indexing a vector
age[3]
age[c(2,3)]
age[2:4]

# Matrices ---------------------------------------------------------------

matrix_a <- cbind(c(3, 5, 7), c(4,12, 6))
                  
matrix_a[2, 1]

bad_dataset <- cbind(name, age, gender, like_soccer)


# Factors -----------------------------------------------------------------

# factors - categorical variables
gender_fctr <- factor(gender)

# what are the levels?
level(gender_fctr)

# ordering levels
gender_fctr <- factor(gender, levels = c("Male", "Female"))
levels(gender_fctr)

# be careful of typos!!
gender_fctr <- factor(gender, levels = c("Male", "female"))
levels(gender_fctr)

# ordering and labeling levels
gender_fctr <- factor(gender, 
                      levels = c("Male", "Female"),
                      labels = c("M", "F"))
levels(gender_fctr)



# Lists -------------------------------------------------------------------

# unnamed list
my_list <- list(name, age, gender, like_soccer)

# indexing the list
my_list[[1]]

# named list
my_list <- list(name = name,
                age = age,
                gender = gender,
                soccer = like_soccer)

# reference by name
mean(my_list$age)


# Data Frame --------------------------------------------------------------

# same setup as list
my_df <- data.frame(name = name,
                    age = age,
                    gender = gender,
                    soccer = like_soccer)

mean(my_df$age)
my_df[3, 3]
my_df[3, "gender"]

# you can reference a variable with square brackets but $ is better
my_df[, "gender"]
my_df$gender


# Boolean statements -------------------------------------------------------

# <  - less than
# >  - greater than
# <= - less than or equal
# >= - greater than or equal
# != - not equal
# == - equal to

my_df$age >= 65
my_df$gender == "Female"

my_df$gender <- factor(my_df$gender, 
                       levels = c("Male", "Female"),
                       labels = c("M", "F"))
  
my_df$gender == "F"

my_df$gender != "F"

# compound statements
# & AND
# | OR

my_df$age < 65 & my_df$gender == "M"
my_df$age < 65 | my_df$gender == "M"

# use parenthesis to clarify order of operations
(my_df$age < 65 & my_df$gender == "M") | my_df$soccer
my_df$age < 65 & (my_df$gender == "M" | my_df$soccer)

# print out which observations are TRUE
# use the which command which gives you row index
my_df[which(my_df$age < 65 & (my_df$gender == "M" | my_df$soccer)), ]
# or use the subset command which is cleaner
subset(my_df, age < 65 & (gender == "M" | soccer))


