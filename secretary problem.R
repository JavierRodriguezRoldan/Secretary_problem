## SECRETARY PROBLEM

set.seed(123456)

#### optimal strategy classic----

n <- 100
e <- exp(1)
num_simulations <- 10000

results_optimal <- numeric(num_simulations)
interviewed_candidates_optimal <- numeric(num_simulations)  

# simulate experience using normal distribution
candidate_experience_sim <- pmax(pmin(round(rnorm(n, mean = 50, sd = 10)), 99), 1)
hist(candidate_experience_sim)
table(candidate_experience_sim)

#matrix with the shuffled indices so it is comparable across strategies
shuffled_indices <- replicate(num_simulations, sample(1:100, n, replace = FALSE))
shuffled_indices[,1]

for (sim in 1:num_simulations) {
  
  # Shuffle the candidates
  indices <- shuffled_indices[, sim]
  candidate_experience_sim <- candidate_experience_sim[shuffled_indices[indices, sim]]
  
  # highest experience score from the explored candidates
  best_from_exploring <- max(candidate_experience_sim[1:floor((n/e))]) # above 63 
  
  next_candidates <- candidate_experience_sim[(floor((n/e)) + 1):n]
  
  # Check if any candidate has higher experience than the best from exploring
  selected_candidate <- 0
  interviewed <- 0  # Counter for interviewed candidates
  
  for (i in 1:length(next_candidates)) {
    interviewed <- interviewed + 1
    if (next_candidates[i] > best_from_exploring) {
      selected_candidate <- next_candidates[i]
      break  
    } else {
      selected_candidate <- next_candidates[length(next_candidates)]
    }
  }
  
  # Store results and the number of interviewed candidates for each simulation
  results_optimal[sim] <- selected_candidate
  interviewed_candidates_optimal[sim] <- interviewed
}

mean(results_optimal)  # Average of selected candidates' experience
mean(interviewed_candidates_optimal)+floor(n/e)  #73.56 interviews until making the decision
hist(interviewed_candidates_optimal)

summary(candidate_experience_sim) #75 best candidate and we choose 64.73 on average
#73.56 interviews until making the decision


######################################################################

# comparing different exploration sizes-----

exploration_size <- c(40,37,30,25,20,15,10,5)

results_optimal <- matrix(nrow=num_simulations,ncol=length(exploration_size))
interviewed_candidates_optimal <- matrix(nrow=num_simulations,ncol=length(exploration_size))  

for (size_index in 1:length(exploration_size)) {
  size <- exploration_size[size_index]
  
  for (sim in 1:num_simulations) {
    
    # Shuffle the candidates
    indices <- shuffled_indices[, sim]
    candidate_experience_sim <- candidate_experience_sim[shuffled_indices[indices, sim]]
    
    # highest experience score from the explored candidates
    best_from_exploring <- max(candidate_experience_sim[1:size])
    
    next_candidates <- candidate_experience_sim[(size + 1):n]
    
    # Check if any candidate has higher experience than the best from exploring
    selected_candidate <- NULL
    interviewed <- 0  # Counter for interviewed candidates
    
    for (i in 1:length(next_candidates)) {
      interviewed <- interviewed + 1
      if (next_candidates[i] > best_from_exploring) {
        selected_candidate <- next_candidates[i]
        break  
      } else {
        selected_candidate <- next_candidates[length(next_candidates)]
      }
    }
    # Store results and the number of interviewed candidates for each simulation
    results_optimal[sim, size_index] <- selected_candidate
    interviewed_candidates_optimal[sim, size_index] <- interviewed 
  }
}

#comparing experience
colnames(results_optimal) <- exploration_size
results_optimal 
results_optimal_means <-colMeans(results_optimal)
results_optimal_means

experience_df <- data.frame(Exploration_size = as.numeric(names(results_optimal_means)),
                            Experience = as.numeric(results_optimal_means))

library(ggplot2)
ggplot(data = experience_df, aes(x = Exploration_size, y = Experience)) +
  geom_line() +  geom_point() + scale_x_reverse() + 
  labs(x = "Exploration Size", y = "Experience", 
       title = "Optimal strategy experience by Exploration Size")

#comparing time until decision

for (i in 1:ncol(interviewed_candidates_optimal)) {
  interviewed_candidates_optimal[, i] <- interviewed_candidates_optimal[, i] + exploration_size[i]
}

colnames(interviewed_candidates_optimal) <- exploration_size
interviewed_candidates_optimal 
interviewed_candidates_optimal_means <- colMeans(interviewed_candidates_optimal)
interviewed_candidates_optimal_means

interviewed_df <- data.frame(Exploration_size = as.numeric(names(interviewed_candidates_optimal_means)),
                             Interviewed = as.numeric(interviewed_candidates_optimal_means))

