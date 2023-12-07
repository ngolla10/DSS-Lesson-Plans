# DSS R Workshop #1 
# Basics of R
# Nikhil Golla

# Today we will be learning about the very basics of R syntax, and time permitted, we can dive into stock analysis
# This workshop is meant for absolute beginners and intermediate learners

# 1. First we will walk through how to download R and R Studio

# https://cloud.r-project.org/
# https://posit.co/download/rstudio-desktop/


# 2. R Enables us to do basic Math

# Highlight and Run (Command + Return)

2+2
2*2
2/4
4-2


# 3. Everything important in R boils down to variables, vectors, data frames, and the math we can do on them
# How can we capture, splice, recombine, and reorganize our data so we can derive insights from it


# Variables:
x = 2
y = 2
x+y
x-y
x*y
x/y
x<y
x>y
x=y
# Data Types - We can store our variables in different ways to capture different data
var = 'a'
z = 2.53
log = TRUE
typeof(log)
# The main types of data we see here are numeric, integer, characters, and logical



# Vector:
# This is where it gets a little bit more complex 
# What if we want to store a set of numbers, or a set of values?
# c() function stitches together values and can store it in a variable
# All indexes start at 1
x = c(1,2,3,4,5)
x
# Vector mathematics. Whatever operation you apply, applies to every single value
x = x*3
x
x = x+3
x
# Quick generation of vectors and checking how many elements are in it
b = 1:5
b
b = 5:1
b
c = seq(1,10,2)
c
NROW(c)
# Nesting and combining vectors
a = c(2,4,6,7)
b = 'a'

x = c(a,b,c(1,2,3))
x
# Pulling specific values from a vector and reassignment
x = c(12,19,45,87,33)
x[2]
x[3]
x[3]= 100
x

x[10] = 10
x
# You can reassign any element of the vector, or assign a new element out of bounds. This is different for other programming languages



# Data Frame
# Let's imagine we have multiple vectors, but we want to combine them into a nice table 
a = c(1,2,3,4,5)
b = c('a','b','c','a','c')
x = data.frame(a,b)
x
z = c(3,4,5)
x = data.frame(a,b,z)
x
# This will error, we want to make sure whatever vectors we are combining match up from a length standpoint
y = c(TRUE,FALSE,TRUE,FALSE,FALSE)
x= data.frame(a,b,y)

# Now we have a nicely formatted dataframe
# If you want to get sophisticated, there is something called a data table, which is an upgraded version of a data frame
# It does the same thing as a data frame, but for large data sets, we tend to use data tables

# First install the package for data table by going into packages, install, and looking it up
library(data.table)
P = data.table(a,b,y)
# This wraps up all the basics, now let's apply our knowledge to stocks




# 4. Let's import some stock data and learn how to manipulate it. For today, lets take a look at Nvidia
# Install quantmod package first
library(quantmod)
stock = getSymbols('NVDA',auto.assign = F)
# [Row,Column]
# Isolate down to a specific column
stock = stock[,6]
# Rename
names(stock) = 'prices'
# Isolate down to a specific range of dates
# Lets take the last ~1000 days
stock = stock['2020-03/2023-11-27']
# But we don't have it in data table format
# Get all the dates from this xts table and then transform it into data table
index(stock)
df = data.table(index(stock),stock)
# We can get prices as a huge vector
df$prices

# These are more examples on how to narrow down data
# stock = stock['2020/2021']
# stock = stock['2018-09/2020']
# stock = stock['2018-09-10/2021-10-10']

# Calculate moving average for Nvidia for a range of dates
# Inform a trading strategy based on that

# Transform into data table and double check
stock = df
stock = data.table(stock)
names(stock) = c('date','price')

# Install packages first
library(TTR)
library(ggplot2)

# Calculate SMAs for NVDA and store it in new columns
stock[,fiveSMA:=TTR::SMA(stock$price,n=5)]
stock[,twohundredSMA:=TTR::SMA(stock$price,n=200)]

# Deleting Columns:
# stock = stock[,-5]

# Let's visualize both moving averages and the Adj.close price
pl = ggplot(stock , aes(x = date))
pl = pl + geom_line(aes(y = price, color = "Adj. Close"), group = 1)
pl = pl + geom_line(aes(y = fiveSMA, color = "5 SMA"),group = 1)
pl = pl + geom_line(aes(y = twohundredSMA, color = "200 SMA"), group = 1)
pl = pl +  theme_minimal()
pl = pl + theme(legend.position = "top")
pl = pl + labs(title ="Price & Moving Averages")
pl = pl + labs(color="Legend")
pl


# Whenever the five day SMA and the two hundred SMA intersect, that's called a golden cross
# A golden cross is an indicator that a stock is positioned to rise
# You can see a golden cross happen for NVIDIA around early 2023, and it has shot up ever since


# You can apply this exercise to any stock or portfolio in order to figure out when to buy and sell
# Trading algorithms based off of this exercise can remove human emotion from the equation and focus purely on the indicators

