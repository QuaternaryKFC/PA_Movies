# PA_Movies

This is a work by **Fengzhencheng Zeng**  
For COSI 166B HW6.3

In this work, Logistic Regression was mainly used to predict the rating a user could give to a specified movie. The regression use similarity estimated in last assignment (which is based on the absolute difference between the ratings given to a movie by two users. The larger the difference, the smaller the similarity) as independent variable and the rating given by the other user as the dependent variable. To predict the rating could be given to a movie by a user, just do the regression for that user and return the estimated rating when the similarity is exactly 1. This algorithm is pretty easy to understand and the calculations are also very trivial. And the results given by this algorithm are acceptable.

However, this algorithm have several drawbacks. First is that if the movie to be predicted with is not included in the base file, then the regression can't be made since there are no data can be used to regress. To fix it, I just use a 4 as the prediction in this situation. The second is that if the movie is only reviewed by one user, the regression cannot be made neither. In this situation, the algorithm will give a estimate based on the similarity of the user who reviewed the movie and the user to be predicted (see mp_predict.rb for detail). And besides the special cases, the algorithm is not statically "right" since the regressions are made on different samples, which violates a basic assumption for such statistical calculation.

As shown by the results below, this prediction algorithm gives "exact" prediction for about 65% of the test cases, and the mean difference is between 0.4 and 0.5 which means this algorithm tends to give higher estimation, and the standard deviation of the difference is about 1.3 which is a bit higher than the algorithm which always return a same rating (in which case the standard deviation is 1).

The prediction and validation for each batch takes about 1 minute. If we assume the average number of reviews for each movie is m and the total number of movies is n, then the time cost of this algorithm is O(mn) since the time cost of regression calculation depends on the number of reviews given to a movie. In this version of algorithm, the similarity calculation has not optimized so it will take longer than the optimal one.

I would say I really learned a lot from composing this program and enjoyed coding with ruby very much. I also tried to build a neural network algorithm for this task but haven't got it yet. I may return to this in the future when I have time.

## Prediction Output

* **Batch 1**  
total:20000  
exact: 12707  
mean: 0.4630494179652825  
stdev: 1.2857241081604105  

* **Batch 2**  
total:20000  
exact: 12512  
mean: 0.475296330400593  
stdev: 1.3000553739486524  

* **Batch 3**  
total:20000  
exact: 12362  
mean: 0.43258693747119553  
stdev: 1.3154648280535655  

* **Batch 4**  
total:20000  
exact: 12443  
mean: 0.4527337497177216  
stdev: 1.2976087807190384  

* **Batch 5**  
total:20000  
exact: 12586  
mean: 0.4732988937382388  
stdev: 1.2754350688927583  
