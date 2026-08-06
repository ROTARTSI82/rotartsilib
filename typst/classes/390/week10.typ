#import "/typst/misc/template.typ" : *

#show: hw.with(class: "STAT 390 AB", title: "Week 10")

= Mon - Mar 9
+ #[
  /**
hw_lect24_1 (revised 11.21)
Mist (airborne droplets or aerosols) is generated when metal-removing fluids are used in machining operations to cool and lubricate
the tool and work-piece. Mist generation is a concern to OSHA, which has recently lowered substantially the workplace standard. The
article "Variables Affecting Mist Generation from Metal Removal Fluids" (Lubrication Engr., 2002: 10-17) gave the accompanying
data on x = fluid flow velocity for a 5% soluble oil (cm/sec) and y = the extent of mist droplets having diameters smaller than some
value:
x: 89 177 189 354 362 442 965
y: .40 .60 .48 .66 .61 .69 .99
   */
  hw_lect24_1:
  ```R
  x <- c(89, 177, 189, 354, 362, 442, 965)
  y <- c(.40, .60, .48, .66, .61, .69, .99)
  ```
  + #[
    // a) Make a scatterplot of the data. By R.
    ```R
    plot(y ~ x)
    ```
    #figure(image("img/hw24_1a.svg", width: 50%))
  ]
  + #[
    // b) What is the point estimate of the β coefficient? (By R.) Interpret it.
    ```R
    summary(lm(y ~ x))
    ```
    The point estimate of $beta$ is given by $hat(beta) = 0.0006210758$. For this particular sample, the best linear fit predicts an increase of 0.00062 in the extent of mist droplets for each 1 cm/s increase in the fluid flow of the oil. 
  ]
  + #[
    // c) What is s_e? (By R) Interpret it.
    ```R
    se <- sqrt(sum((y - lm(y~x)$fitted.values)^2) / (length(y) - 2))
    ```
    $s_e = 0.05404525$, where $s_e$ is the standard deviation of the errors $epsilon.alt_i = hat(y)_i - y_i$. The typical deviation of an observed data point in this sample is $0.054$ from the value predicted from the best fit model (for extent of mist droplets).
  ]
  + #[
    // d) Estimate the true average change in mist associated with a 1 cm/sec increase in velocity, and do so in a way that conveys information about precision and reliability. Hint: This question is asking for a CI for β. Compute it AND interpret it. 
    // By hand; i.e. you must use the basic formulas for the CI. E.g. for β: β_hat ± t* s_e/sqrt(S_xx) , but you may use R to compute the various terms in the formula. Use 95% confidence level.
    At a 95% confidence level, $t^ast$ for the $t$-distribution with $"df" = n-2 = 5$ is given by $t^ast = 2.570582$ (`tast <- qt(0.95 + 0.05/2, 5)` or Table VI). Then the confidence interval for $beta$ is $hat(beta) plus.minus t^ast s_e slash sqrt(s_(x x))$:
    ```R
    sxx <- sum((x - mean(x))^2) # 508479.4
    ```
    $0.0006210758 plus.minus 0.0001948284$, or $[0.0004262474, 0.0008159042]$. We are 95% confident that the true population fit's $beta$ lies in this interval.
  ]
  + #[
    // e) Suppose the fluid velocity is 250 cm/sec. Compute an interval estimate of the corresponding mean y value. Use 95% confidence level. Interpret the resulting interval. By hand, as in part d.
    For our fits, we have that $(hat(y)(x) - y(x)) / (s_epsilon sqrt(1/n + (x-overline(x))^2 / s_(x x)))$ is $t$-distributed with $"df" = n-2=5$. We again use $t^ast = 2.570582$ for a 95% confidence interval, and plug in $x = 250 "cm"slash"s"$
    ```R
    # est error: syhat = 0.0223079
    syhat <- se * sqrt(1/length(x) + (250-mean(x))^2 / sxx)
    yhat250 <- betahat * 250 + 0.4041237853 # 0.5593927, from lm(y ~ x)
    ```
    Our confidence interval is thus $hat(y)(x) plus.minus t^ast s_(hat(y))$, which is $0.5593927 plus.minus 0.05734427$ or $[0.5020485, 0.616737]$. We are 95% confident that the true population $y(x)$ lies in this range for $x=250 "cm"slash"s"$.
  ]
  + #[
    // f) Suppose the fluid velocity for a specific fluid is 250 cm/sec. Predict the y for that specific fluid in a way that conveys information about precision and reliability. Use 95% prediction level. Interpret the resulting interval. By hand, as in part d.
    For a specific data point, we have that $(y^ast - hat(y)(x)) / sqrt(s_hat(y)^2 + s_epsilon^2)$ is $t$-distributed with $"df" = n - 2 = 5$. Using $t^ast = 2.570582$, the 95% prediction interval for $y^ast$ at $x = 250 "cm"slash"s"$ is $hat(y)(x) plus.minus t^ast sqrt(s_hat(y)^2 + s_epsilon^2)$, which works out to $0.5593927 plus.minus 0.1502973$, or $[0.4090954, 0.7096901]$ (we have $"pred. err" = sqrt(s_hat(y)^2 + s_epsilon^2) = 0.05846821$). We are 95% confident that a random data point $y^ast$ taken at $x = 250 "cm"slash"s"$ will fall into this interval.
  ]
]
+ #[
  hw_lect24_2:
  + #[
    // a) As n increases (say to ∞) what does each of the following approach? Thus question does not require any math or taking limits. It simply requires recognizing the population parameter that a sample statistic approaches to.
    // For example α_hat → α. I.e, as n increases, the sample y-intercept approaches the true/population y-intercept
    // $hat(beta), hat(y)(x), t^ast, s_e, overline(x), s_x$
    As $n to infty$, we will have $hat(beta) to beta$, $overline(x) to mu_x$, $s_x to sigma_x$, $s_epsilon to sigma_epsilon$, and $hat(y)(x) to y(x)$ by the law of large numbers since these are all unbiased estimators of population parameters (or in the case of $hat(y)$, an unbiased estimate of $alpha + beta dot x$). We also have that $t^ast to z^ast$ since we have a $t$-distribution with $"df" = n-2$, and when $n to infty$, we get $"df" to infty$ and so our $t$-distribution approaches a $z$-distribution. 
  ]
  + #[
    // b) Use the results of part a to find what the following approach, as n approaches ∞:
    // CI of y(x)
    // PI of y*
    // Use these: 
    //  CI of y(x): hat(y)(x) plus.minus t^ast s_e sqrt(1/n + (x-overline(x))^2 / s_(x x))
    //  PI of y^ast: hat(y)(x) plus.minus t^ast s_e sqrt(1 + 1/n + (x-overline(x))^2/s_(x x))
    // where hat(y)(x) = hat(alpha) + hat(beta) x
    // Hint: s_(x x) = (n - 1) s_x^2
    For the CI of $y(x)$, we get that as $n to infty$,
    $
      hat(y)(x) plus.minus t^ast s_e sqrt(1/n + (x-overline(x))^2 / s_(x x)) #h(1em) &to  y(x) plus.minus z^ast sigma_epsilon sqrt(1/n + (x - mu_x)^2 / ((n - 1) s_x^2)) \
      &#h(2em) = y(x) plus.minus 0
    $
    Since $n to infty$ and $n$ is in the denominator, everything goes to 0. We use $s_(x x) = (n - 1) s_x^2$, and since $s_x$ approaches the constant $sigma_x$, it can be treated as a constant.

    For the PI of $y^ast$, we get that as $n to infty$,
    $
      hat(y)(x) plus.minus t^ast s_e sqrt(1 + 1/n + (x-overline(x))^2/s_(x x)) #h(1em) &to y(x) plus.minus z^ast sigma_epsilon sqrt(1 + 1/n + (x-overline(x))^2/((n-1) s_x^2)) \
      &#h(2em) =y(x) plus.minus z^ast sigma_epsilon.
    $
    The same terms go to zero, but we have another term that remains. The inherent variance of the $y$s cannot be eliminated with large $n$ (in our probability model we had explicitly done $y ~ cal(N)(alpha + beta dot x, sigma_epsilon)$, so we should expect this), but we _can_ find the true population fit with $n to infty$.
  ]
]