ggplot(data = interviewed_df, aes(x = Exploration_size, y = Interviewed)) +
  geom_line() +  geom_point() + scale_x_reverse() + 
  labs(x = "Exploration Size", y = "Interviewed people until decision", 
       title = "Optimal strategy Interviewed candidates by Exploration Size")



## Comparing the percentage success in hiring the best

# Find the best candidate in each simulation
best_candidate <- max(candidate_experience_sim)

# Create a matrix to store the success of each strategy
success_optimal <- matrix(nrow=num_simulations,ncol=length(exploration_size))

# Loop over each strategy and each simulation
for (size_index in 1:length(exploration_size)) {
  for (sim in 1:num_simulations) {
    # Check if the selected candidate is the best candidate
    if (results_optimal[sim, size_index] == best_candidate) {
      # If yes, mark it as a success
      success_optimal[sim, size_index] <- 1
    } else {
      # If no, mark it as a failure
      success_optimal[sim, size_index] <- 0
    }
  }
}

# Calculate the percentage of success for each strategy
success_optimal_percentage <- colMeans(success_optimal) * 100

# Create a table to display the results
success_optimal_table <- data.frame(exploration_size, success_optimal_percentage)
success_optimal_table



###################################################################

#threshold strategy----
#interviewing until coming across with a top 95 or above

quantile(candidate_experience_sim)
threshold <- quantile(candidate_experience_sim, 0.95)
threshold #65.05 threshold
sum(candidate_experience_sim>threshold)#5 people that meet the threshold

results_threshold <- numeric(num_simulations)
interviewed_candidates_threshold <- numeric(num_simulations)  # Track number of interviewed candidates

for (sim in 1:num_simulations) {

  # Shuffle the candidates
  indices <- shuffled_indices[, sim]
  candidate_experience_sim <- candidate_experience_sim[shuffled_indices[indices, sim]]
  
  # Check if any candidate has higher experience than the best from exploring
  selected_candidate <- NULL
  interviewed <- 0  
  
  for (i in 1:length(candidate_experience_sim)) {
    interviewed <- interviewed + 1
    if (candidate_experience_sim[i] >= threshold) {
      selected_candidate <- candidate_experience_sim[i]
      break  
    } else {
      selected_candidate <- candidate_experience_sim[length(candidate_experience_sim)]
    }
  }
  
  # Store results and the number of interviewed candidates for each simulation
  results_threshold[sim] <- selected_candidate
  interviewed_candidates_threshold[sim] <- interviewed
}

mean(results_threshold) 
summary(results_threshold) #75 best candidate and we choose 69.40 on average
#better than the optimal strategy by almost 5%

mean(interviewed_candidates_threshold)  #16.78 interviews until making the decision
hist(interviewed_candidates_threshold)
#around 57 fewer candidates to interview until making a decision


## Threshold strategy's probability of hiring the best candidate

# Find the best candidate in each simulation
best_candidate <- max(candidate_experience_sim)

# Create a vector to store the success of the strategy
success_threshold <- numeric(num_simulations)

# Loop over each simulation
for (sim in 1:num_simulations) {
  # Check if the selected candidate is the best candidate
  if (results_threshold[sim] == best_candidate) {
    # If yes, mark it as a success
    success_threshold[sim] <- 1
  } else {
    # If no, mark it as a failure
    success_threshold[sim] <- 0
  }
}

# Calculate the percentage of success for the strategy
success_threshold_percentage <- mean(success_threshold) * 100

# Print the result
print(paste0("The threshold strategy was able to hire the best candidate ", success_threshold_percentage, "% of the time."))



##############################################################

# Wonder´s idea - optimal strategy but instead of MAX of exploring set a threshold after exploring
      
results_optimal <- numeric(num_simulations)
interviewed_candidates_optimal <- numeric(num_simulations)  

for (sim in 1:num_simulations) {
  
  # Shuffle the candidates
  indices <- shuffled_indices[, sim]
  candidate_experience_sim <- candidate_experience_sim[shuffled_indices[indices, sim]]
  
  #instead of MAX from exploring lets do top 90% or above from exploring
  # highest experience score from the explored candidates
  choosen_from_exploring <- quantile(candidate_experience_sim[1:floor((n/e))], 0.8) #58 or above
  
  next_candidates <- candidate_experience_sim[(floor((n/e)) + 1):n]
  
  # Check if any candidate has higher experience than the best from exploring
  selected_candidate <- 0
  interviewed <- 0  # Counter for interviewed candidates
  
  for (i in 1:length(next_candidates)) {
    interviewed <- interviewed + 1
    if (next_candidates[i] >= choosen_from_exploring) {
      selected_candidate <- next_candidates[i]
      break  
    } else {
      selected_candidate <- next_candidates[length(next_candidates)]
    }
  }
  
  # Store results and the number of interviewed candidates for each simulation
  results_optimal[sim] <- selected_candidate
  interviewed_candidates_optimal[sim] <- interviewed
}

