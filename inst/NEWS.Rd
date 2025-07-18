\name{NEWS}
\title{News for Package \pkg{DirichletReg}}
\encoding{UTF-8}
\section{Changes in Version 0.7-2}{
  \itemize{
    \item Implemented CRAN-Notes.
  }
}
\section{Changes in Version 0.7-1}{
  \itemize{
    \item\code{summary.DirichletRegModel} now returns a \code{summary_DirichletRegModel}-class object without printing it (see \url{https://github.com/maiermarco/DirichletReg/issues/3}).
    \item Moved \pkg{rmarkdown} to Suggests to comply with new version of \pkg{knitr} (see \url{https://github.com/yihui/knitr/issues/1864}).
  }
}
\section{Changes in Version 0.7-0}{
  \itemize{
    \item Fixed: Cutoff in formula-deparsing removed.
    \item Removed \pkg{rgl} dependency (package will be loaded if necessary).
		\item Moved to GitHub.
  }
}
\section{Changes in Version 0.6-3}{
  \itemize{
    \item Instead of producing an error, density functions now return \code{NaN} with a warning if any element in \code{alpha} is <= 0.
  }
}
\section{Changes in Version 0.6-2}{
  \itemize{
    \item Fixed an error in the ternary plot (bottom axis tick labels were printed in reversed order; pointed out by Emilio A. Laca).
		\item Imports functions from default packages, as required by the new CRAN-check.
		\item Changed the \code{Description} field to eliminate the note \dQuote{Malformed Description field: should contain one or more complete sentences.} when checking the package.
  }
}
\section{Changes in Version 0.6-1}{
  \itemize{
    \item Re-derived gradients/Hessians, optimized C-code, and tweaked computation of starting values which leads to considerably better performance.
    \item Fixed some bugs in \code{drop1}.
    \item Expanded \pkg{testthat} checks.
  }
}
\section{Changes in Version 0.6-0}{
  \itemize{
    \item All likelihood and gradient functions are now written in C (all called via \code{.Call()} now instead of \code{.C()}) which leads to a considerable gain in speed.
    \item A \code{drop1} method for Dirichlet regression models was added.
          As it is still experimental and will probably change, use it with care.
          Options such as \code{scope} will be added in one of the next releases.
    \item Fixed a bug in the \code{print} method for confidence intervals and one in \code{confint.DirichletRegModel()}.
    \item Expanded the \pkg{testthat} check- and test-suite.
    \item Known issue: If you have collinear (aliased) terms, the estimation will fail.
          This will be handled automatically in subsequent releases, but for now, please remove the respective terms.
          If you fit a model and it says something like: \preformatted{Error in prepareFixed(start = start, activePar = NULL, fixed = fixed) :
At least one parameter must not be fixed using argument 'fixed'} you most likely have collinear terms or \dQuote{empty} combinations of interaction terms.
  }
}
\section{Changes in Version 0.5-2}{
  \itemize{
    \item Fixed checking functions in \code{tests/testthat}.
  }
}
\section{Changes in Version 0.5-1}{
  \itemize{
    \item Fixed a bug when using the \code{subset} argument.
    \item Added tolerance for normalization check to \code{DR_data}.
    \item moved \code{NEWS} to the new fancy \code{NEWS.Rd} file/format.
    \item Added the possibility to do quick analyses and transforming data \dQuote{on the fly}, like \code{DirichReg(DR_data(A) ~ 1)}.
          However this is only intended for quick checking purposes and may be removed at any time.
  }
}
\section{Changes in Version 0.5-0}{
  \itemize{
    \item Transformation in \code{DR_data} is now not only \code{TRUE}/\code{FALSE}, but, by default, a small numeric value to avoid troubles with floating point numbers close to 0 or 1.
    \item Time-critical routines were implemented in \code{C} (pure \R versions are available, see \code{?ddirichlet}).
    \item \code{anova.DirichletRegModel} now invisibly returns results as an object that is printed by a method.
    \item Optimized estimation routines.
    \item Fixed a bug in the predict method.
    \item Started development of a comprehensive test-suite using \pkg{testthat}.
    \item Published a working paper on the package:\cr%
          Maier, M. J. (2014). DirichletReg: Dirichlet Regression for Compositional Data in R. Research Report Series / Department of Statistics and Mathematics, 125. WU Vienna University of Economics and Business, Vienna. \url{https://epub.wu.ac.at/4077/}
    \item Added vignette with code to the working paper.
    \item Added citation info.
  }
}
\section{Changes in Version 0.4-1}{
  \itemize{
    \item The \code{trafo} Argument of \code{DR_data} has been changed, because it has lead to problems in practical applications when numbers very close to 0 or 1 were present.
    \item \code{DR_data} checks for negative values and generates an appropriate error message.
    \item \code{DR_data} has been made more robust in the presence of \code{NA}s.
  }
}
\section{Changes in Version 0.4-0}{
  \itemize{
    \item Data structure generated by \code{DR_data} has changed – the new objects can now be integrated into data frames.
    \item Formula processing is now handled by the package \pkg{Formula}.
    \item New methods have been implemented, especially for the class \code{DirichletRegModel}.
    \item The documentation is now quite complete.
    \item Some speed improvements could be achieved.
    \item Lots of minor (invisible) changes.
  }
}
\section{Changes in Version 0.002}{
  \itemize{
    \item Added the analytical Gradient and Hessian for both parametrizations.
    \item Optimization: preliminary results by \acronym{BFGS} that become starting values for Newton-Raphson optimization computing the final results.
    \item Implemented some residuals
    \item Updated help entries
  }
}
