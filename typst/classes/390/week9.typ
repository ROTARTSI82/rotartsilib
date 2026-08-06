#import "/typst/misc/template.typ" : *

#show: hw.with(class: "STAT 390 AB", title: "Week 9")

= Mon - Mar 2
+ #[
  /**
   * hw_lect21_1: This is 8.30 in the book. According to an article "tests currently used for condoms are surrogates for the
  challenges they face in use," including a test for holes, an inflation test, a package seal test, and tests of dimensions and
  lubricant quality. The investigators developed a new test that adds cycle strain to a level well below breakage and
  determines the number of cycles to break. The article reported that for a sample of 20 natural latex condoms, the sample
  mean and sample standard deviation of the number of cycles to break were 4358 and 2218, respectively, whereas a sample
  of 20 polyisoprene condoms gave a sample mean and sample standard deviation of 5805 and 3990, respectively. Is there
  evidence for concluding that the true mean number of cycles to break for the polyisoprene condom exceeds that for the
  natural latex condom by more than 1000 cycles?
  */
  hw_lect21_1:
  + #[
    // a) Write H0/H1,
    Let $overline(x)_1$ and $mu_1$ denote natural latex condoms' mean number of cycles to break, and let $overline(x)_2$ and $mu_2$ denote polyisoprene condoms. We want to test if $mu_2$ exceeds $mu_1$ by more than 1000 cycles.
    $
      H_0 : mu_2 - mu_1 = 1000 #h(2em) H_1: mu_2 - mu_1 > 1000
    $
  ]
  + #[
    This is an unpaired 2-sample test:
    // b) Compute t_obs
    $
      t_"obs" = ((overline(x)_2 - overline(x)_1) - Delta)/ sqrt(s_1^2 / n_1 + s_2^2/n_2) = ((5805 - 4358) - 1000) / sqrt(2218^2 / 20 + 3990^2 / 20) = 0.437903.
    $
  ]
  + #[
    // c) Compute the p-value,
    $p$-value, using $t$-distribution with $"df" = "Welch" = 29$.
    $
      "pr"(t > t_"obs") = 33.24%.
    $
    `pt(0.437903,29,lower.tail=F)` or Table VI.
  ]
  + #[
    // d) State your conclusion, and answer the question at α = 0.01. Use df = Welch = 29.
    There is no evidence that polyisoprene condoms outperform natural latex condoms by more than 1000 cycles. Our $p$-value is not remotely close to meeting the significance threshold of $alpha = 0.01$.
  ]
]

+ #[
  /**
  hw_lect21_2: This is 8.40 in the book. An article reported the results of an experiment in which two different methods of
  determining chlorine content were used on samples of Cl2_demand-free water for various doses and contact times.
  Observations are in mg/L:
  Sample
              1     2     3     4     5     6     7      8
  MSI Method: 0.39, 0.84, 1.76, 3.35, 4.69, 7.70, 10.52, 10.92
  SIB Method: 0.36, 1.35, 2.56, 3.92, 5.35, 8.33, 10.70, 10.91
  Does the true mean content measured by one method differ from that measured by the other method?

  Important: Think about the design of the experiment.
  */
  hw_lect21_2:
  ```R
  msi <- c(0.39, 0.84, 1.76, 3.35, 4.69, 7.70, 10.52, 10.92)
  sib <- c(0.36, 1.35, 2.56, 3.92, 5.35, 8.33, 10.70, 10.91)
  ```
  + #[
    // a) State H0/H1
    Let $overline(x)_1$ and $mu_1$ denote the mean observed mass density ($"mg"/"L"$) of chlorine as measured by the MSI method, and let $overline(x)_2$ and $mu_2$ denote the SIB method. We want to test if the mean observed mass density is different under the two methods.
    $
      H_0 : mu_1 - mu_2 = 0 #h(2em) H_1 : mu_1 - mu_2 != 0
    $
  ]
  + #[
    // b) Compute t_obs
    This is a paired 2-sample test (`sd(msi - sib)`, `mean(msi - sib)`):
    $
      t_"obs" = sqrt(n) / s_(x_1 - x_2) dot (overline(x_1 - x_2) - Delta) = sqrt(8) / 0.32102 dot (-0.41375 - 0) = -3.64542.
    $
  ]
  + #[
    // c) Compute the p-value
    $p$-value, using a $t$-distribution with $"df" = n-1 = 7$.
    $
      2 dot "pr"(t < t_"obs") = 0.823%.
    $
    `2*pt(3.645421, df=7, lower.tail=F)` or Table VI.
  ]
  + #[
    // d) State your conclusion, and answer the question at α = 0.05, 0.01, and 0.001.
    Our $p$-value is small enough to provide evidence that the mean chlorine content as measured by the two methods are different for a significance level of $alpha = 0.05$ and $alpha = 0.01$. However, we do not meet the significance threshold of $alpha = 0.001$, where we do not have enough evidence to reject the null hypothesis that the two means are equal.
  ]
]

