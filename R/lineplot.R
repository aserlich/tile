#' Summarize inferences using lineplots
#' 
#' Initializes a line graphic aimed at summarizing inferences from regression
#' models.  This plot may: include confidence intervals, perhaps created from
#' simulations; be clipped to the convex hull to avoid unwarranted
#' extrapolation; and include simple linear or robust fits to the data.  If you
#' simply want to draw a line on a \pkg{tile} plot, use \code{\link{linesTile}}
#' instead.
#' 
#' This function does no plotting; instead, it creates a \code{lineplot}
#' object, or \dfn{trace} of plotting data, to be drawn on one or more plots in
#' a tiled arrangement of plots.  To complete the drawing include the
#' \code{lineplot} object as an input to \code{\link{tile}}, from which users
#' can set further options including plot and axis titles, axis scaling and
#' titles.
#' 
#' \code{lineplot} offers many data processing and formatting options for the
#' trace to be plotted.  Confidence intervals (shown as shaded regions or
#' dashed lines) can be calculated from simulations or posterior draws, or may
#' be provided by the user.  Alternatively, \code{lineplot} can add simple fit
#' lines and confidence intervals to the plotted data (e.g., a linear, robust,
#' or loess fit).  Optionally, results outside the convex hull of the original
#' data can be hidden or flagged.  Finally, the graphical parameters for each
#' element of the lineplot (including lines, shaded or dashed confidence
#' intervals, and symbols or text marking points on the line) can be adjusted,
#' often on a point-by-point basis.
#' 
#' Run through \code{tile}, output from \code{lineplot} will yield a finished
#' plot.  The plot cannot be easily modified after creation.  Rather, users
#' should include in the initial call to \code{tile} additional traces for all
#' desired annotations (text, symbols, lines, or polygons) to the finished
#' plot.
#' 
#' @param \dots Any number of arguments given below.  Must include exactly one
#' horizontal dimension (\var{x} or \var{top}) and exactly one vertical
#' dimension (\var{y} or \var{right}).  All inputs should be identified by
#' appropriate tags; i.e., use \code{lineplot(x=myxvar, y=myyvar)}, \emph{not}
#' \code{lineplot(myxvar,myyvar)}
#' @return A \code{lineplot} object, used only as an input to
#' \code{\link{tile}}.
#' @section Lineplot-specific parameters:
#' 
#' A call to \code{lineplot} \strong{must} provide an orthogonal pair of the
#' following inputs:
#' 
#' \describe{ \item{list("x")}{coordinate vector of data to plot, attached to
#' the \var{x} axis.  \code{x} may be plotted directly, or treated as
#' simulation data to summarize (see parameter \code{simulates} below).}
#' \item{list("y")}{coordinate vector of data to plot, attached to the \var{y}
#' axis; may be simulation data.} \item{list("top")}{coordinate vector of data
#' to plot, attached to the \var{top} axis; may be simulation data.}
#' \item{list("right")}{coordinate vector of data to plot, attached to the
#' \var{right} axis; may be simulation data.} }
#' 
#' Users will usually wish to provide some of the following inputs: \describe{
#' 
#' \item{list("lower")}{vector of same length as \code{y} or \code{right},
#' user-provided lower bounds on \code{y} or \code{right}; only used when
#' simulates is \code{NULL}}
#' 
#' \item{list("upper")}{vector of same length as \code{y} or \code{right},
#' user-provided upper bounds on \code{y} or \code{right}; only used when
#' simulates is \code{NULL}}
#' 
#' \item{list("simulates")}{A string identifying one of the variables
#' (\code{x}, \code{y}, \code{top}, or \code{right}) as simulation data (by
#' default is \code{NULL}, for no simulation data).  If \code{simulates} is set
#' to one of the plot dimensions, the orthogonal dimension will be treated as
#' scenario code grouping the simulations.  For example, to plot summaries of
#' 1,000 simulates drawn from the conditional distribution of the response
#' variable \var{y} for each of 5 different values of a particular covariate,
#' stack all 5,000 simulates in a single vector \code{y}, then create a
#' corresponding 5,000-vector \code{x} listing the values of \var{x} used to
#' create each simulate.  \code{lineplot} will then calculate confidence
#' intervals each scenario, as requested in \code{ci} below.}
#' 
#' \item{list("plot")}{scalar or vector, the plot(s) in which this trace will
#' be drawn; defaulting to the first plot.  Plots are numbered consecutively
#' from the top left, row-by-row.  Thus in a 2 x 3 tiling, the first plot in
#' the second row is plot number 4.} }
#' 
#' The following inputs are all optional, and control the major features of
#' \code{lineplot}.  It is usually best to use either \code{ci} or \code{fit},
#' but not both.
#' 
#' \describe{ \item{list("ci")}{list, parameters governing the appearance and
#' calculation of confidence intervals from data in \code{lower} and
#' \code{upper} or provided by the simulations defined in \code{simulates}:
#' \describe{ \item{list("levels")}{vector of desired confidence intervals to
#' calculate from the variable named by \code{simulates}; ignored if user
#' provides bounds in \code{lower} and \code{upper}.  Default is c(0.67,0.95),
#' which gives approximately 1- and 2-standard error bounds.}
#' \item{list("mark")}{vector of desired plotting styles for confidence
#' intervals (either \code{shaded} regions or \code{dashed} lines).  May have
#' as many elements as there are columns in \code{lower} and \code{upper}, or
#' elements in \code{ci$levels}.} }}
#' 
#' \item{list("fit")}{list, parameters governing the appearance and calculation
#' of simple fits to the two plotted dimensions: \describe{
#' \item{list("method")}{The type of fit to apply: \code{linear} (default) fits
#' a bivariate linear regression; \code{wls} fits a weighted linear regression;
#' \code{robust} fits a robust regression using an M-estimator; \code{mmest}
#' fits a robust regression using an MM-estimator; \code{loess} fits a loess
#' smoother fits a loess smoother.} \item{list("ci")}{vector of requested
#' levels of confidence intervals for best fit line; default is 0.95.  Set to
#' \code{NA} for no confidence intervals.} \item{list("mark")}{vector of
#' desired plotting styles for confidence intervals (either \code{shaded}
#' regions or \code{dashed} lines) for best fit line; default is
#' \code{shaded}.} \item{list("col")}{color of best fit line; default is
#' \code{black}.} \item{list("span")}{bandwith parameter for loess; default is
#' 0.95.} \item{list("weights")}{vector of weights for \code{wls} fits.} } }
#' 
#' \item{list("extrapolate")}{list, parameters governing the plotting of
#' extrapolation outside the convex hull of the covariate data, using
#' \code{whatif} in the \pkg{WhatIf} package: \describe{
#' \item{list("formula")}{optional formula object, used to specify the
#' estimated model. Useful if the model contains functions of the covariates
#' given in \code{data} below} \item{list("data")}{matrix or dataframe, the
#' actual values of all covariates used to estimate the model (omit the
#' constant and response variable)} \item{list("cfact")}{matrix or dataframe,
#' the counterfactual values of all the covariates (omit the constant and
#' response variable), one row for each scenario.  The order of colums must
#' match \code{data}, and the order of rows must match the order of the
#' scenarios.  If scenarios are calculated from simulates, then the rows must
#' be listed from the scenario with the smallest factor level to the highest}
#' \item{list("omit.extrapolated")}{If \code{TRUE} (the default), then the
#' plotted trace and CIs are clipped to the convex hull; if \code{FALSE}, then
#' extrapolation outside the convex hull is printed in a lighter color or with
#' dashed or dotted lines.} }} }
#' 
#' In addition to these \code{lineplot}-specific parameters, users may provide
#' any of the generic tile parameters documented in \code{\link{pointsTile}}.
#' 
#' @author Christopher Adolph \email{cadolph@@u.washington.edu}
#' @seealso \code{\link{tile}}, \code{\link{linesTile}}
#' @keywords dplot list
#' @examples
#' 
#' # Example 1:  Linear regression on Swiss fertility;
#' # Tiled lineplots of counterfactual scenarios calculated by
#' # predict() and clipped to convex hull
#' data(swiss)
#' 
#' # Estimate model
#' lm.result <- lm(Fertility ~ . , data = swiss)
#' 
#' # Create counterfactual scenarios
#' cfactbaseline <- apply(swiss[,2:6],2,mean)
#' 
#' cfact1 <- cfact2 <- cfact3 <- cfact4 <- cfact5 <-
#'     data.frame(matrix(cfactbaseline,nrow=101,ncol=5,byrow=TRUE,
#'            dimnames=list(NULL,names(cfactbaseline))))
#' 
#' cfact1[,1] <- cfact2[,2] <- cfact3[,3] <- cfact4[,4] <- cfact5[,5] <-
#'     seq(0,100)
#' 
#' lm.pred1 <- predict(lm.result,newdata=cfact1,interval="confidence",level=0.95)
#' lm.pred2 <- predict(lm.result,newdata=cfact2,interval="confidence",level=0.95)
#' lm.pred3 <- predict(lm.result,newdata=cfact3,interval="confidence",level=0.95)
#' lm.pred4 <- predict(lm.result,newdata=cfact4,interval="confidence",level=0.95)
#' lm.pred5 <- predict(lm.result,newdata=cfact5,interval="confidence",level=0.95)
#' 
#' # Create some nice colors for each trace (not run)
#' # require(RColorBrewer)
#' # col <- brewer.pal(5, "Set1")
#' 
#' # What brewer.pal would produce
#' col <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")
#' 
#' 
#' # Create traces of each set of counterfactuals
#' trace1 <- lineplot(x=cfact1[,1],
#'                    y=lm.pred1[,1],
#'                    lower=lm.pred1[,2],
#'                    upper=lm.pred1[,3],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=swiss[,2:6],cfact=cfact1,
#'                                     omit.extrapolated=TRUE),
#'                    col=col[1],
#'                    plot=1
#'                    )
#' 
#' trace2 <- lineplot(x=cfact2[,2],
#'                    y=lm.pred2[,1],
#'                    lower=lm.pred2[,2],
#'                    upper=lm.pred2[,3],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=swiss[,2:6],cfact=cfact2,
#'                                     omit.extrapolated=TRUE),
#'                    col=col[2],
#'                    plot=2
#'                    )
#' 
#' trace3 <- lineplot(x=cfact3[,3],
#'                    y=lm.pred3[,1],
#'                    lower=lm.pred3[,2],
#'                    upper=lm.pred3[,3],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=swiss[,2:6],cfact=cfact3,
#'                                     omit.extrapolated=TRUE),
#'                    col=col[3],
#'                    plot=3
#'                    )
#' 
#' trace4 <- lineplot(x=cfact4[,4],
#'                    y=lm.pred4[,1],
#'                    lower=lm.pred4[,2],
#'                    upper=lm.pred4[,3],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=swiss[,2:6],cfact=cfact4,
#'                                     omit.extrapolated=TRUE),
#'                    col=col[4],
#'                    plot=4
#'                    )
#' 
#' trace5 <- lineplot(x=cfact5[,5],
#'                    y=lm.pred5[,1],
#'                    lower=lm.pred5[,2],
#'                    upper=lm.pred5[,3],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=swiss[,2:6],cfact=cfact5,
#'                                     omit.extrapolated=TRUE),
#'                    col=col[5],
#'                    plot=5
#'                    )
#' 
#' at.x <- c(0,20,40,60,80,100)
#' at.y <- c(50,60,70,80,90,100)
#' 
#' # Plot traces using tile
#' tile(trace1,
#'      trace2,
#'      trace3,
#'      trace4,    
#'      trace5,
#'      RxC = c(2,3),
#'      limits = c(0,100,50,100),
#'      #output = list(file="lineplotExample1"),
#'      xaxis = list(at=at.x),
#'      yaxis = list(at=at.y),
#'      xaxistitle = list(labels=names(cfactbaseline)),
#'      yaxistitle = list(labels="E(Fertility)"),
#'      maintitle = list(labels="Ceteris Paribus Conditional Expectations from Linear Model of Fertility"),
#'      gridlines = list(type="xy"),
#'      frame = TRUE
#'      )
#' 
#' # Example 2.1:  Multinomial Logistic Regression of alligator food;
#' # Tiled lineplots using *manually simulated counterfactuals*, with
#' # extrapolation outside the convex hull flagged
#' #
#' # See Ex. 2.2 for an automated way to handle simulations 
#' 
#' data(gator)
#' require(MASS)
#' require(nnet)
#' 
#' # Estimate MNL using the nnet library
#' mlogit.result <- multinom(food ~ size + female, Hess=TRUE)
#' pe <- mlogit.result$wts[c(6,7,8,10,11,12)]
#'                                       # point estimates
#' vc <- solve(mlogit.result$Hess)       # var-cov matrix
#' 
#' # Simulate counterfactual results, varying size and sex
#' sims <- 10000
#' simbetas <- mvrnorm(sims,pe,vc)       # draw parameters, using MASS::mvrnorm
#' sizerange <- seq(1,4,by=0.1)          # range of counterfactual sizes
#' femalerange <- c(0,1)                 # range of counterfactual sexes
#' simycat1 <- simycat2 <- simycat3 <- cfactsize <- cfactfemale <- NULL
#' for (isex in 1:length(femalerange)) { # loop over sex scenarios
#'     for (isize in 1:length(sizerange)) { # loop over size scenarios
#' 
#'         # Set up a hypothetical X vector for this scenario
#'         hypx <- rbind(1, sizerange[isize], femalerange[isex])
#' 
#'         # Calculate simulated MNL denominators for this scenario
#'         simdenom <- (1 + exp(simbetas[,1:3]%*%hypx) + exp(simbetas[,4:6]%*%hypx))
#' 
#'         # Add simulated probabilities for each category to storage vectors
#'         simycat1 <- c( simycat1, exp(simbetas[,1:3]%*%hypx)/simdenom )        
#'         simycat2 <- c( simycat2, exp(simbetas[,4:6]%*%hypx)/simdenom )
#'         simycat3 <- c( simycat3, 1/simdenom )
#' 
#'         # Save hypothetical X's to storage vectors:
#'         # must match simulated probabilities element for element
#'         cfactsize <- c(cfactsize, rep(sizerange[isize],sims) )
#'         cfactfemale <- c(cfactfemale, rep(femalerange[isex],sims) )
#'     }
#' }
#' 
#' # Create one trace for each predicted category of the response, and each sex
#' trace1 <- lineplot(x=cfactsize[cfactfemale==0],
#'                    y=simycat1[cfactfemale==0],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(0,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="blue",
#'                    plot=1
#'                    )
#' 
#' trace2 <- lineplot(x=cfactsize[cfactfemale==0],
#'                    y=simycat2[cfactfemale==0],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(0,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="red",
#'                    plot=1
#'                    )
#' 
#' trace3 <- lineplot(x=cfactsize[cfactfemale==0],
#'                    y=simycat3[cfactfemale==0],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(0,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="green",
#'                    plot=1
#'                    )
#' 
#' trace4 <- lineplot(x=cfactsize[cfactfemale==1],
#'                    y=simycat1[cfactfemale==1],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(1,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="blue",
#'                    plot=2
#'                    )
#' 
#' trace5 <- lineplot(x=cfactsize[cfactfemale==1],
#'                    y=simycat2[cfactfemale==1],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(1,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="red",
#'                    plot=2
#'                    )
#' 
#' trace6 <- lineplot(x=cfactsize[cfactfemale==1],
#'                    y=simycat3[cfactfemale==1],
#'                    simulates="y",
#'                    ci=list(mark="shaded",levels=0.67),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=cbind(sizerange,rep(1,length(sizerange))),
#'                                     omit.extrapolated=FALSE),
#'                    col="green",
#'                    plot=2
#'                    )
#' 
#' linelabels <- textTile(labels=c("Invertebrates",
#'                                  "Fish",
#'                                  "Other"),
#'                          x=  c(1.75,      3,         3),
#'                          y=  c(0.95,     0.95,      0.375),
#'                          col=c("blue", "green", "red"),
#'                          cex = 0.75,
#'                          plot=c(1,2)
#'                          )
#' 
#' at.x <- c(1,2,3,4)
#' at.y <- c(0,0.2,0.4,0.6,0.8,1)
#' 
#' # Plot traces using tile
#' tile(trace1, trace2, trace3, trace4, trace5, trace6,
#'      linelabels,
#'      RxC = c(1,2),
#'      limits = c(1,4,0,1),
#'      #output = list(file="lineplotExample2", width=7),
#'      xaxis = list(at=at.x),
#'      yaxis = list(at=at.y, major=FALSE),
#'      xaxistitle = list(labels="Size of alligator (meters)"),
#'      yaxistitle = list(type="first", labels="Pr(Primary Diet)", x=0.1),
#'      plottitle = list(labels=c("Males","Females"), y=1),
#'      gridlines = list(type="xy")
#'      )
#' 
#' 
#' 
#' # Example 2.2:  Multinomial Logistic Regression of alligator food;
#' # Tiled lineplots using *preprocessed simulations*, with
#' # extrapolation outside the convex hull flagged
#' #
#' # (Alternative method for constructing Ex 2.1; output is identical)
#' 
#' data(gator)
#' require(MASS)
#' require(nnet)
#' require(simcf)
#' 
#' # Estimate MNL using the nnet library
#' mlogit.result <- multinom(food ~ size + female, Hess=TRUE)
#' pe <- mlogit.result$wts[c(6,7,8,10,11,12)]
#'                                       # point estimates
#' vc <- solve(mlogit.result$Hess)       # var-cov matrix
#' 
#' # Simulate parameters from predictive distributions
#' sims <- 10000
#' simbetas <- mvrnorm(sims,pe,vc)       # draw parameters, using MASS::mvrnorm
#' simb <- array(NA, dim = c(sims,3,2))  # re-arrange simulates to array format
#' simb[,,1] <- simbetas[,1:3]           #   for MNL simulation
#' simb[,,2] <- simbetas[,4:6]
#' 
#' # Create full factorial set of counterfactuals
#' sizerange <- seq(1,4,by=0.1)          # range of counterfactual sizes
#' femalerange <- c(0,1)                 # range of counterfactual sexes
#' xhyp <- cfFactorial(size = sizerange, female = femalerange)
#'                                       
#' # Simulate expected probabilities
#' mlogit.qoi1 <- mlogitsimev(xhyp,simb,ci=0.67)
#' 
#' # Create one trace for each predicted category of the response, and each sex
#' trace1a <- lineplot(x=xhyp$x$size[xhyp$x$female==0],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==0,1],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==0,1,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==0,1,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==0,],
#'                                     omit.extrapolated=FALSE),
#'                    col="blue",
#'                    plot=1
#'                    )
#' 
#' trace2a <- lineplot(x=xhyp$x$size[xhyp$x$female==0],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==0,2],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==0,2,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==0,2,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==0,],
#'                                     omit.extrapolated=FALSE),
#'                    col="red",
#'                    plot=1
#'                    )
#' 
#' trace3a <- lineplot(x=xhyp$x$size[xhyp$x$female==0],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==0,3],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==0,3,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==0,3,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==0,],
#'                                     omit.extrapolated=FALSE),
#'                    col="green",
#'                    plot=1
#'                    )
#' 
#' trace4a <- lineplot(x=xhyp$x$size[xhyp$x$female==1],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==1,1],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==1,1,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==1,1,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==1,],
#'                                     omit.extrapolated=FALSE),
#'                    col="blue",
#'                    plot=2
#'                    )
#' 
#' trace5a <- lineplot(x=xhyp$x$size[xhyp$x$female==1],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==1,2],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==1,2,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==1,2,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==1,],
#'                                     omit.extrapolated=FALSE),
#'                    col="red",
#'                    plot=2
#'                    )
#' 
#' trace6a <- lineplot(x=xhyp$x$size[xhyp$x$female==1],
#'                    y=mlogit.qoi1$pe[xhyp$x$female==1,3],
#'                    lower=mlogit.qoi1$lower[xhyp$x$female==1,3,],
#'                    upper=mlogit.qoi1$upper[xhyp$x$female==1,3,],
#'                    ci=list(mark="shaded"),
#'                    extrapolate=list(data=cbind(size,female),
#'                                     cfact=xhyp$x[xhyp$x$female==1,],
#'                                     omit.extrapolated=FALSE),
#'                    col="green",
#'                    plot=2
#'                    )
#' 
#' linelabels <- textTile(labels=c("Invertebrates",
#'                                  "Fish",
#'                                  "Other"),
#'                          x=  c(1.75,      3,         3),
#'                          y=  c(0.95,     0.95,      0.375),
#'                          col=c("blue", "green", "red"),
#'                          cex = 0.75,
#'                          plot=c(1,2)
#'                          )
#' 
#' at.x <- c(1,2,3,4)
#' at.y <- c(0,0.2,0.4,0.6,0.8,1)
#' 
#' # Plot traces using tile
#' tile(trace1, trace2, trace3, trace4, trace5, trace6,
#'      linelabels,
#'      RxC = c(1,2),
#'      limits = c(1,4,0,1),
#'      #output = list(file="lineplotExample2alt", width=7),
#'      xaxis = list(at=at.x),
#'      yaxis = list(at=at.y, major=FALSE),
#'      xaxistitle = list(labels="Size of alligator (meters)"),
#'      yaxistitle = list(type="first", labels="Pr(Primary Diet)", x=0.1),
#'      plottitle = list(labels=c("Males","Females"), y=1),
#'      gridlines = list(type="xy")
#'      )
#' 
#' 
#' @export lineplot
"lineplot" <-
function(...){  
  args <- list(...,graphic="lineplot")
  class(args) <- c(class(args),"tileTrace","lineplot")
  args
}

