# Financial-Risk-model-for-corporates
The objective of financial statement analysis is to examine past and current financial data so that a company's performance and financial position can be evaluated and future risks and potential can be estimated. Financial statement analysis can yield valuable information about trends and relationships, the quality of a company's earnings, and the strengths and weaknesses of its financial position. All these information helps the credit professionals to make better decisions in lending.

Financial statement analysis begins with establishing the objectives of the analysis. Here, the analysis undertaken to provide a basis for granting credit or making an investment. After the objective of the analysis is established, the data is accumulated from the financial statements and from other sources.  The results of the analysis are summarized and interpreted. Conclusions are reached and a report is made on the analysis.

The process of analysis deals with analyzing various ratios in determining the risk profile of the companies. Based on the financial ratios the companies are grouped in the following risk profiles.
	  1. Low Risk
    2. Medium Risk
    3. High Risk
    
Financial ratios are used to perform quantitative analysis and assess a company’s liquidity, leverage, growth, margins, profitability, rates of return, valuation and many more. A single ratio is not sufficient to analyze a financial statement. The best way to determine a firm's financial quality is to assess by comparing ratios of peers in various categories:
      •	Profitability ratios
      •	Leverage ratios
      •	Efficiency ratios
      •	Liquidity ratios
Financial ratios of companies from various domains are collected for analysis. Five years historical data from 3/31/2014 to 3/31/2018 were collected for 501 Companies, which has 36 ratios. All these ratios are used to track the performance of the companies and make comparative judgments regarding the performance

DATA CLEANING:
•	Company’s financial ratios for five years from 2014 to 2018 are collected from Bloomberg. The data has missing values.
•	The five years data is averaged to find the average performance of the companies.
•	Data Exploration is performed to treat the missing values to get a better accuracy.
•	Since the data is financial ratio, it has outliers, so the missing values are replaced with median. The loss of data can be negated by replacing the missing data with median value, which yields better results compared to removal of rows and columns.

OUTLIERS:	
•	In the Dataset, since most of the ratios have outliers, the outliers are not removed to prevent the loss of data. 
•	In this scenario, capping of outliers cannot be performed as it may alter the data.
•	Hence, the outliers are used in the analysis of risk profiles.

CLUSTERING:
•	Clustering is performed to decide if the outliers form the risk profiles or if they really affect the data.
•	The K-means Clustering is used to find observations which stand out from other groups.
•	Initially scaling is done on the data to perform k-means clustering.
•	Then, WSS plot and silhouette scores are using to calculate the number of clusters.
•	Here, the number of clusters obtained through the plots is 5.
•	Hence, K-means clustering is performed with the number of clusters as 5.
•	When profiling of clusters is done, it is observed that 2 clusters have just 3 observations.
•	These 3 observations could be outliers and hence they should be removed.

SCALING:
•	Feature Scaling is a data pre-processing step that is applied to the independent variables to standardize the range of values in the data. 
•	After the outliers are removed from the data, scaling is done to standardize the features.

OVERSAMPLING-SMOTE:
•	SMOTE is the synthetic Minority Oversampling Technique that is used to handle the imbalance if data.
•	It works by creating synthetic samples of the minority classes (using a distance measure) rather than creating copies.
•	The data is split into training and testing data. Then SMOTE is applied on the data. This is because if we apply SMOTE on the full data, it is possible that the synthetic samples of the training set may be present in the test data.
•	To avoid this problem, SMOTE is always applied after splitting the data.