+ #[
  /**
  hw_lect21_3
  Let π1 denote the true proportion of defective bridges in the USA, and π2 .... in Canada. A sample of n1=80, and
  n2=50 bridges from the two countries, respectively, is taken, and it is found that 21% of the bridges in the USA,
  and 10% of the bridges in Canada are defective.

  Note that the two questions are different; part a asks if there is evidence that two proportions are different, but part
  b asks if one proportion is larger than the other. So, don't be surprised if you get different conclusions.
  */
  hw_lect_21_3:
  + #[
    // a) With 95% confidence, is there evidence that the true/population proportions are different? Use a CI.
    We calculate the 95% confidence interval for $p_1 - p_2$. For 95%, we have $z^ast = 1.96$ `qnorm(0.95 + 0.05/2)`.
    $
      (p_1 - p_2) &plus.minus z^ast sqrt((p_1 (1- p_1))/n_1 + (p_2 (1-p_2))/n_2) \
      (0.21 - 0.1) &plus.minus 1.96 sqrt((0.21 (1 - 0.21))/80 + (0.1 (1- 0.1))/50) \
      0.11 &plus.minus 0.122.
    $
    This interval is $[-0.012, 0.232]$, which includes 0, so there is no evidence that $pi_1$ is different from $pi_2$.
  ]
  + #[
    // b) At significance level α = 0.05, is there evidence that π1 is larger than π2? Write the correct H0/H1, compute a p-value, etc.
    Testing if $pi_1 > pi_2$:
    $
      H_0 : pi_1 - pi_2 = 0 #h(2em) H_1 : pi_1 - pi_2 > 0
    $
    $
      z_"obs" = ((p_1 - p_2) - Delta)/sqrt((p_1 (1- p_1))/n_1 + (p_2 (1-p_2))/n_2) = ((0.21 - 0.1) - 0) / sqrt((0.21 (1-0.21)) / 80 + (0.1 (1 - 0.1)) / 50) = 1.7674.
    $
    $
      p"-value"="pr"(z>z_"obs") = 3.8583%.
    $
    `pnorm(-1.7673676059)` or Table I. At a significance level of $alpha = 0.05$, there is evidence that $pi_1 > pi_2$ because our $p$-value is lower than this threshold.

    // Pooled proportion should be used? But was not taught in class so we are doing this method (that was taught in class).
  ]
]

