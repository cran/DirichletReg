## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
    collapse = TRUE
  , comment = "##"
  , tidy = TRUE
  , fig.width=7
  , fig.height=7
)

## ----message = FALSE----------------------------------------------------------
library("DirichletReg")
head(ArcticLake)

AL <- DR_data(ArcticLake[,1:3])

AL[1:6,]

## ----fig.show='hold', fig.cap = "Figure 1: Arctic lake: Ternary plot and depth vs. composition. (left)"----
plot(AL, cex=.5, a2d=list(colored=FALSE, c.grid=FALSE))

## ----fig.show='hold', fig.cap = "Figure 1: Arctic lake: Ternary plot and depth vs. composition. (right)"----
plot(rep(ArcticLake$depth,3),as.numeric(AL), pch=21, bg=rep(c("#E495A5", "#86B875", "#7DB0DD"),each=39), xlab="Depth (m)", ylab="Proportion", ylim=0:1)

## ----tidy=TRUE----------------------------------------------------------------
lake1 <- DirichReg(AL~depth, ArcticLake)
lake1

coef(lake1)

lake2 <- update(lake1, .~.+I(depth^2)|.+I(depth^2)|.+I(depth^2))
anova(lake1,lake2)

summary(lake2)

## ----fig.show='hold', fig.cap = "Figure 2: Arctic lake: Fitted values of the quadratic model."----
par(mar=c(4, 4, 4, 4)+0.1)
plot(rep(ArcticLake$depth,3),as.numeric(AL),
     pch=21, bg=rep(c("#E495A5", "#86B875", "#7DB0DD"),each=39),
     xlab="Depth (m)", ylab="Proportion", ylim=0:1, main="Sediment Composition in an Arctic Lake")

Xnew <- data.frame(depth=seq(min(ArcticLake$depth), max(ArcticLake$depth), length.out=100))
for(i in 1:3)lines(cbind(Xnew, predict(lake2, Xnew)[,i]),col=c("#E495A5", "#86B875", "#7DB0DD")[i],lwd=2)   
legend("topleft", legend=c("Sand","Silt","Clay"), lwd=2, col=c("#E495A5", "#86B875", "#7DB0DD"), pt.bg=c("#E495A5", "#86B875", "#7DB0DD"), pch=21,bty="n")

par(new=TRUE)
plot(cbind(Xnew, predict(lake2, Xnew, F,F,T)), lty="24", type="l",ylim=c(0,max(predict(lake2, Xnew, F,F,T))),axes=F,ann=F,lwd=2)
axis(4)
mtext(expression(paste("Precision (",phi,")",sep="")), 4, line=3)
legend("top",legend=c(expression(hat(mu[c]==hat(alpha)[c]/hat(alpha)[0])),expression(hat(phi)==hat(alpha)[0])),lty=c(1,2),lwd=c(3,2),bty="n")

## -----------------------------------------------------------------------------
AL <- ArcticLake
AL$AL <- DR_data(ArcticLake[,1:3])

dd <- range(ArcticLake$depth)
X <- data.frame(depth=seq(dd[1], dd[2], length.out=200))

pp <- predict(DirichReg(AL~depth+I(depth^2),AL), X)

## ----fig.cap = "Figure 3: Arctic lake: OLS (dashed) vs. Dirichlet regression (solid) predictions."----
plot(AL$AL, cex=.1, reset_par=FALSE)
points(toSimplex(AL$AL), pch=16, cex=.5, col=gray(.5))

lines(toSimplex(pp), lwd=3, col=c("#6E1D34", "#004E42")[2])

Dols <- log(cbind(ArcticLake[,2]/ArcticLake[,1],
                  ArcticLake[,3]/ArcticLake[,1]))

ols <- lm(Dols~depth+I(depth^2), ArcticLake)
p2 <- predict(ols, X)
p2m <- exp(cbind(0,p2[,1],p2[,2]))/rowSums(exp(cbind(0,p2[,1],p2[,2])))

