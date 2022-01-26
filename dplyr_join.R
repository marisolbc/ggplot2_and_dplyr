library(dplyr)

superheroes = data.frame(name = c("Magneto","Storm","Mystique","Batman","Joker","Catwoman","Hellboy"),
                         alignment = c("bad","good","bad","good","bad","bad","good"),
                         gender = c("male","female","female","male","male","female","male"),
                         publisher = c("Marvel","Marvel","Marvel","DC","DC","DC","Dark Horse Comics"))

publishers = data.frame(publisher = c("DC","Marvel","Image"),
                        year_founded = c(1934,1939,1992))


## Inner join: MATCH IN BOTH TABLES

superheroes %>% inner_join(publishers,by="publisher")

## Left join: prioritizes left table
superheroes %>% left_join(publishers,by="publisher")

## Right join: prioritizes right table
publishers %>% right_join(superheroes,by="publisher")

## Full join: retains all rows
superheroes %>% full_join(publishers,by="publisher")

## Semi join: match in both tables but do not add the information from the second table
superheroes %>% inner_join(publishers,by="publisher")
superheroes %>% semi_join(publishers,by="publisher")

## anti_join: contrary of semi_join
superheroes %>% anti_join(publishers,by="publisher")


superheroes %>% inner_join(publishers,by="publisher") %>% filter(alignment == "good")
