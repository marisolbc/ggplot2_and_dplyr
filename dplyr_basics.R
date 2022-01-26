library(dplyr)

##### Basic Operation #####

data(starwars)
head(starwars)

## select: subset column ##
select(starwars,name,height,mass,species,homeworld)
select(starwars,name:homeworld)

## filter: subset rows by condition ##
filter(starwars,species=="Droid")
filter(starwars,species=="Human",mass < 100)
filter(starwars,species=="Human" | mass < 100)

## mutate: create a new column
mutate(starwars,height_by_mass = height / mass)

## group_by: group data
group_by(starwars,gender)

## summarize: create stats from group data
summarize(group_by(starwars,gender),mean_mass = mean(mass,na.rm=T))
summarize(group_by(starwars,gender),mean_height = mean(height,na.rm=T))

## arrange: sort columns
arrange(starwars,mass)
arrange(starwars,desc(mass))

## count: count discrete values
count(starwars,sex)

## pipes: the usual way to use dplyr --> dataframe %>% operation1 %>% operation 2 .....
starwars %>% select(name,height)
starwars %>% group_by(gender) %>% summarise(mean_mas=mean(mass,na.rm=T))
starwars %>% select(name:species) %>% filter(species != "Human") %>% group_by(sex) %>% summarize(max_height = max(height,na.rm=T))