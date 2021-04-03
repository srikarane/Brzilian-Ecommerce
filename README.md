# Brzilian-Ecommerce
Customer Segmentation and Products Recommendation Engine on Brazilian Ecommerce 


## Introduction:
This Project focuses on the analyzing the heterogenous features of Brazilian ecommerce dataset. Dataset consists of 9 files each file describes the details of orders, customers, Payments, Products and reviews respectively. Dataset has around 100k orders from Brazilian marketplace at multiple locations in Brazil. This Dataset was provided by Olist, large departmental store in Brazil.

  Project is divided into 2 parts, 
  ### First Part
  In first part of project it mainly focuses on customer segmentation and finding customer patterns by analyzing the behavioral and psychographics data of a customer, which helps the organization to analyze, on which products the customers are mostly likely to buy it and for which category of product they need to increase their quantity to maximize their profits. It is basically we segment the customers into different cluster groups and apply apriori algorithm to find the association rules and patterns. 
  ### Second Part
     In the second part of project mainly focuses on the recommending the product to a customer by analyzing the customer interests derived from above rules in first part  and reviews and even taking the consideration of delivery performance and finally analyzing the quality of products. 
     
  ## What is different from other papers?
  * None of the papers considered applying association rule algorithm APRIORI upon the clusters and use those rules for recommendation engine. 
  * Most of the projects on recommendation doesn’t consider the delivery performance, geological distance and analyzation of reviews with in it. 
  * In this project we try embed all these concepts and try to make a recommender system which not only analyze the results but also make an analysis from the 	      clusters obtained and rules and then makes a recommendation.

## Objectives:
*	Forming a rich dataset by Integrating the data from different files which can be used in modeling the customer segmentation.
*	Performing customer segmentation to create a cluster of customers specifying what are there interests on products for each group.
*	Analyzing which products are more interested and prone to get selled.
*	Analyzing the patterns of the clusters and find the valuable insights which would be helpful in increase of business market.
*	Recommendation of products per customer by considering reviews, geological distance and previous purchases and using the previous clustering information.

# Process Flow:
 
<img src="https://github.com/srikarane/Brzilian-Ecommerce/blob/main/Richdataset%20formation.jpg">
# Selected Features:
For recommendation engine we will use all the features except the state and city feature and for predicting the sales we won’t be using the unique id ‘s  and some of the features we will be deriving such as distance from the 2 zip codes latitudes and longitudes , number of days consumed for shipment etc. For clustering technique we would be not using reviews dataset except the rating score and also not use the id’s in different data sets.
	These features are not final selected features it may change after my 1st training. Then again we apply some feature importance algorithms or feature selection algorithms  to obtain selected features for our model, considering even the correlations among them.
# Description of Proposed System:
* First we load all our files in AWS S3 module and we will store and access them in EC2 instances. In R querying the Datasets and Integrating the datasets to make a rich dataset which will be used for our models. 
* Once the Final Dataset is ready we will access this data set by using Pyspark and perform our Data Analytics where we will be doing the Customer Segmentation and Recommendation Engine in it. Once it is done we will store the results in AWS S3 and go for visualizing the results obtained and find the insights from it. 


Each of our step will be clearly briefed in below sections.
 
# Methods to be proposed are:
Initially we load the all 9 data files into AWS S3 Data lake. Then create EC2 instances in AWS . In the EC2 instances we will access R and do the Data preprocessing on all 9 datafiles such as find the missing values and impute them with the mean if it is a numerical variable or mode with a categorical variable and removing the duplicate rows. Then we formulate a rich dataset by aggregating all the 9 files.

# Preparation of rich dataset:
 
<img src="https://github.com/srikarane/Brzilian-Ecommerce/blob/main/Richdataset%20formation.jpg">

# New Features Derived:

* Is_latedelivered: if it is a late delivery will have value 0 and if it’s not value will be 1. This feature will be derived by subtracting the dates of estimated delivery date and delivered date by using order dataset.
* No_of latedeliverydays: If it’s not a late delivery the number of days the ordered delivered late is 0 otherwise it will be the negative . This feature will be derived by subtracting the dates of estimated delivery date and delivered date by using order dataset.
* TFidf frequency for review text: By using review text we will create a tfidf frequency for the words in our review corpus.
* Distance: calculate the distance between customer and seller. This will be calculated by matching the customer id in the orders and customer dataset and then link the order id with order item dataset and then linking with seller id of order item dataset and sellers database. Extracting customer zip codes and seller zipcodes for each order and then we use geological dataset to extract longitude and latitude and calculate distance.
* Polarity_of_review_text: By analyzing the review description and review title and will be making an sentiment analysis from it whether it is a positive polarity or negative polarity.
* No_of _Positive_words: Will calculate the no of positive words in each review.
* No_of _negative_words: Will calculate the no of negative words in each review
* After formulating final dataset table we will again store it into Amazon S3 data lake for future access.