= Wed - Mar 4
+ #[
  /**
hw_lect22_1: The following data refer to the melting temperature, y (in some unit), of a certain material at four different pressures, x (in
some unit).
Pressure Temperature
----------------------------
1.6 59.5, 53.3, 56.8, 63.1, 58.7
3.8 55.2, 59.1, 52.8, 54.5
6.0 51.7, 48.4, 53.9, 49.0
10.2 44.6, 48.5, 41.0, 47.3, 46.1
##########################################################
Hint1: Start with the data in this format:
y1 = c(59.5, 53.3, 56.8, 63.1, 58.7)
y2 = c(55.2, 59.1, 52.8, 54.5)
y3 = c(51.7, 48.4, 53.9, 49.0)
y4 = c(44.6, 48.5, 41.0, 47.3, 46.1)
Hint2: use ybarbar = mean(c(y1, y2, y3, y4))
Hint3: For making the qqplots, use the following code (from prelabs) for making the 1st qqplot, but for the remaining qqplots, replace the
plot() with points() so that they will be superimposed on the first plot:
n = length(y1)
X = seq(.5/n, 1-.5/n, length=n)
Q = qnorm(X, 0, 1)
plot(Q, sort(y1), ylim=range(y1,y2,y3,y4), type="b")
#############################################################
a) Make a comparative boxplot of y for the four pressure levels.
b) Based on the above boxplot, would you say that there is a difference in the mean melting temperature for at least 2 of the pressure
levels?
c) At α = 0.05, is there evidence that the mean melting temperature in at least 2 of the four pressure levels are different? Report the p-
value, and state the conclusion clearly. "By hand," i.e. without using aov() or lm(), but using the basic formulas for SSbetween, SSwithin,
etc.
d) Write code to compute the above p-value "by R", i.e. using aov() or lm(). Skip
e) After (or before) a 1-way ANOVA test, one should check the two assumptions that the y's are normally distributed within each group,
and with the same variance. To that end, make a plot that shows four qqplots (of y for each of the 4 pressure levels) superimposed onto a
single figure; make sure that the four qqplots have different colors. To superimpose , you'll have to use "by hand" qq-plot given above .
Are the 4 qqplots reasonably straight, and do they have approximately equal slopes? .
   */
  hw_lect22_1:
  ```R
  yi <- list(
    c(59.5, 53.3, 56.8, 63.1, 58.7),
    c(55.2, 59.1, 52.8, 54.5),
    c(51.7, 48.4, 53.9, 49.0),
    c(44.6, 48.5, 41.0, 47.3, 46.1)
  )
  y <- unlist(yi)
  n <- length(y)
  k <- 4
  ```
  + #[
    // a) Make a comparative boxplot of y for the four pressure levels.
    ```R
    boxplot(yi[[1]], yi[[2]], yi[[3]], yi[[4]])
    ```
    #figure(image("img/hw22_1a.svg", width: 50%))
  ]
  + #[
    // b) Based on the above boxplot, would you say that there is a difference in the mean melting temperature for at least 2 of the pressure levels?
    Yes, there appears to be a difference in the mean melting temperature for at least 2 of the pressure levels. Although there is overlap between some of the boxes, there exist some pairs of boxes that do not overlap.
  ]
  + #[
    // c) At α = 0.05, is there evidence that the mean melting temperature in at least 2 of the four pressure levels are different? Report the p-value, and state the conclusion clearly. "By hand," i.e. without using aov() or lm(), but using the basic formulas for SSbetween, SSwithin, etc.
    We run a 1-way ANOVA $F$-test to see if at least two of the four means are different:
    ```R
    ybarbar <- mean(y)
    yibar <- numeric(4)
    si <- numeric(4)
    ni <- numeric(4)
    
    for (i in 1:4) { 
      ni[i] <- length(yi[[i]])
      yibar[i] <- mean(yi[[i]]) 
      si[i] <- sd(yi[[i]])
    }
    ```
    $
      "SS"_"between" = sum_(i=1)^k n_i (overline(y_i) - overline(overline(y)))^2 = 457.807.
    $
    ```R
    ssbetween <- sum(ni * (yibar - ybarbar)^2)
    ```
    $
      "SS"_"within" = sum_(i=1)^k (n_i - 1) s_i^2 = 126.258.
    $
    ```R
    # also sum((unlist(y) - ybarbar)^2) - ssbetween
    sswithin <- sum((ni - 1) * si^2)
    ```
    $
      F= ("SS"_"between" slash (k-1))/("SS"_"within" slash (n- k))
    $
    $
      F_"obs" = 16.92117 #h(2em) (n=18,k=4)
    $
    ```R
    Fobs <- (ssbetween / (k-1)) / (sswithin / (n-k))
    ```
    Our $p$-value is $"pr"(F > F_"obs" | H_0)$, where we have $F ~ F"-distrib"("df"=(3,14))$. We have $p = 6.240609 dot 10^(-5)$, practically 0, much lower than our significance threshold of $alpha = 0.05$ (Table VII reports that $F > 3.34$ meets $alpha = 0.05$ and $F > 9.73$ has $p < 0.001$).
    ```R
    pf(Fobs, 3, 14, lower.tail=F)
    ```
    Thus, we can reject the null hypothesis that the means of all the groups are the same, and we have evidence that at least two of the group means are different from each other.
  ]
  + #[
    // d) Write code to compute the above p-value "by R", i.e. using aov() or lm(). Skip
    Skip, but just for fun:
    ```R
    grp <- c(1,1,1,1,1, 2,2,2,2, 3,3,3,3, 4,4,4,4,4)
    summary(aov(y ~ as.factor(grp)))
    ```
    Reports $F_"obs" = 16.92$ and a $p$-value of $6.24 dot 10^(-5)$ for the $F$-test, which matches what we got manually!
  ]
  + #[
    // e) After (or before) a 1-way ANOVA test, one should check the two assumptions that the y's are normally distributed within each group, and with the same variance. To that end, make a plot that shows four qqplots (of y for each of the 4 pressure levels) superimposed onto a single figure; make sure that the four qqplots have different colors. (To superimpose , you'll have to use "by hand" qq-plot given above.) Are the 4 qqplots reasonably straight, and do they have approximately equal slopes? .
    ```R
    Xi <- list()
    Qi <- list()

    plot(c(), c(), xlim=c(-1.5, 1.5), ylim=range(unlist(yi)), type="b")
    cols <- c("red", "green", "blue", "orange")
    for (i in 1:4) {
      Xi[[i]] <- seq(.5/ni[i], 1-.5/ni[i], length=ni[i])
      Qi[[i]] <- qnorm(Xi[[i]], 0, 1)
      points(Qi[[i]], sort(yi[[i]]), type="b", col=cols[i])
    }
    ```
    #figure(image("img/hw22_1e.svg", width: 50%))
    All four QQ plots appear reasonably straight and seem to have the same slope. Thus, we can expect the $F$-test to work reasonably well, as each group appears to be normally distributed with the same standard variance.
  ]
]
+ #[
  /**
hw_lect22_2: In an experiment to study the possible effects of four different concentrations of chemical on heights of
newly grown plants (measured in inches), an ANOVA F-test is conducted. At a later date, the experimentor decides that
plant heights should have been measured in centimeters instead of inches. After multiplying the data in the original
samples by 2.54, the experimentor wants to know what effect this data conversion will have on the conclusions drawn from
the ANOVA F-test. To that end, show how each of the following changes when we multiply all the data by a positive
constant, c:
SST, SS_between, SS_within, F, and p-value.
   */
  hw_lect22_2: Multiplying by a constant $c$ should have no effect on an $F$-test. We have that $y_(i j) mapsto c y_(i j)$, and so for each $i$ we have $overline(y_i) mapsto c overline(y_i)$, and overall $overline(overline(y)) mapsto c overline(overline(y))$ by the linearity of expectation. This can also be seen by looking at the definition of the bars (let $n_"tot" = sum_(i=1)^k n_i$, and note that all the $n_i$s and $n_"tot"$ are constant under our mapping):
  $
    overline(y_i) = 1/n_i sum_(j=1)^n_i y_(i j) #h(2em) overline(overline(y)) = 1/n_"tot" sum_(i=1)^k sum_(j=1)^n_i y_(i j)
  $
  Thus, applying these mappings of $overline(y_i)$ and $overline(overline(y))$ to SST, we see that we will have $"SST" mapsto c^2 dot "SST"$ by factoring out the $c$:
  $
    "SST" = sum_(i=1)^k sum_(j=1)^n_i (y_(i j) - overline(overline(y)))^2
  $
  And similarly we have $"SS"_"between" mapsto c^2 dot "SS"_"between"$ and $"SS"_"within" mapsto c^2 dot "SS"_"within"$ by factoring out the $c$, as the $n_i$s are not affected by our mapping:
  $
    "SS"_"between" = sum_(i=1)^k n_i (overline(y_i) - overline(overline(y)))^2 #h(2em) "SS"_"within" = sum_(i=1)^k sum_(j=1)^n_i (y_(i j) - overline(y_i))^2 = sum_(i=1)^k (n_i-1)s_i^2
  $
  (Bonus that $s_i mapsto c dot s_i$ under this mapping). Thus, because $"SS"_"between"$ and $"SS"_"within"$ both got multiplied by $c^2$, this factor will cancel out in the final $F$-statistic and our test is unaffected:
  $
    F_"obs" = ("SS"_"between" slash (k - 1))/("SS"_"within" slash (n - k)).
  $
  Here, the other values of $k$ and $n$ remain constant under our mapping, and we will get the same $F_"obs"$. Because our $p$-value is given by $p="pr"(F > F_"obs" | H_0)$, our $p$-value is still the same ($F$ is still $F$-distributed according to the same $F$-distribution with $"df"=(k-1,n-k)$, which is constant). 
]
+ #[
  /**
hw_lect_optional: By hand or by R (see prelab)
Consider the data you collected. Take one of the continuous variables (call it y) and the categorical (or discrete) variable
with 3 or more levels (call it x). Since x is discrete/categorical, we can consider each level as a different population. Eg, if
your x has 3 levels (say H, M, L), separate the corresponding y's into 3 populations.
a) Do 1-way ANOVA to test if any of the k populations have different means. Report the p-value, and the conclusion.
b) Make qq-plots of y for each of the levels of X. It's important to have all qq-plots superimposed onto a single figure. See
"By hand" q-plots in prelab. For example, if your x has 3 levels, then you need to have 3 qq-plots superimposed on one plot,
e.g.
Recall that equal-slopes translate to equal variances, and so this will be a way of visually checking the homoscedasticity
   */
  hw_lect_optional: Our dataset is source files in the Linux kernel (as of whenever I assembled this dataset), and we are examining if different file types (C source, C header, Rust, Assembly, Python) have different average line lengths.
  ```R
  dat <- read.csv("dataset.csv", header=T)
  y <- dat$linelen
  ```
  + #[
    Running an $F$-test:
    ```R
    summary(aov(y ~ dat$type))
    ```
    We see $F_"obs" = 1023$ and a $p$-value of $<2 dot 10^(-16)$. Assuming that our samples are normally distributed with similar standard deviations, then we can reject the null hypothesis that all file types have the same average line length. We have evidence that at least two file types have different mean average line lengths.
  ]
  + #[
    ```R
    yi <- list()
    ni <- numeric(5)
    Xi <- list()
    Qi <- list()

    plot(c(), c(), xlim=c(-4, 4), ylim=range(y), type="b")
    cols <- c("red", "green", "blue", "orange")
    labels <- c("source", "header", "asm", "py", "rust")
    for (i in 1:5) {
      yi[[i]] <- y[dat$type == labels[i]]
      ni[i] <- length(yi[[i]])
      Xi[[i]] <- seq(.5/ni[i], 1-.5/ni[i], length=ni[i])
      Qi[[i]] <- qnorm(Xi[[i]], 0, 1)
      points(Qi[[i]], sort(yi[[i]]), type="b", col=cols[i])
    }
    ```
    #figure(image("img/hw22_opt.svg", width: 50%))
    Although a subset of our data appears to be normally distributed with similar variances, there are some crazy outliers (and possibly second modes for C sources and headers), so we should not really trust the results of our previous $F$-test.
  ]
]

