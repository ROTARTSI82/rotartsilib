#import "/typst/misc/template.typ": *

#show: hw.with(class: "STAT 390 AB", title: "Week 8")


= Mon - Feb 23
+ #[
  /** hw_lect18_1: Can one use the t-based CI to find a formula for the minimum sample size (like that in lect17),
necessary to have width B for the CI? Yes/No, Explain. */

  hw_lect18_1: No, it is not really possible to use a t-based confidence interval to find a formula for the minimum sample size. Changing the sample size changes the $t$-distribution one needs to sample from, as the $"df"=n-1$ parameter is directly affected, unlike the $z$-distribution which remains the same distribution. One would have to work directly with the cursed PDF involving the gamma function, and there probably is not any nice closed form formula.
]
+ #[
  /** hw_lect18_2: Exercise 7.51 describes a study ("Measuring and understanding of Kraft insulating paper in power transformers") that
reports data on the polarization of paper for two different processes. The data is shown below. Is there evidence that the two proceses are
different in terms of the true/population mean polarization? When a problem doesn't specify the confidence level, use 95%.
a) Find both the z and t CIs. For the t-based CI, simply use df = Welch's formula = 24.
b) Interpret the t-based CIs found in part a.
c) Give a yes/no answer to the question asked, AND explain your answer.
For your convenience, here are the data:
x1 = c(418, 421, 421, 422, 425, 427, 431, 434, 437, 439, 446, 447, 448, 453, 454, 463, 465)
x2 = c(429, 430, 430, 431, 436, 437, 440, 441, 445, 446, 447)
You may use R for everything, except for the function t.test(). */
  hw_lect18_2: 
  ```R
  x1 = c(418, 421, 421, 422, 425, 427, 431, 434, 437, 439, 446, 447, 448, 453, 454, 463, 465)
  x2 = c(429, 430, 430, 431, 436, 437, 440, 441, 445, 446, 447)

  # z-distribution
  mu <- mean(x1) - mean(x2)
  # approximating population sigma_x from sample s_x
  sigma <- sqrt(sd(x1)^2 / length(x1) + sd(x2)^2 / length(x2))
  conf <- qnorm((1-0.95)/2, lower.tail=F)
  print(c(mu - conf * sigma, mu + conf * sigma))

  # t-distribution with df = Welch's formula = 24
  conft <- qt((1-0.95)/2, 24, lower.tail=F)
  print(c(mu - conft * sigma, mu + conft * sigma))
  print(c(mu, sigma, conft, conf))
  ```
  + #[
    $z$-distribution 95% CI for 2-sample: $[-7.414155, 9.093300]$. \
    $t$-distribution 95% CI for 2-sample: $[-7.851841, 9.530985]$.
  ]
  + #[
    The $t$-distribution CI says that we are 95% confident that the difference between the population means $mu_(x 1) - mu_(x 2)$ lies in that range. If we were to take samples of the same size from the population and calculate the $t$ confidence interval in the same way, we would expect that the interval includes the true $mu_(x 1) - mu_(x 2)$ with probability 95%. With the $t$-distribution, we account for the fact that we use $s_x$ instead of the true population $sigma_x$ in our calculations.
  ]
  + #[
    No, there is no evidence that the two processes yield statistically different mean polarizations ($x_1$ and $x_2$). Our confidence intervals both include 0, so we have no evidence that the two means are different.
  ]
]

+ #[
  /**
   * hw_lect18_3: By R
For the data you collected, consider one of the continuous variables (call it y), and one of the categorical/discrete
variables (call it x). Let μ1 denote the true mean of y when x = (first level of x), and μ2 denote the true mean of y
when x= (2nd level of x).
a) Compute a 95% C.I. for μ1-μ2.
b) Is there evidence from data that μ1 and μ2 are different?
   */
  hw_lect18_3: 
  ```R
  dat <- read.csv("dataset.csv",header=T)
  x1 <- dat$linelen[dat$type=="header"]
  x2 <- dat$linelen[dat$type=="source"]
  ```
  + #[
    ```R
    t.test(x1, x2, conf.level=0.95, alternative="two.sided")
    ```
    95% confidence: $[3.691875, 3.984003]$.
  ]
  + #[
    Yes, there is evidence that the two means are different because the 95% confidence interval does not include 0. The average line length of a C header file in the Linux kernel is about 3-4 characters longer than the average line length of a C source file in the Linux kernel.
  ]
]

