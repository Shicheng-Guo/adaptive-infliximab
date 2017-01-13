# in silico infliximab maintenance adaptive dosing project
# Script for simulating concentrations for the induction phase
# Everyone will receive 5 mg/kg doses for the induction phase in all protocols
# ------------------------------------------------------------------------------
# Create a data frame ready for mrgsolve simulation
# Function for creating a data frame ready for mrgsolve simulation
	induction.function <- function(pop.data) {
	# Create input data frame ready for mrgsolve for simulation the induction phase
		input.induction.data <- data.frame(
			ID = pop.data$ID[1],	# Individual ID
			time = TIME,	# Time points for simulation
			BASE_WT = pop.data$BASE_WT[1],	# Baseline weight
			BASE_ALB = pop.data$BASE_ALB[1],	# Baseline albumin
			TIME_WT = pop.data$BASE_WT[1],	# Default weight at TIME
			TIME_ADA = 0,	# Default ADA status at TIME
			TIME_ALB = pop.data$BASE_ALB[1],	# Default albumin at TIME
			ADAr = pop.data$ADAr[1],
			ETA1 = pop.data$ETA1,	# Random effect for CL
			ETA2 = pop.data$ETA2,	# Random effect for V1
			ETA3 = pop.data$ETA3,	# Random effect for Q
			ETA4 = pop.data$ETA4,	# Random effect for V2
			ERRPRO = pop.data$ERRPRO,	# Residual error
			amt = amt.init1*pop.data$BASE_WT[1],	# mg/kg dose
			evid = 1,	# Dosing event
			cmt = 1,	# Dose into the central compartment (compartment = 1)
			rate = -2	# Infusion duration is specified in the model file
		)
	# Make the amt in times that aren't infusion times == 0
		input.induction.data$amt[!c(input.induction.data$time %in% TIME1i)] <- 0
	# Specify the correct evid and rate for non-infusion times
		input.induction.data$evid[!c(input.induction.data$time %in% TIME1i)] <- 0
		input.induction.data$rate[!c(input.induction.data$time %in% TIME1i)] <- 0
	# Flag if we want covariates to change depending on concentrations during simulation
		input.induction.data$FLAG <- time.dep
	# Simulate concentration-time profiles for individuals in input.conc.data
		induction.data <- mod %>% mrgsim(data = input.induction.data,carry.out = c("amt","ERRPRO")) %>% as.tbl
	}
# Simulate the induction phase from "pop.data" using "induction.function" for each ID (individual) in each SIM (simulation group)
	induction.data <- ddply(pop.data, .(ID,SIM), induction.function)