#newpage()
= Wed - Mar 11

+ #[
  /**
hw_lect25_1: A regression analysis relating y = repair time for a water filtration system (hr) to x1 = elapsed time since the previous
service (months), and x2 = type of repair (1 if electrical, 0 if mechanical) yields the following model based on n=12 observations: y_hat
= 0.950 + 0.4 x1 + 1.25 x2 . The ANOVA decomposition yields SST = 12.72, SSE = 2.09, and the standard deviation of β_2 is found
to be 0.312.
a) Does there appear to be a useful linear relationship between y and x1 and x2? To that end
- Clearly state H0 and H1,
- Compute a p-value,
- State your conclusion, and answer the question asked, at α = 0.05
b) Given that the elapsed time since the last service remains in the model, does type of repair provide useful information about repair
time? To that end
- Clearly state H0 and H1,
- Compute a p-value,
- State your conclusion, and answer the question asked, at α = 0.05
c) Calculate and interpret the 95% CI for β_2.
d) The estimated standard deviation of a prediction for repair time when elapsed time is 6 months and the type of repair is electrical is
0.192. Predict repair time under these conditions at a 95% prediction level
   */
  hw_lect25_1: With $n=12$ observations we have $hat(y) = 0.950 + 0.4 x_1 + 1.25 x_2$ (thus $k=2$), and ANOVA yields $"SST" = 12.72$ and $"SSE" = 2.09$.
  + #[
    /**
    a) Does there appear to be a useful linear relationship between y and x1 and x2? To that end
    - Clearly state H0 and H1,
    - Compute a p-value,
    - State your conclusion, and answer the question asked, at α = 0.05
     */
    We run the $F$-test for model utility: $H_0 : beta_1 = beta_2 = 0$, and $H_1 :$ at least one of the $beta$ parameters is nonzero. We have that
    $
      F = (R^2 slash k) / ((1-R^2) slash (n - (k+1)))
    $
    is $F$-distributed with $"df" = (k, n-(k+1)) = (2, 9)$ under $H_0$. From $R^2 = 1-"SSE" / "SST" = 0.8356918$, we have $F_"obs" = 22.88756$. Looking at Table 8, we have $"pr"(F > F_"obs" | H_0) < 0.1%$. `pf(22.88756, 2, 9, lower.tail=F) # 0.0003`. This meets our threshold for significance at $alpha = 0.05$, so we can reject the null hypothesis. Yes, there appears to be some useful linear relationship between $y$ and $x_1$, $x_2$.
  ]
  + #[
    /**
    b) Given that the elapsed time since the last service remains in the model, does type of repair provide useful information about repair time? To that end
    - Clearly state H0 and H1,
    - Compute a p-value,
    - State your conclusion, and answer the question asked, at α = 0.05
     */
    We have that $s_(hat(beta)_2) = 0.312$. Taking $H_0 : beta_2 = 0$ and $H_1 : beta_2 != 0$, we have that $t=(hat(beta)_2 - 0) / s_(hat(beta)_2)$ is $t$-distributed with $"df" = n-(k+1) = 9$. Thus, we calculate $t_"obs" = 1.25/0.312 = 4.00641$, and our $p$-value is $"pr"(t < -t_"obs" or t_"obs" < t | H_0)$. By Table 6, we have $p = 0.003$ (or `2*pt(4.00641, 9, lower.tail=F)`), which meets our significance threshold at $alpha = 0.05$. Thus, we can reject the null hypothesis and conclude that yes, type of repair does provide useful information about repair time.
  ]
  + #[
    // c) Calculate and interpret the 95% CI for β_2.
    At 95% confidence with $n-(k+1)=9$ degrees of freedom, we have $t^ast = 2.262157$ by `tast <- qt(1-0.05/2, 9)` or Table 6. Our CI is $hat(beta)_(2" obs") plus.minus t^ast s_hat(beta)_2$, which is 
    $1.25 plus.minus 0.705793$, or $[0.544207, 1.955793]$. We are 95% confident that the true population model's $beta_2$ lies within this range.
  ]
  + #[
    //  d) The estimated standard deviation of a prediction for repair time when elapsed time is 6 months and the type of repair is electrical is 0.192. Predict repair time under these conditions at a 95% prediction level.
    For $x_1 = 6 "months"$ and $x_2 = 1$ (electrical), we have that $s_hat(y) = 0.192$.
    The 95% prediction interval for the repair time under these conditions is $hat(y) plus.minus t^ast sqrt(s_hat(y)^2 + s_e^2)$, and we can plug our values into $hat(y)  = 0.950 + 0.4 x_1 + 1.25 x_2 =  4.6$. We compute $s_e = sqrt("SSE" / (n-(k+1))) = sqrt(2.09 / 9) = 0.4818944$, and for a 95% prediction level with 9 degrees of freedom we have $t^ast = 2.262157$ again. Thus, our interval is $4.6 plus.minus 1.17346$, or $[3.426539, 5.773461]$ (hours).
  ]
]
+ #[
  /**
hw_lect25_optional
We have learned that if p-value < α, then there's evidence to reject H0 in favor of H1. For the test of model utility,
p-value = pr(F > F_obs). So, for that p-value to be less than α, F_obs must be larger than some critical value.
a) At α=0.05, find that critical value of F_obs for a multiple regression problem involving four β's, and 30 cases.
b) Find the critical value of R^2 (above which p-value < α). Hint: The F-ratio appearing in the test of model
utility depends on R^2 of the model. So, if you know the critical value of F (as in part a), then you know the
critical value of R^2.
Moral: Like all other tests we have studied, the reject/no-reject decision can be based on the critical value of some
statistic (z, t, X^2, F), i.e. without a p-value. For the test of model utility, the decision can be made by comparing
F_obs with some critical value (e.g. found in part a), or even by comparing R^2_obs with its critical value (e.g.
found in part b).
   */
  hw_lect25_optional:
  + #[
    // a) At α=0.05, find that critical value of F_obs for a multiple regression problem involving four β's, and 30 cases.
    For $k=4$ and $n=30$, we have that the model utility $F$-statistic is $F$-distributed with $"df" = (4, 25)$. The critical value of $F_"obs"$ for which $"pr"(F > F_"obs" | H_0) < alpha$ (for $alpha=0.05$) is given by $F_"obs" = 2.75871$ `qf(0.05, 4, 25, lower.tail=F)`.
  ]
  + #[
    // b) Find the critical value of R^2 (above which p-value < α). Hint: The F-ratio appearing in the test of model utility depends on R^2 of the model. So, if you know the critical value of F (as in part a), then you know the critical value of R^2.
    // convention is that alpha = intercept and betas = coefficients.
    The formula for $F$ is
    $
      F = (R^2 slash k) / ((1-R^2) slash (n-(k+1))).
    $
    Solving for $R^2$:
    $
      F/(n-(k+1)) - (F R^2)/(n-(k+1)) = R^2 /k \
      R^2 = ((F)/(n-(k+1))) slash (1/k+F/(n-(k+1)))
    $
    Plugging in the critical $F = 2.75871$ and $n=30$, $k=4$, we get a critical $R^2 = 0.306227$.
  ]
]