= Wed - Feb 25
+ #[
  /* hw_lect19_1: You may use R to find means and variances, but otherwise use our CI formulas. Also, for this hw,
report the CIs as (something ± something). Consider the following data:
x1 = 2, 1, 3
x2 = 6, 3, 9
a) Find the 90% CI for μ2 - μ1, assuming the data were collected in a paired design.
b) Find the 90% CI for μ2 - μ1, assuming the data were collected independently. Use t*= qt(0.95, df=2.4) = 2.6
Now, consider the following data:
x1 = 2, 1, 3
x2 = 9, 3, 6
c) Find the 90% CI for μ2 - μ1, assuming the data were collected in a paired design.
d) Find the 90% CI for μ2 - μ1, assuming the data were collected independently.
Later, check the solutions to learn the moral of this hw. */
  hw_lect19_1: 
  + #[
    We have $x_1 = {2,1,3}$ and $x_2 = {6,3,9}$.
    In a paired design, we have a difference $Delta = x_2 - x_1 = {4,2,6}$. This has $mu_Delta = 4$ and $s_Delta = 2$ with $n = 3$, and for a 90% CI we use a $t$-distribution with $"df" = n-1=2$ and calculate $t^ast = 2.92 =$ `qt((1-0.9)/2, df=2, lower.tail=F)`. Our confidence interval is $mu_Delta plus.minus t^ast s_Delta / sqrt(n)$ which is $4 plus.minus 3.372$.
  ]
  + #[
    In an unpaired design, we just have a confidence interval of $mu_Delta plus.minus t^ast sqrt(s_1^2 / n_1 + s_2^2 / n_2)$ where we have $s_1 = 1$ and $s_2 = 3$ with $n_1 = n_2 = 3$. We use Welch's formula to calculate the $"df"$ for our $t$-distribution of the 90% confidence interval and obtain $t^ast = 2.6 = $ `qt(0.95, df=2.4)`. This becomes $4 plus.minus 4.772$.
  ]
  + #[
    Now consider $x_1 = {2,1,3}$ and $x_2 = {9,3,6}$. Then we have $Delta = x_2 - x_1 = {7,2,3}$ with $mu_Delta = 4$ and $s_Delta = 2.645751$. For 90%, $t^ast = 2.92$, and a confidence interval of $mu_Delta plus.minus t^ast s_Delta / sqrt(n)$, which is $4 plus.minus 4.46$. Order/pairing matters for paired data.
  ]
  + #[
    For the unpaired design, the order of elements within $x_1$ and $x_2$ does not matter, as we only look at the sample sizes, means, and standard deviations. We still have $4 plus.minus 4.772$.
  ]
]

+ #[
  /* hw_lect19_2: This is revised 7.56. You may use R for everything, except for the function t.test().
Lactation promotes as temporary loss of bone mass to provide adequate amount of calcium for milk production.
The paper "Bone Mass Is Recovered ...." gave the following data in total body bone mineral content (TBBMC) for
a sample both during lactation (L) and in the post-weaning period (P). Is there evidence that there is a difference
between the true/population mean TBBMC for the two periods? Operate at 95% confidence level.
Subject L P
1 1928 2126
2 2549 2885
3 2825 2895
4 1924 1942
5 1628 1750
6 2175 2184
7 2114 2164
8 2621 2626
9 1843 2006
10 2541 2627
  */
  hw_lect_19_2: We run a paired 2-sample test (95% confidence).
  ```R
  lactation <- c(1928, 2549, 2825, 1924, 1628, 2175, 2114, 2621, 1843, 2541)
  postwean <- c(2126, 2885, 2895, 1942, 1750, 2184, 2164, 2626, 2006, 2627)
  diff <- lactation - postwean
  tast <- -qt(0.025, df=length(diff)-1)
  print(c(mean(diff), tast * sd(diff) / sqrt(length(diff))))
  ```
  We get a confidence interval of $-105.70000 plus.minus 74.28625$. There is evidence that the mean total body bone mineral content (TBBMC) is different between the lactation and post-weaning periods.
]

