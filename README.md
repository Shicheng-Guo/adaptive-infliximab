# adaptive-infliximab
R code used to perform simulations as outlined in *"Infliximab maintenance dosing in inflammatory bowel disease: an example for in silico assessment of adaptive dosing strategies"*

## To Run:
**If you cloned the repository:**
1. Open *run.R* in text editor
2. Line 8: update `user.dir` to the **adaptive-infliximab** GitHub repository location
3. Run all contents of the *run.R* script in R

**If you download the .zip folder**
1. Open *run.R* in text editor
2. Line 8: update `user.dir` to the **adaptive-infliximab** GitHub repository location
3. Line 17: update `work.dir` to have *"adaptive-infliximab-master/"* instead of *"adaptive-infliximab/"*
4. Run all contents of the *run.R* script in R

### Required R Libraries:
mrgsolve (0.7.6), dplyr (0.5.0), plyr (1.8.4), ggplot2 (2.1.0)

## Simulation Options:
`n` = number of unique seed individuals to be simulated.  The *in silico* study used 9, and the population is currently only set up for 9. It is not recommend that this value be changed

`nsim` = number of simulations to be performed on *n* unique seed individuals.  Currently, set to 1 - but was set to 10 during the *in silico* study

`ntry` = number of attempts to run *nsim* simulations on *n* unique seed individuals.  Currently, set to 1 - but was set to 12 during the *in silico* study
- For 100 simulations, perform 10 attempts of 10 simulations
- 12 attempts were performed during the study to account for if one or two of the attempts had numerical errors (due to the differential equation solver), resulting in no output
- 1000 simulations during the *in silico* study were performed by running 120 attempts of 10 simulations over 10 R consoles (i.e., 12 per R console)
	- The first 100 successful attempts were used in the final population for analysis
	- There were issues in compiling mrgsolve's model code in parallel on the institution's server

## Output:
Only simulation data will be created and saved as *.csv* files
- *run.R* will create an *output* folder
- Within *output,* an "attempt" specific folder will be created
	- Named based on `n`, `nsim` and its random seed
- List of data files created:
	- Non-time dependent changes in random and covariate effects (`time.dep == 0`)
		- time_dep_0_label.csv
		- time_dep_0_model_based.csv
		- time_dep_0_population_characteristics.csv
		- time_dep_0_proportional.csv
		- time_dep_0_stepwise.csv
	- Time dependent changes in random and covariate effects (`time.dep == 1`)
		- time_dep_1_label.csv
		- time_dep_1_model_based.csv
		- time_dep_1_population_characteristics.csv
		- time_dep_1_proportional.csv
		- time_dep_1_stepwise.csv

No graphical or statistical output will be created
