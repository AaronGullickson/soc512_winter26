# toy example of missing data nested in counties

library(mice)
library(dplyr)

set.seed(123)

# 20 counties
J <- 20

# 100 births per county
n_j <- 100

dat <- expand.grid(
  county = 1:J,
  id = 1:n_j
) |> as_tibble()

# county random effects
u <- rnorm(J, 0, 2)

dat <- dat |>
  mutate(
    mother_edu = rnorm(n(), 12, 2),
    father_edu =
      10 + 0.6 * mother_edu + u[county] + rnorm(n(), 0, 1)
  )

dat$father_edu[
  sample(1:nrow(dat), 0.3 * nrow(dat))
] <- NA

pred <- make.predictorMatrix(dat)
# -2 defines grouping structure
#pred["father_edu", "county"] <- -2


meth <- make.method(dat)
meth["father_edu"] <- "pmm"

# cluster id has to be a numeric value
dat$county <- as.integer(dat$county)


imp <- mice(
  dat,
  method = meth,
  predictorMatrix = pred,
  m = 5
)