mean(results_optimal)  # Average of selected candidates' experience
mean(interviewed_candidates_optimal)+floor(n/e)  #73.56 interviews until making the decision
hist(interviewed_candidates_optimal)

summary(candidate_experience_sim) #75 best candidate and we choose 63.52 on average
#40.77 interviews until making the decision


## What is the probability of selecting the best candidate using Wonder's strategy?

# Find the best candidate in each simulation
best_candidate <- max(candidate_experience_sim)

# Create a vector to store the success of the strategy
success_wonder <- numeric(num_simulations)

# Loop over each simulation
for (sim in 1:num_simulations) {
  # Check if the selected candidate is the best candidate
  if (results_optimal[sim] == best_candidate) {
    # If yes, mark it as a success
    success_wonder[sim] <- 1
  } else {
    # If no, mark it as a failure
    success_wonder[sim] <- 0
  }
}

# Calculate the percentage of success for the strategy
success_wonder_percentage <- mean(success_wonder) * 100

# Print the result
print(paste0("The wonder's idea strategy hired the best candidate ", success_wonder_percentage, "% of the time."))


##############################################3

# moving threshold. e.g. after interviewing 25 instead of 99 quantile you use 95%...

threshold_1 <- quantile(candidate_experience_sim, 0.99) #73.02
threshold_2 <- quantile(candidate_experience_sim, 0.85) #61
threshold_3 <- quantile(candidate_experience_sim, 0.7) #56
threshold_4 <- quantile(candidate_experience_sim, 0.5) #50

results_moving_threshold <- numeric(num_simulations)
interviewed_candidates_threshold <- numeric(num_simulations)  # Track number of interviewed candidates

for (sim in 1:num_simulations) {
  
  # Shuffle the candidates
  indices <- shuffled_indices[, sim]
  candidate_experience_sim <- candidate_experience_sim[shuffled_indices[indices, sim]]
  
  # Check if any candidate has higher experience than the best from exploring
  selected_candidate <- NULL
  interviewed <- 0  
  
  for (i in 1:length(candidate_experience_sim)) {
    interviewed <- interviewed + 1
    
    #if in the first 25 interviews you get top 1% or above choose that one, next 25 top 15% and so on
    if (interviewed <= 25 && candidate_experience_sim[i] >= threshold_1) {
      selected_candidate <- candidate_experience_sim[i]
      break
    } else if (interviewed > 25 && interviewed <= 50 && candidate_experience_sim[i] >= threshold_2) {
      selected_candidate <- candidate_experience_sim[i]
      break
    } else if (interviewed > 50 && interviewed <= 75 && candidate_experience_sim[i] >= threshold_3) {
      selected_candidate <- candidate_experience_sim[i]
      break
    } else if (interviewed > 75 && interviewed <= 100 && candidate_experience_sim[i] >= threshold_4) {
      selected_candidate <- candidate_experience_sim[i]
      break
    } else {
      selected_candidate <- candidate_experience_sim[length(candidate_experience_sim)]
    }
  }
  
  # Store results and the number of interviewed candidates for each simulation
  results_moving_threshold[sim] <- selected_candidate
  interviewed_candidates_threshold[sim] <- interviewed
}

mean(results_moving_threshold) 
summary(results_moving_threshold) #75 best candidate and we choose 67.57 on average

mean(interviewed_candidates_threshold)  #26.40 interviews until making the decision
hist(interviewed_candidates_threshold)


## What were our chances of hiring the best candidate using the moving threshold?

# Find the best candidate in each simulation
best_candidate <- max(candidate_experience_sim)

# Create a vector to store the success of the strategy
success_moving_threshold <- numeric(num_simulations)

# Loop over each simulation
for (sim in 1:num_simulations) {
  # Check if the selected candidate is the best candidate
  if (results_moving_threshold[sim] == best_candidate) {
    # If yes, mark it as a success
    success_moving_threshold[sim] <- 1
  } else {
    # If no, mark it as a failure
    success_moving_threshold[sim] <- 0
  }
}

# Calculate the percentage of success for the strategy
success_moving_threshold_percentage <- mean(success_moving_threshold) * 100

# Print the result
print(paste0("The moving threshold strategy found the best candidate ", success_moving_threshold_percentage, "% of the time."))



## Conclusions ##
#                              experience     days until decision

# optimal strategy                64.73             73.56
# optimal with different sizes:    
    #40%                          63.93             77.22
    #37%                          64.42             74.39
    #30%                          65.69             67.12
    #25%                          66.72             60.13
    #20%                          67.08             52.77
    #15%                          67.33             44.58
    #10%                          67.09             34.00
    #5%                           65.54             21.09

# threshold (>=95%)               69.40             16.78   #BEST
# moving threshold                67.57             26.40