= Fri - Mar 13
+ #[
  /**
hw_lect26_1: To decide whether the pipe welds in a nuclear power plant meet specification, a random sample of
welds is selected and the strength of each weld is determined by measuring the force required to break it. Suppose
a population mean strength (μ) of 100 lb/in^2 is the dividing line between welds meeting specification or not
doing so. Which of the H0/H1 is more appropriate? Explain your reasoning using Type I/II and worse errors.
H0: μ = 100 ; H1: μ > 100
or
H0: μ = 100 ; H1: μ < 100
   */
  hw_lect26_1: We should be conservative and assume that the plant does not meet spec until proven otherwise: we set $H_0 : "plant does not meet spec"$ and $H_1 : "plant meets spec"$ so that type I errors are the "worse" error of saying the plant meets spec ($H_1$) when in fact it is unsafe ($H_0$). $ H_0: mu = 100 #h(2em) H_1: mu > 100 $
]
+ #[
  /**
hw_lect26_2:
Suppose you have an AI that classifies/predicts all incoming emails as "safe" or "unsafe." The following table
(called a contingency table, or confusion matrix) is often used to summarize things. For example, suppose we take
200 safe emails, and 100 absolutely disastrous emails, throw them into our AI algorithm, and get the counts
shown below.
a) How many Type I and how many Type II errors are made? Explain.
b) If the algorithm is now faced with a new email, and it has to compute a p-value to decide how to classify the
email, what is the appropriate H0/H1?
   */
  hw_lect26_2:
  #table([X $arrow.b$ #h(2em) Y $arrow$], [Classified safe], [Classified disasterous], table.cell(stroke: none, []), [Truly safe], [180], [20], table.cell(stroke: none, [$ = 200$]), [Truly disasterous], [10], [90], table.cell(stroke: none, $= 100$), columns: 4)
  + #[
    We would again like to be conservative and assume an email is disasterous until we see evidence to the contrary. Thus, we would like our type I error to be classifying an email as safe when it is truly disasterous (10 such cases), and our type II error would be classifying an email as disasterous when it is indeed safe (20 such cases).
  ]
  + #[
    $H_0 : "email is disasterous"$ and $H_1 : "email is safe"$ lines up with the setup above.
  ]
]