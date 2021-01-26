install.packages('tidyverse')
library(tidyverse)
# data manipulation
install.packages('ggplot2')
library(ggplot2)
install.packages('gridExtra')# to create plots for exploratory analysis
library(gridExtra) 
install.packages('GGally')#adding extra grid or outlayer plots to ggplots
library(GGally)
install.packages('GGally')#  helps in building correlation magtrix
install.packages('ggcorrplot')
library(ggcorrplot)
install.packages('randomForest')
library(randomForest)
library(cluster)
order_items<-read.csv(file = "olist_order_items_dataset.csv",header = T);
str(order_items)
products_data<-read.csv(file = "olist_products_dataset.csv",header = T);
products_data
product_category<-read.csv(file = "product_category_name_translation.csv",header = T)
product_category
dfprod<-merge(x = products_data, y = product_category, by = "product_category_name", all.x  = TRUE)
nrow(products_data)
colSums(is.na(product_category))
product_id<-products_data$product_id
product_category_name<-products_data$product_category_name
pdf<-data.frame(product_id,product_category_name)
str(pdf)
nrow(pdf)
dfprod<-merge(x = pdf, y = product_category, by = "product_category_name", all.x  = TRUE)
install.packages("sqldf")
library(sqldf)
f3 <- sqldf("SELECT product_category_name_english, product_category_name, product_id 
              FROM pdf
              JOIN product_category USING(product_category_name)")
str(f3)
f2 <- sqldf("SELECT order_id ,order_item_id,product_category_name_english, product_category_name,price, product_id 
              FROM order_items
              JOIN f3 USING(product_id)")
colSums(is.na(f2))
str(f2)
customers<-read.csv(file = "olist_customers_dataset.csv",header = T);
str(customers)
orders<-read.csv(file = "olist_orders_dataset.csv",header = T);
str(orders)
f1 <- sqldf("SELECT customer_unique_id ,order_id,customer_id
              FROM orders
              JOIN customers USING(customer_id)")
str(f1)
colSums(is.na(f1))

f0 <- sqldf("SELECT customer_unique_id ,order_id,order_item_id,product_category_name_english,price
              FROM f1
              JOIN f2 USING(order_id)")
str(f0)
f0$totalamt<-f0$order_item_id*f0$price
f10 <- sqldf("SELECT customer_unique_id ,product_category_name_english,sum(totalamt) as tamt
              FROM f0 group by customer_unique_id,product_category_name_english")
f10
nrow(unique(f10$customer_unique_id))
library(tidyr) # At least 1.0.0

final1<-f10 %>% pivot_wider(names_from = product_category_name_english, values_from = tamt,values_fill = list(tamt = 0))
final1[,-1]
clusters <- kmeans(final1[,-1], 3)
clusters$cluster

sil_width <- c(NA)

for(i in 2:9){
  
  pam_fit <- kmeans(final1[,-1],i)
  
  sil_width[i] <- pam_fit$silinfo$avg.width
  
}
install.packages("factoextra")
library(factoextra)
fviz_nbclust(final1[,-1], kmeans, method = "silhouette", k.max = 5) + theme_minimal() + ggtitle("The Silhouette Plot")
# Plot sihouette width (higher is better)
fviz_cluster(clusters, data = final1[,-1])
install.packages('devtools')
devtools::install_github("ricardo-bion/ggradar", 
                         dependencies = TRUE)
library(ggradar)
df1<-final1[,-1]
df1$group<-clusters$cluster

library(dplyr)
library(scales)
library(tibble)


mtcars_radar <- df %>% 
  as_tibble(rownames = "group") %>% 
  mutate_at(vars(-group), rescale)%>% 
  tail(4) 



ggradar(mtcars_radar)

plot(1:9, sil_width,
     xlab = "Number of clusters",
     ylab = "Silhouette Width")
lines(1:9, sil_width)

k <- 7
pam_fit <- pam(gow_dis, diss = TRUE, k)

install.packages("arules")
#install.packages("fdm2id")
#install.packages("factoextra")
library(arules)

rules <- apriori(f10,parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
summary(rules)
inspect(rules) #It gives the list of all significant association rules.