# Descriptive Analytics:
*	What is the amount spent on each product category purchased by all customers?
*	Which state of sellers has maximum profit?
*	From which state the maximum number of customers are buying?
*	How many people are using installment payment method?
*	How many product are there in each review score?

# Inferential Statistics:
*	Does the customers are okay with the late deliverys?
*	Products having more than 1 photos has more sales than products having only 1 picture.
*	Products having good review score always delivered on time?
*	Sellers near to customers does they deliver always on time?

# Advanced Data Analytics:

   ## Customer Segmentation Model: 
*	create a data-table(Customer_product) using final dataset in S3 which we will prepare in R where each row say about a customer how much he is spending on 	  each product category. This table is gets stored in AWS S3 data lake. By using AWS EC2 instance we will access R and use machine learning library. 
*	In this EC2 instance we access the S3 and extract the Customer_product table and perform feature engineering (Standardization and PCA) and then we apply K-	   Means clustering technique with using Silhouette and SSE we will find out the right number of clusters to decide.
*	As sometime the SSE value may not indicate a clear “Elbow” to choose. So we decide the right number of clusters by having less SSE using elbow and high 	silhouette. 
*	Then we visualize these clusters in Radial chart to find out each cluster is interested on what products. 
*	We append the cluster results and append each row of Customer_Product table with cluster number and interested products. Then store again to AWS S3 data 	 lake.
*	After this we will create another cluster model which will help us to find some patterns. Here we will access AWS S3 data lake from AWS EC2 instance R  	     and use the final data set and change all product category section to one hot encoding variables where each category becomes a column and if that 	         order has that product category it has value 1 or other wise 0. 
*	Then we will we perform the same action on payment type and  state and order status and remove the review creation and review answered timestamp columns 	 from the dataset. 
*	Then we will take review text we will calculate the polarity, No: of positive words and no: of negative words of each review text by using NLTK and text        	blob in Python Library. 
*	Then we perform feature Engineering and Dimensionality Reduction that is Standardization and PCA and perform K-Means clustering  with number of clusters are 	     decide by Silhouette and SSE. Once the clusters are decided we try to visualize the clusters and find the patterns among it.
   ## Deriving the rules from the Clusters:
*	We perform the Apriori algorithm to see the rule mining associations and rule patterns which we will use in our recommendation model. 
*	We will store the cluster results and rules in AWS S3 datalake. 
*	By using the rules we perform visualizations to bring out the insights from it.
  

   ## Product Recommendation Engine:
 *	In the AWS EC2 instance Python, access the final dataset from AWS S3 data lake and calculate polarity, no of positive words and no of negative words and 	 TFIDF frequency matrix with different ngram range(1to 3) from reviews text and horizontal stack all these to the final dataset and perform one hot encoding 	     on categorical variables.
 *	 We pass the obtained data into hybrid recommendation system and content based filtering and check the results and finalize the model which do’s the better. 
 *	Once we get the recommended products we will check that customer falls in which cluster list in Customer_Product table and check whether the recommended 	 products lies in the interest list and then we match with the patterns or rules obtained in 2nd clustering model to find the sellers and by the pattern and 	     rule we can find out whether the customer is willing ok for late delays and even long shipment time or not. According to above analysis we will be    		recommending the products.

   ## Data Visualizations:
*	Preparing a radial chart to represent the relations between clusters from 1st method and product categories.
*	Visualizing the clusters and finding the patterns after the 2nd clustering method.
*	Representing a Geo map of USA and using fill as the total value of orders till now processed from each state.
*	Representing bar plot of how many of each product category has sold.
*	Plotting an Density plot to see how is the distribution of product categories in dataset.

   ## Proposed Data Platforms:

Frameworks: AWS S3, AWS EC2 instance Deep Learning Ubuntu AML
Languages: Python and R
Visualization: Tableau and R