= Fri - Mar 6
+ #[
  /**
hw_lect23_1
In a problem dealing with flow rate (y) and pressure-drop (x) across filters, it is known that y= -0.12 + 0.095 x.
Note: this is the true "fit" to the population. Suppose it is also known that σ_ε = 0.025. IF we were to make
repeated observations of y when x=10,
a) what's the prob. of a flow rate exceeding 0.835?
b) what's the value of y such that the probability of exceeding it is 0.1112?
Call the value of interest Y, set-up the mathematical statement of the probability, standardize, use Table 1.
   */ 
  hw_lect23_1: The relationship between flow rate $y$ and pressure drop $x$ is modeled by the true fit $y = -0.12 + 0.095x$ with $sigma_epsilon = 0.025$.
  + #[
    // a) what's the prob. of a flow rate exceeding 0.835?
    At $x=10$, our model predicts $y=0.83$ and so $y ~ cal(N)(0.83,sigma_epsilon = 0.025)$. We calculate:
    $
      "pr"(y > 0.835) = "pr"((y - 0.83) / 0.025 > (0.835 - 0.83) / 0.025) = "pr"(z > 0.2) = 42.07%
    $
    `pnorm(-0.2)` or Table I.
  ]
  + #[
    // b) what's the value of y such that the probability of exceeding it is 0.1112? Call the value of interest Y, set-up the mathematical statement of the probability, standardize, use Table 1.
    At $x=10$, we can find the value $Y$ such that the probability of exceeding it is $0.1112$:
    $
      0.1112 = "pr"(y > Y) = "pr"((y-0.83)/0.025 > (Y-0.83)/0.025).
    $
    We have $z = (y-0.83)/0.025$ is standard normal, and so $(Y-0.83)/0.025 = 1.22$. (via `-qnorm(0.1112)` or Table I). Solving for $Y$, we get $Y = 0.8605$.
  ]
]
+ #[
  /**
hw_lect23_2: This is a combination of exercises 3.4, 3.22, and 11.13 in the book. The exercise discusses a method of
extracting oil from sea water in cases of oil spills. x measures the amount of oil present in water, and y measures the
amount of oil extracted. Does a simple regression model appear to specify a useful relationship between these two
variables? To that end,
a) Compute and report a 95% CI for a relevant quantity.
b) Compute the p-value for relevant hypotheses, and state your conclusion at α = 0.05. Clearly state your hypotheses.
You may use lm() , aov(), and anova() (from the labs), but everything else should be done using the equations developed in
this lecture.
Hints:
For the CI approach, use R to get tstar = 2.160369.
For the p-value appoach, show that t_obs = 54.55917.
x = c(1.0, 1.5, 2.1, 2.8, 3.6, 4.5, 5.5, 6.6, 7.8, 9.1, 10.5, 12.0, 13.6, 15.2, 16.9)
y = c(0.610, 0.840, 1.512, 1.792, 2.952, 2.880, 4.400, 5.346, 6.396, 7.189, 8.085, 9.840, 11.696, 13.224, 14.365)
  */
  hw_lect23_2:
  ```R
  x <- c(1.0, 1.5, 2.1, 2.8, 3.6, 4.5, 5.5, 6.6, 7.8, 9.1, 10.5, 12.0, 13.6, 15.2, 16.9)
  y <- c(0.610, 0.840, 1.512, 1.792, 2.952, 2.880, 4.400, 5.346, 6.396, 7.189, 8.085, 9.840, 11.696, 13.224, 14.365)
  sxx <- sum((x - mean(x))^2) # 375.2773
  se <- sqrt(sum((y - lm(y~x)$fitted.values)^2) / (length(y) - 2)) # 0.3118161
  print(lm(y~x)$coeff) # read out betahat <- 0.8782469
  ```
  + #[
    // a) Compute and report a 95% CI for a relevant quantity.
    From our theorem, we have that $t =(hat(beta) - beta) / (s_e slash sqrt(s_(x x))) ~ t"-dist"("df"=n-2)$ where $n = 15$. For a 95% CI, we can solve $"pr"(-t^ast < t < t^ast) = 0.95$ for $t^ast = 2.160369$ via `tast <- qt((1-0.95)/2, 13, lower.tail=F)`. 
    
    Thus, our confidence interval for $beta$ is $hat(beta) plus.minus t^ast s_e /sqrt(s_(x x))$, which is $0.87825 plus.minus 0.03477$. This is $[0.84347, 0.91302]$, an interval that does not include 0, so we are 95% confident that a simple linear regression supports a useful relationship between the variables.
  ]
  + #[
    // b) Compute the p-value for relevant hypotheses, and state your conclusion at α = 0.05. Clearly state your hypotheses.
    We take $H_0 : beta = 0$ as our null hypothesis and $H_1 : beta != 0$ as our alternative. We have $t_"obs" = (hat(beta) - 0)/ (s_e slash sqrt(s_(x x))) = 54.56251$ and thus we calculate a $p$-value of
    $
      "pr"(t < -t_"obs" or t_"obs" < t) = 9.686128 dot 10^(-17).
    $
    `2*pt(-betahat / (se / sqrt(sxx)), 13)`. Our $p$-value meets our significance threshold of $alpha = 0.05$, so we can reject the null hypothesis and accept the alternative that there is a useful linear relationship between the variables.
  ]
]