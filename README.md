# Secretary problem
Exploring the classic Secretary problem, which covers the probability and decision-making fields regarding the optimal stopping theory. 

## What is the Secretary Problem?
Briefly  explained the Secretary problem serves to develop a strategy for a recruiter to hire th best secretary with a set of rules and assumptions. The literature has solved this using the optimal strategy. It consists on exploring, interview but not hire in any case, 37% of the candidates and after that hire however exceeds the best candidate found in the exploratory phase and if the recruiter cannot find this person he/she has to hire the last candidate.

This project changes the focus to hiring someone "good enough" and not necessarily the best candidate in order to make it more applicable in real-world scenarios. The stretagies tested are: the **optimal strategy** as it has been proved to perform the best for finding the best candidate; a **modified optimal strategy** where we choose the 95% percentile or above of that maximum value observed in the exploratory phase; a **fixed threshold** of the quantile 95% of the entire dataset (assuming we have certain knowledge of out data), so there is no need of an exploratory phase and lastly, a moving or **dynamic threshold** where we lower our requirements to hire the person according to how many interviews we have conducted. Also, it can be found the concept of the **optimal strategy with different exploration sizes** to evaluate and compare.

The result shows that the highest probability of hiring the single best candidate comes from the optimal strategy as it has been already discussed previously by much more knowledgeable people. As far as for the best "good enough" candidate, the lowest time until hiring  and the smallest respective difference to the best candidate it is the fixed threshold the one who performs best. However, since the assumption is not too realistic the optimal strategy approach with a 10% exploring size gives good results too and it is usable in real-world scenarios.

Thanks for reading :)
