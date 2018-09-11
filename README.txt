This is a work by Fengzhencheng Zeng
For COSI 166B HW4.3

  This program is used to analyze the movie review dataset for the popularity of
movies, similarity between two specified users and list movies and users in an
ascending order of the calculated popularity and similarity.

  The initialization of this program include reading data into row objects,
based on which movie and user objects are also created and stored in two separa-
ted lists and some review info is also read into each movie and user object.
(See comments in .rb files for detail) The time complexity of this method should
 be O(n) where n is the number of total reviews.

  The popularity function calculates and return the popularity of a specified
movie, which is calculated as below:
  sum(ratings of the movie)/num of reviews about the movie
  The time complexity of this method is O(1) since it just extract an object
from hash and do a single step arithmetic calculation

  The popularity_list sort and return the movies list kept by the MovieData ins-
tance by calculated popularity of a movie.
  The time complexity depends on the implementation of the sort method of hash
which should be O(mlogm) where m is the number of movies

  The similarity function returns the result of the similar method of a user
instance, which returns the similarity between a specified user and the user
represented by the instance. The similarity is calculated as below:
  1-for(commonly reviewed movies).average(abs(user.rating-input_user.rating)/5)
  The time complexity of this method should be O(m) where m is the number of
 commonly reviewed movies

  The similarity list function create, sort and returns a list of all other
users in an ascending order of the similarity between those users and the speci-
fied user. The result is cached in the object of the specified user.
  The time complexity of this method also depends on sort algorithm and also the
 number of users. Should be like O(rlogr+r*m) where r is the number of users and
 m is the is the number of commonly reviewed movies.

  I think the limiting factor for space complexity is the similarity lists
cached in the user objects, which would be O(r^2) where r is the number of
users. That is a trade of between time and space and would be useful when the
similarity lists are requested frequently. And that cache would only be useful
if the data is static. If more data are inserted into the dataset dynamically,
it would become too complicated to modify the cache.

  As for the rating prediction, I'm considering a simple linear regression meth-
od which regress the rating of a movie on the similarity between the users who
gave those ratings and the specified user. Since it's just an SLR, the calcula-
tion won't be difficult.
