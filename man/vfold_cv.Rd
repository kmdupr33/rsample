% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vfold.R
\name{vfold_cv}
\alias{vfold_cv}
\title{V-Fold Cross-Validation}
\usage{
vfold_cv(data, v = 10, repeats = 1, strata = NULL, breaks = 4, ...)
}
\arguments{
\item{data}{A data frame.}

\item{v}{The number of partitions of the data set.}

\item{repeats}{The number of times to repeat the V-fold partitioning.}

\item{strata}{A variable that is used to conduct stratified sampling to
create the folds. This could be a single character value or a variable name
that corresponds to a variable that exists in the data frame.}

\item{breaks}{A single number giving the number of bins desired to stratify
a numeric stratification variable.}

\item{...}{Not currently used.}
}
\value{
A tibble with classes \code{vfold_cv}, \code{rset}, \code{tbl_df}, \code{tbl}, and
\code{data.frame}. The results include a column for the data split objects and
one or more identification variables. For a single repeats, there will be
one column called \code{id} that has a character string with the fold identifier.
For repeats, \code{id} is the repeat number and an additional column called \code{id2}
that contains the fold information (within repeat).
}
\description{
V-fold cross-validation randomly splits the data into V groups of roughly
equal size (called "folds"). A resample of the analysis data consisted of
V-1 of the folds while the assessment set contains the final fold. In basic
V-fold cross-validation (i.e. no repeats), the number of resamples is equal
to V.
}
\details{
The \code{strata} argument causes the random sampling to be conducted \emph{within
the stratification variable}. This can help ensure that the number of data
points in the analysis data is equivalent to the proportions in the original
data set. (Strata below 10\% of the total are pooled together.)
When more than one repeat is requested, the basic V-fold cross-validation
is conducted each time. For example, if three repeats are used with \code{v = 10}, there are a total of 30 splits which as three groups of 10 that are
generated separately.
}
\examples{
vfold_cv(mtcars, v = 10)
vfold_cv(mtcars, v = 10, repeats = 2)

library(purrr)
data(wa_churn, package = "modeldata")

set.seed(13)
folds1 <- vfold_cv(wa_churn, v = 5)
map_dbl(folds1$splits,
        function(x) {
          dat <- as.data.frame(x)$churn
          mean(dat == "Yes")
        })

set.seed(13)
folds2 <- vfold_cv(wa_churn, strata = "churn", v = 5)
map_dbl(folds2$splits,
        function(x) {
          dat <- as.data.frame(x)$churn
          mean(dat == "Yes")
        })

set.seed(13)
folds3 <- vfold_cv(wa_churn, strata = "tenure", breaks = 6, v = 5)
map_dbl(folds3$splits,
        function(x) {
          dat <- as.data.frame(x)$churn
          mean(dat == "Yes")
        })
}
