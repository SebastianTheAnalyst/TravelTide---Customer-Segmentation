# TravelTide_Customer-Segmentation
Segmenting Customers in 5 perks using K Means


Introduction

TravelTide is a hot new player in the online travel industry. Our mission is to design and execute a personalized rewards program that keeps customers returning to the TravelTide platform. It is difficult to personalize rewards for customers without first understanding them, so for the project to be successful we need to understand the customer behavior to tailor our marketing straight and meaningful to the customer.
For that reason we conducted a customer segmentation on a given cohort with 5 initial reward program perks for Analysis.

Objectives

The goal is to segment the customers into 5 reward-perks and come up with recommendations for new perks that help on a positive customer experience, through offers, based on the segments they are really interested in. So each customer will be assigned to one segment with the animation in mind to make them sign up for the new reward program.

Methodology

Data Compilation: I used SQL to join the 4 given tables( sessions, user, flights, hotels) to
export 1 big Dataset as CSV file.
Data Cleaning and Outlier Detection: Due to the size of 49200 rows I decided to analyze the Dataset in Python. There I first cleaned the data and checked for Outlier.
Aggregation and Transformation: It took me quite a while to figure out where to aggregate and filter manually the Outlier, so I loaded the Dataset from Python back into SQL in PGAdmin4 to prepare the Dataset to a customer Level or the final segmentation in Python.
Segmentation Strategy: For the segmentation I combined different customer behavior metrics and a spectrum of DataAnalysis Methods and libraries in Python to do a manual segmentation and compared my findings with a K Means Algorithm.
