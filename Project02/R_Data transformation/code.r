library(tidyverse)
library(sqldf)
library(glue)

# explore dataframe
glimpse(mtcars)

head(mtcars, 3)
tail(mtcars, 2)

# sql
# run sql query with R dataframe

sqldf("select * from mtcars
      where mpg > 30")


sqldf("select mpg,wt,hp from mtcars
      where wt < 2")

sqldf("select am, avg(mpg), sum(mpg)
      from mtcars group by am")



# glue 
# string template

my_name <- "toy"
my_age <- 34

glue("Hello my name is {my_name}")



# tidyverse
# dplyr => data transformation
# 1. select
# 2. filter
# 3. mutate
# 4. arrange
# 5. summarise + group_by



# select columns

mtcars %>%
  select(mpg, hp, wt, am )

select( mtcars, contains("a") )

select( mtcars, starts_with("a") )

select( mtcars, ends_with("p") )

select( mtcars, 1:5 , am )

select( mtcars, mpg:drat )


# %>% pipe Operator
# Data pipeline in R

mtcars %>%
  head() %>%
  rownames()


mtcars %>%
  rownames_to_column() %>%
  select(model = rowname, 
         milePerGallon = mpg,
         horsePower = hp,
         weight = wt) %>%
  head()


mtcars <- mtcars %>%
  rownames_to_column()

mtcars <- mtcars %>%
  rename(model = rowname)

# can be in this 
mtcars <- mtcars %>%
  rownames_to_column() %>%
  rename(model = rowname)


# filter model names
mtcars %>%
  select(model, mpg, hp, wt) %>%
  filter(grepl("^M", model))

mtcars %>%
  select(model, mpg, hp, wt) %>%
  filter(grepl("n$", model))


# mutate crate new column
df <- mtcars %>%
  select(model, mpg, hp) %>%
  head() %>%
  mutate(mpg_double = mpg*2,
         mpg_log = log(mpg),
         hp_double = hp*2)


# arrange sort data
mtcars %>%
  select(model, mpg, am) %>%
  arrange(desc(mpg)) %>%
  head(10)


mtcars %>%
  select(model, am, mpg) %>%
  arrange(am, desc(mpg)) 


# create label 
# am (0=auto, 1=manual)

mtcars <- mtcars %>%
  mutate(am = ifelse(am==0, "Auto", "Manual"))


# create dataframe from scatch 
df <- data.frame(
  id = 1:5,
  country = c("Thailand", "Korea", "Japan", "USA", "Belgium")
)


# summarize + group by

result <- mtcars %>%
  mutate(vs = ifelse(vs==0, "v-shaped", "straight")) %>%
  group_by(am, vs) %>%
  summarize( avg_mpg = mean(mpg),
             sum_mpg = sum(mpg),
             min_mpg = min(mpg),
             max_mpg = max(mpg),
             n = n() )

view(result)

write_csv(result, "result.csv")

df <- read_csv("result.csv")


#Missing Value (NA = Not Available)
v1 <- c(5, 10, 15, NA, 25)

#NA check by using is.na()
is.na(v1)

data("mtcars")

mtcars[5, 1] <- NA

#Filter NA
mtcars %>% 
  filter(is.na(mpg))

#Filter complete case
mtcars %>% 
  select(mpg, hp, wt) %>%
  filter(!is.na(mpg))


mtcars %>%
  filter(!is.na(mpg)) %>%
  summarise(avg_mpg = mean(mpg))

mtcars %>%
  summarise(avg_mpg = mean(mpg, na.rm = TRUE))

mean_mpg <- mtcars %>% 
  summarise(mean(mpg, na.rm = TRUE)) %>%
  pull()


mtcars %>%
  select(mpg) %>%
  mutate(mpg2 = replace_na(mpg, mean_mpg))


#Looping over data frame
data(mtcars)
#For other programming language, use for loop
for(i in 1 : ncol(mtcars)) {
  print(mean(mtcars[[i]]))
}
#In R, using apply() to loop over data frame:
#Apply mean to all columns in mtcars
#1 = row 2 = column
apply(mtcars, 2, mean)

apply(mtcars, 2, sum)



#JOIN data frame
#JOINs In SQL: INNER, LEFT, RIGHT, FULL

band_members
band_instruments

left_join(band_members, band_instruments, by = "name")
#OR
band_members %>%
  left_join(band_instruments, by = "name")

band_members %>%
  inner_join(band_instruments, by = "name")

band_members %>%
  full_join(band_instruments, by = "name")

band_members %>%
  rename(member_name = name) -> band_members_2

band_members_2 %>%
  left_join(band_instruments, by = c("member_name" = "name"))

?left_join




#Use larger library
library(nycflights13)

glimpse(flights)

flights %>% 
  filter(year == 2013 & month == 9) %>%
  count(carrier) %>%
  ## shortcut arrange(desc(n))
  arrange(-n) %>%
  head(5) %>%
  left_join(airlines, by = "carrier")

glimpse(airlines)




#load rvest and tidyverse
library(rvest)
library(tidyverse)

url <- "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating.desc"

#Static Website (Ex.: Wikipedia)

movie_name <- url %>%
  read_html() %>%
  html_elements("h3.lister-item-header") %>%
  html_text2()

ratings <- url %>%
  read_html() %>%
  html_elements("div.ratings-imdb-rating") %>%
  html_text2()

votes <- url %>%
  read_html() %>%
  html_elements("p.sort-num_votes-visible") %>%
  html_text2()

imdb_df <- data.frame(
  movie_name,
  ratings,
  votes
)

imdb_df %>%
  separate(votes, sep=" \\| ", into=c("votes", 
                                      "gross", 
                                      "tops")) %>%
  View()

specphone_url <- "https://specphone.com/Samsung-Galaxy-S23-5G.html"

specphone_url %>%
  read_html() %>%
  html_elements("div.topic") %>%
  html_text2()

specphone_url %>%
  read_html() %>%
  html_elements("div.detail") %>%
  html_text2()

































