lines(toSimplex(p2m), lwd=3, col=c("#6E1D34", "#004E42")[1], lty="21")

## -----------------------------------------------------------------------------
Bld <- BloodSamples
Bld$Smp <- DR_data(Bld[,1:4])

blood1 <- DirichReg(Smp~Disease|1, Bld, model="alternative", base=3)
blood2 <- DirichReg(Smp~Disease|Disease, Bld, model="alternative", base=3)
anova(blood1, blood2)

summary(blood1)

## ----fig.cap="Blood samples: Box plots and fitted values (dashed lines indicate the fitted values for each group)."----
par(mfrow=c(1,4), mar=c(4,4,4,2)+.25)
for(i in 1:4){
  boxplot(Bld$Smp[,i]~Bld$Disease, ylim=range(Bld$Smp[,1:4]), main=paste(names(Bld)[i]), xlab="Disease Type", ylab="Proportion")
  segments(c(-5,1.5),unique(fitted(blood2)[,i]),
           c(1.5,5),unique(fitted(blood2)[,i]),lwd=2,lty=2)
}


## -----------------------------------------------------------------------------
alpha <- predict(blood2, data.frame(Disease=factor(c("A","B"))), F, T, F)
L <- sapply(1:2, function(i) ddirichlet(DR_data(Bld[31:36,1:4]), unlist(alpha[i,])))
LP <- L / rowSums(L)
dimnames(LP) <- list(paste("C",1:6), c("A", "B"))
print(data.frame(round(LP * 100, 1),"pred."=as.factor(ifelse(LP[,1]>LP[,2], "==> A", "==> B"))),print.gap=2)

## ----fig.cap = "Blood samples: Observed values and predictions"---------------
B2 <- DR_data(BloodSamples[,c(1,2,4)])
plot(B2, cex=.001, reset_par=FALSE)

div.col <- colorRampPalette(c("#023FA5", "#c0c0c0", "#8E063B"))(100)

# expected values
temp <- (alpha/rowSums(alpha))[,c(1,2,4)]
points(toSimplex(temp/rowSums(temp)), pch=22, bg=div.col[c(1,100)], cex=2, lwd=.25)

# known values   
temp <- B2[1:30,]
points(toSimplex(temp/rowSums(temp)), pch=21, bg=(div.col[c(1,100)])[BloodSamples$Disease[1:30]], cex=.5, lwd=.25)

# unclassified  
temp <- B2[31:36,]
points(toSimplex(temp/rowSums(temp)), pch=21, bg=div.col[round(100*LP[,2],0)], cex=1, lwd=.5)

legend("topright", bty="n", legend=c("Disease A","Disease B",NA,"Expected Values"), pch=c(21,21,NA,22), pt.bg=c(div.col[c(1,100)],NA,"white"))

## -----------------------------------------------------------------------------
RS <- ReadingSkills
RS$acc <- DR_data(RS$accuracy)

RS$dyslexia <- C(RS$dyslexia, treatment)
rs1 <- DirichReg(acc ~ dyslexia*iq | dyslexia*iq, RS, model="alternative")
rs2 <- DirichReg(acc ~ dyslexia*iq | dyslexia+iq, RS, model="alternative")
anova(rs1,rs2)

## ----fig.cap="Reading skills: Predicted values of Dirichlet regression and OLS regression."----
g.ind <- as.numeric(RS$dyslexia)
g1 <- g.ind == 1   # normal
g2 <- g.ind != 1   # dyslexia
par(mar=c(4,4,4,4)+0.25)
plot(accuracy~iq, RS, pch=21, bg=c("#E495A5", "#39BEB1")[3-g.ind],
cex=1.5, main="Dyslexic (Red) vs. Control (Green) Group",
xlab="IQ Score",ylab="Reading Accuracy", xlim=range(ReadingSkills$iq))