+ #[
  /*
  hw_lect19_3
Consider a problem wherein someone believes that μ_x > 0,
and you want to see if data provide evidence to its contrary.
Consider the following 2 hypothetical observed sample means.
a) *Forget p-values* and all that; which of the 2 situations (I or II)
provides more evidence from data against the belief that μ_x > 0?
b) Now, *let's think about the p-value* for these two situations.
It is defined to be the probability of getting a sample mean more extreme
than the observed, where "more extreme" means against the belief.
On each figure, shade the area corresponding to that probability.
c) Which situation (I or II) has the smaller p-value?
  */
  hw_lect_19_3: 
  #figure(image("img/hw8.png", width: 50%))
  + #[
    Situation II provides more evidence contrary to the belief that $mu_x > 0$ since our $overline(x)_"obs"$ is more negative (more extreme in the opposite direction), so if $mu_x$ were really greater than 0, then situation II would be more surprising.
  ]
  + #[
    $p$-values shaded in green.
  ]
  + #[
    Situation II has a smaller $p$-value (smaller area shaded).
  ]
]
+ #[
  /*
  hw_lect19_4
Consider the following sample observations: 2781, 2900, 3013, 2856, and 2888.
Suppose we want to test whether there is evidence *contrary to* the *belief* that μ < 3000.
a) Compute the observed 95% 2-sided confidence interval (CI) for μ.
b) Based on the above CI, is there evidence that μ is *greater than* 3000?
c) Compute the p-value, recalling that it measures evidence from data contrary to the null hypothesis.
d) Based on your p-value, is there evidence that μ is *greater than* 3000? Yes/no?
  */
  hw_lect_19_4: We have $x = {2781, 2900, 3013,2856, 2888}$. This has $mu = 2887.6$ and $s_x = 84.02559$ with $n = 5$.
  + #[
    The 95% confidence interval is given by $mu plus.minus t^ast s_x / sqrt(n)$, where $t^ast = 2.776 = $ `qt(0.025, df=4, lower.tail=F)`. This is $2887.6 plus.minus 104.332$.
  ]
  + #[
    No, the confidence interval does not provide any evidence that $mu > 3000$. In fact, it is entirely below 3000 and provides evidence to reject that claim.
  ]
  + #[
    To see if there is any evidence to the contrary of $mu < 3000$, we take that as our null hypothesis $H_0 : mu =3000$ and take the alternative $H_1 : mu > 3000$. We calculate the probability of observing a more extreme result (in the direction of our alternative) than our data:$ p(overline(x) > overline(x)_"obs" | mu=3000). $
    Standardizing, we get $t=sqrt(n)/s_x dot (overline(x) - mu) ~ "t-dist"("df"=4) $ and $t_"obs" = sqrt(n)/s_x dot (overline(x)_"obs" - mu ) = -2.991$. Thus, our probability is $p(t>t_"obs") = 0.9799 = $ `pt(2.991, df=4)`. We have $p = 97.99%$.
  ]
  + #[
    No, based on this $p$-value, there is no evidence that $mu > 3000$. This $p$-value is not small/surprising enough to disprove our null hypothesis that $mu < 3000$, so we cannot accept the alternative that $mu >3000$ (nor can we even accept the null hypothesis).
  ]
]
= Fri - Feb 27
+ #[
  /*
  hw_lect20_1: In an investigation of the toxin produced by a certain poisonous snake, a researcher prepared 26 different
vials, each containing 1gr of toxin, and then determined the amount of antitoxin necessary to neutralize the toxin. The
sample mean of the antitoxin was found to be 1.89mg, and the sample standard deviation was 0.42mg. Others have
suggested that the true average neutralizing amount is 1.75mg. Does this data contradict the value suggested by others?
a) Clearly state H0/H1.
b) Compute t_obs.
c) Compute the p-value.
d) State the conclusion in terms of H0/H1, at α = 0.05
e) Answer the question asked in the problem. Yes/No?
  */
  hw_lect_20_1: $n=26$, $overline(x)_"obs" = 1.89 "mg"$, $s_x = 0.42 "mg"$
  + #[
    $H_0 : mu = 1.75$, $H_1 : mu != 1.75$. We want to test if our data contradicts the suggested 1.75mg value.
  ]
  + #[We take $mu = 1.75$ in
    $
      t_"obs" &= sqrt(n) / s_x dot (overline(x)_"obs" - mu) \
      &= 1.699673.
    $
  ]
  + #[
    We have $t=sqrt(n) / s_x dot (overline(x) - mu)$ is $t$-distributed with $"df" = n-1=25$. Our $p$-value is the probability of a sample being further from $mu = 1.75$ than what we observed (assuming $mu = 1.75$): $ p="pr"(t < -1.699673 or 1.699673 < t) = 0.1016 $
    `2 * pt(-1.699673, df=25)`.
  ]
  + #[
    Our $p$-value of $p = 0.1016$ does not meet our threshold of significance at $alpha = 0.05$. We cannot reject the null hypothesis $H_0$ that $mu = 1.75 "mg"$ from these data, so we cannot say anything about the alternative $H_1$ either.
  ]
  + #[
    No, the data do not contradict value suggested by the others ($mu = 1.75 "mg"$), but we have no evidence in favor of it either.
  ]
]
+ #[
  /*
  hw_lect20_2: Suppose you are asked if there is evidence that $mu > overline(x)_"obs"$?
  a) Set up the appropriate H_0/H_1
  b) Compute the p-value (the ansewr is a number).
  c) Answer the question asked.
  */
  hw_lect_20_2:
  + #[
    $H_0 : mu < overline(x)_"obs"$, and $H_1 : mu > overline(x)_"obs"$
  ]
  + #[
    Our $p$-value is the probability of observing a sample more extreme (in the direction of our alternative hypothesis) than our data under our null-hypothesis assumption:
    $
      p(overline(x) > overline(x)_"obs" | mu = overline(x)_"obs") = 0.5.
    $
    This is because when we standardize, $t_"obs" = 0$ since $mu = overline(x)_"obs"$, and so we are calculating $p(t>0)$ for a $t$-distribution, which is symmetric about $0$ so we get $50%$.
  ]
  + #[
    There is no evidence that $mu > overline(x)_"obs"$.
  ]
]