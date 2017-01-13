# in silico infliximab maintenance adaptive dosing project
# Script for setting the working directory and executing other R scripts
# ------------------------------------------------------------------------------
# Remove all current objects in the workspace
	rm(list = ls(all = TRUE))

# User directory (where github repository was saved)
	user.dir <- "/Volumes/Prosecutor/PhD/InfliximabBayes/"

# Simulation options
	n <- 9	# Number of seed individuals (where each seed individual has a different set of covariate values)
	nsim <- 1	# Number of simulations of the seed individuals to perform
	ntry <- 1	# Number of times to perform a group of "nsim" simulations

# ------------------------------------------------------------------------------
# Working directory (where R scripts are saved, i.e., point to github respository)
	work.dir <- paste0(user.dir,"adaptive-infliximab/")
# Output directory (where output data such as .csv files will be saved)
	output.dir <- paste0(work.dir,"output/")
	dir.create(file.path(output.dir),showWarnings = FALSE) # Create output directory
# Source and compile model file
	source(paste0(work.dir,"mrgsolve_model.R"))

# ------------------------------------------------------------------------------
# Run "ntry" groups of "nsim" simulations with both time-dependent and non-time-dependent random and covariate effect changes
	for (i in 1:ntry) {
	# Source universal functions file
		source(paste0(work.dir,"functions.R"))
	# Create population
		source(paste0(work.dir,"create_population.R"))
	# Run simulations
		try(
			for (i in 0:1) {
				time.dep <- i	# 0 = no time-dependent covariate and random effect changes
				# 1 = time-dependent covariate and random effect changes
				# Calculate ETA values for all time-points (based on time-dependence scenario)
					pop.data <- ddply(pop.data, .(SIM,ID), eta.function)
					# Write pop.data to a .csv file
						pop.data.filename <- paste0("time_dep_",time.dep,"_population_characteristics.csv")
						write.csv(pop.data,file = pop.data.filename,na = ".",quote = F,row.names = F)
				# Read in the previous pop.data
					prev.pop.data.name <- paste0("time_dep_",time.dep,"_population_characteristics.csv")
					pop.data <- read.csv(file = prev.pop.data.name)
				# Induction phase simulation (initial dose is 5 mg/kg)
				# Common to all maintenance phase dosing strategies
					suppressWarnings(	# Suppress warning messages
						source(paste0(work.dir,"induction.R"))
					)
				# Run "single-run" simulation files
				# Label dosing
					suppressWarnings(source(paste0(work.dir,"maintenance_label.R")))
				# Therapeutic drug monitoring with stepwise dosing
					suppressWarnings(source(paste0(work.dir,"maintenance_TDM_stepwise.R")))
				# Therapeutic drug monitoring with proportional dosing
					suppressWarnings(source(paste0(work.dir,"maintenance_TDM_proportional.R")))
				# Therapeutic drug monitoring with model-based dosing (Bayes)
					suppressWarnings(source(paste0(work.dir,"maintenance_TDM_model_based.R")))
			}
		)
	}
