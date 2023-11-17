# Secretary problem
Exploring the classic Secretary problem which covers the probability and decision fields regarding the optimal stopping theory. 

## What is the Secretary Problem?
Briefiely explained the Secretary problem serves to develop a strategy for a recruiter to select a good secretary. The literature has reached the solution withbthe optimal stratgy and it is to explore, interview but not hire in any case, 37% of the candidates and after that hire however exceeds the best candidate found in the exploratory phase.

In this project it is explored the optimal strategy as it has been tested to perform the best; a modification to this approach in which we choose the 95% percentile or above of that maximun value observed in the exploratory phase; a fixed threshold of the quantile 95% of the entire dataset (assuming we know the distribution of our data) so there is no need of an exploratory phase and lastly, a dynamic or moving threshold where we lower our requirements to hire the person acording to how many interviews we have conducted. 
The result show that the best probability of hiring the singles bets candidate comes from the optimal strategy, although as far as best average candidate, lowest time until decision and less difference to the best candidate the fixed threshold perform great. However, since the assumption is not too realistic the optimal strategy apporoach with a 10% exploring size give good results too and it is realistic in real-world scenarios.

Thanks for reading :)