x1 <- seq(min(RS$iq[g1]), max(RS$iq[g1]), length.out=200)
x2 <- seq(min(RS$iq[g2]), max(RS$iq[g2]), length.out=200)
n <- length(x1)
X <- data.frame(dyslexia=factor(rep(0:1, each=n), levels=0:1, labels=c("no", "yes")),iq=c(x1,x2))
pv <- predict(rs2, X, TRUE, TRUE, TRUE)

lines(x1, pv$mu[1:n,2], col=c("#E495A5", "#39BEB1")[2],lwd=3)
lines(x2, pv$mu[(n+1):(2*n),2], col=c("#E495A5", "#39BEB1")[1],lwd=3)

a <- RS$accuracy
logRa_a <- log(a/(1-a))
rlr <- lm(logRa_a~dyslexia*iq, RS)
ols <- 1/(1+exp(-predict(rlr, X)))
lines(x1, ols[1:n], col=c("#AD6071", "#00897D")[2],lwd=3,lty=2)
lines(x2, ols[(n+1):(2*n)], col=c("#AD6071", "#00897D")[1],lwd=3,lty=2)

### precision plot
par(new=TRUE)
plot(x1, pv$phi[1:n], col=c("#6E1D34", "#004E42")[2], lty="11", type="l",ylim=c(0,max(pv$phi)),axes=F,ann=F,lwd=2, xlim=range(RS$iq))
lines(x2, pv$phi[(n+1):(2*n)], col=c("#6E1D34", "#004E42")[1], lty="11", type="l",lwd=2)
axis(4)
mtext(expression(paste("Precision (",phi,")",sep="")), 4, line=3)
legend("topleft",legend=c(expression(hat(mu)),expression(hat(phi)),"OLS"),lty=c(1,3,2),lwd=c(3,2,3),bty="n")

## -----------------------------------------------------------------------------
a <- RS$accuracy
logRa_a <- log(a/(1-a))
rlr <- lm(logRa_a~dyslexia*iq, RS)
summary(rlr)

summary(rs2)

confint(rs2)

confint(rs2, exp=TRUE)

## ----fig.height=7/2*3, fig.cap="Reading skills: residual plots of OLS and Dirichlet regression models."----
gcol <- c("#E495A5", "#39BEB1")[3-as.numeric(RS$dyslexia)]
tmt <- c(-3,3)

par(mfrow=c(3,2), cex=.8)

qqnorm(residuals(rlr,"pearson"), ylim=tmt, xlim=tmt, pch=21, bg=gcol, main="Normal Q-Q-Plot: OLS Residuals",cex=.75,lwd=.5)
abline(0,1, lwd=2)
qqline(residuals(rlr,"pearson"), lty=2)

qqnorm(residuals(rs2,"standardized")[,2], ylim=tmt, xlim=tmt, pch=21, bg=gcol, main="Normal Q-Q-Plot: DirichReg Residuals",cex=.75,lwd=.5)
abline(0,1, lwd=2)
qqline(residuals(rs2,"standardized")[,2], lty=2)

plot(ReadingSkills$iq, residuals(rlr,"pearson"), pch=21, bg=gcol, ylim=c(-3,3),main="OLS Residuals",xlab="IQ",ylab="Pearson Residuals",cex=.75,lwd=.5)
abline(h=0,lty=2)
plot(ReadingSkills$iq, residuals(rs2,"standardized")[,2], pch=21, bg=gcol ,ylim=c(-3,3),main="DirichReg Residuals",xlab="IQ",ylab="Standardized Residuals",cex=.75,lwd=.5)
abline(h=0,lty=2)

plot(fitted(rlr), residuals(rlr,"pearson"), pch=21, bg=gcol ,ylim=c(-3,3),main="OLS Residuals",xlab="Fitted",ylab="Pearson Residuals",cex=.75,lwd=.5)
abline(h=0,lty=2)
plot(fitted(rs2)[,2], residuals(rs2,"standardized")[,2], pch=21, bg=gcol ,ylim=c(-3,3),main="DirichReg Residuals",xlab="Fitted",ylab="Standardized Residuals",cex=.75,lwd=.5)
abline(h=0,lty=2)

