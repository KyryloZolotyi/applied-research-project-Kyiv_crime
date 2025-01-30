# data-analyst-pet-project_kyiv_crime
This project explores the relationship between crime rates and the deployment of surveillance cameras in Kyiv. By analyzing crime data and camera locations, we identify patterns and formulate hypotheses using statistical and visual analysis techniques.

# Introduction
The main goal of this project is to investigate whether the number of surveillance cameras affects the number of crimes. Additionally, the analysis is performed using various technologies and tools, including Python, SQL, statistical analysis, QGIS, and Tableau.

# Data Sources
Data on the location of video surveillance cameras in Kyiv: https://kyiv-data.com/ - bit.ly/ksv-kyiv ( Dataset ); 
Criminal lawlessness statistics, data from the Attorney General's Office: https://erdr-map.gp.gov.ua/csp/map/index.html#/map ;
Data about districts of Kyiv: https://kyivcity.gov.ua/kyiv_ta_miska_vlada/pro_kyiv/raiony_kyieva/

# ETL Pipeline
<img width="753" alt="Screenshot 2025-01-30 at 11 22 31" src="https://github.com/user-attachments/assets/bed12520-9f3f-4188-8830-1b015a512231" />

# Technologies and tools:
- Python - NumPy, Pandas , Matplotlib.pyplot, seaborn, scipy.stats;
- MySQL ( DBeaver);
- QGIS;
- Tableau;

# Main Stages of the project:
The first stage involves collecting, processing, and preparing data for further analysis.

- We utilize open data on the locations of CCTV cameras and official crime statistics in Kyiv, sourced from the Attorney General's Office. The CCTV data undergoes preprocessing using Pandas and NumPy, including removing duplicates, handling missing values, and reformatting the data where necessary. Finally, we load this data into SQL for further analysis.

The next step is to investigate the relationship between crime and video surveillance, using statistical methods.

- At this stage, we conduct a descriptive analysis of the dataset to understand key patterns and distributions. We calculate important metrics such as Crime Density and Camera Density, which will later be used in correlation analysis. Additionally, we compute the Crime Rate Deviation relative to the mean to assess variations in crime levels across different areas.

- Using Python libraries such as NumPy, Pandas, Matplotlib.pyplot, Seaborn, and Scipy.stats, we perform correlation analysis by calculating Pearson and Spearman correlation coefficients to evaluate the relationship between surveillance cameras and crime rates. To ensure the statistical validity of our findings, we conduct a p-value significance test to determine whether the observed correlations are statistically significant.

Final Stage: Visualization of Results

- In the final stage, we focus on effectively visualizing our findings to communicate insights clearly. Using Tableau, we create scatter plots, heatmaps to illustrate the relationships between crime rates and surveillance camera deployment.

- Additionally, we use QGIS to generate a spatial visualization of crime density and camera distribution across Kyiv, allowing for a geographical perspective on the data. These visualizations help in identifying trends, patterns, and potential areas of interest for further investigation.

# Data Model
![pet_project1](https://github.com/user-attachments/assets/e5164918-3620-4c08-b7f3-fe9fd11a09c7)


# Conclusion
