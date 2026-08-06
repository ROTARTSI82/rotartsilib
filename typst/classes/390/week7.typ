#import "/typst/misc/template.typ": *

#show: hw.with(class: "STAT 390 AB", title: "Week 7")

= Wed - Feb 18
+ #[
  hw_lect16_1: In our sample ($n = 36$) we observe $overline(x)_"obs" = 3$ and $s_"obs" = 1$.

  + #[
    Assuming $mu_x = 2.5$ and $sigma_x = 2$, we have
    $
      p(overline(x) > overline(x)_"obs") &= p(sqrt(n) dot (overline(x) - mu_x)/sigma_x  > sqrt(n) dot (overline(x)_"obs" - mu_x)/sigma_x) \
      &= p(z > sqrt(36) dot (3-2.5)/2) = p(z> 3/2).
    $
    Since $z = sqrt(n) dot (overline(x) - mu_x)/sigma_x$ is standard normal by CLT, we can compute $1 - "CDF"(3/2) approx 1 - 93.32% approx 6.68%$.
  ]
  + #[
    From part (a), we have $p(overline(x) < overline(x)_"obs") = 1-p(overline(x) > overline(x)_"obs") approx 93.32%.$
  ]
  + #[
    Now assuming that $mu_x = 3.5$ and $sigma_x = 2$, we have
    $
      p(overline(x) > overline(x)_"obs") &= p(sqrt(n) dot (overline(x) - mu_x) / sigma_x > sqrt(n) dot (overline(x)_"obs" - mu_x) / sigma_x) \
      &= p(z > sqrt(36) dot (3-3.5)/ 2) = p(z > -3/2).
    $
    Again, for $z = sqrt(n)/ sigma_x dot (overline(x) - mu_x)$ we have $z ~ cal(N)(0,1)$ by CLT, and so $p(z > -3/2) = 1-"CDF"(-3/2) approx 1-6.68% approx 93.32%$.
  ]
  + #[
    From part (c), again we have $p(overline(x) < overline(x)_"obs") = 1 - p(overline(x) > overline(x)_"obs") = 6.68%$.
  ]
  + #[
    Supposing that $sigma_x = 2$, but we don't know $mu_x$. By the central limit theorem, we have the 95% confidence interval
    $
      p(-z^ast < z < z^ast) = 0.95
    $
    where $z ~ cal(N)(0,1)$ is given by $z = sqrt(n)/ sigma_x dot (overline(x) - mu_x)$. Solving for $z^ast$: we want $"CDF"(z^ast) - "CDF"(-z^ast) = "CDF"(z^ast) - (1 - "CDF"(z^ast)) = 0.95$, so $z^ast = "CDF"^(-1)(0.95/2+0.5) = "CDF"^(-1)(0.975) approx 1.96$. Thus, the 95% confidence interval is $overline(x) plus.minus 1.96 sigma_x/sqrt(n)$, and our observed interval is $3 plus.minus 0.6533$. We are 95% confident that the true population mean $mu_x$ would fall between 2.3467 and 3.6533.
  ]
]
+ #[
  hw_lect16_2: 
  
  + #[Finding a confidence interval for the $b$ parameter in $"Unif"(a=-1, b)$ for a sample of size $n$. By CLT, we have that $z=sqrt(n)/sigma_x dot (overline(x) - mu_x) ~ cal(N)(0,1)$, and for a uniform distribution we have $mu_x = 1/2 (a+b)$ and $sigma_x = 1/sqrt(12) (b-a)$. 
  Starting from our self-evident fact:
  $
    0.95&=p(-1.96<z<1.96) \
    &= p(-1.96 < sqrt(n)/sigma_x dot (overline(x)-mu_x) < 1.96) \
    &= p(-1.96 < sqrt(12 n)/(b-a) dot (overline(x) - 1/2 (a+b)) < 1.96) \
    &= p(-1.96 < sqrt(12 n)/(b+1) dot (overline(x) - 1/2 (b-1)) < 1.96) \
  $
  $
    &= p(-1.96 (b+1)/sqrt(12 n) + b/2<overline(x)+1/2< 1.96 (b+1)/sqrt(12 n) + b/2) \
    &= p(-(1.96 b) /sqrt(12n) -1.96/sqrt(12 n) + b/2 < overline(x) + 1/2 < (1.96 b)/sqrt(12 n)+1.96/sqrt(12 n) + b/2) \
    &= p([(1/2 - 1.96/sqrt(12 n))b < overline(x) +1/2 +1.96/sqrt(12 n)] and [overline(x) + 1/2 -1.96/sqrt(12 n) < (1/2 + 1.96/sqrt(12 n))b]) \
    &= p((overline(x) + 1/2 - 1.96/sqrt(12 n))/(1/2 + 1.96/sqrt(12 n)) < b < (overline(x)+1/2+1.96/sqrt(12 n))/(1/2 - 1.96/sqrt(12 n))).
  $
  Thus, our confidence interval is
  $
    (overline(x) + 1/2 plus.minus 1.96/sqrt(12 n)) /(1/2 minus.plus 1.96/sqrt(12 n)). #h(1em) square
  $
  ]
  + #[
    Supposing that we have $n=169$ and $overline(x)_"obs" = 3$ for the above case, our confidence interval is
    $
      [(3 + 1/2 - 1.96/sqrt(12 dot 169)) / (1/2 + 1.96/sqrt(12 dot 169))&, (3 + 1/2 + 1.96/sqrt(12 dot 169)) / (1/2 - 1.96/sqrt(12 dot 169)) ] \
      approx[6.359&,7.763].
    $
    We are 95% confident that $b$ falls somewhere in that range.
  ]
  + #[
    Interpretation of the random confidence interval: if we were to take random samples of size $n=169$ zillons of times and then calculate this interval using our samples' $overline(x)$s, we would get a range that includes $b$ 95% of the time.
  ]
]
#let pm = math.plus.minus
+ #[
  hw_lect16_3: Determining confidence levels:
  + #[
    $overline(x) pm 3.09 s/sqrt(n)$: By CLT, the probability of this interval containing $mu_x$ is $p(-3.09 < z < 3.09)$ for $z ~ cal(N)(0,1)$ where $z = sqrt(n)/sigma_x dot (overline(x)-mu_x)$ by making the approximation that $s approx sigma_x$. Looking it up on the CDF tables, we have $approx 0.9990 - 0.001 approx 99.8%$.
  ]
  + #[
    $overline(x) pm 2.81 s/sqrt(n)$: $"CDF"(2.81)-"CDF"(-2.81) approx 0.9975 - 0.0025 approx 99.5%$
  ]
  + #[
    $overline(x) pm 1.44 s/sqrt(n)$: $"CDF"(1.44)-"CDF"(-1.44) approx 0.9251 - 0.0749 approx 85.02%$
  ]
  + #[
    $overline(x) pm s/sqrt(n)$: $"CDF"(1)-"CDF"(-1) approx 0.8413 - 0.1587 approx 68.26%$
  ]
]

= Fri - Feb 20
+ #[
  hw_lect17_1: For a sample of $n=69$ healthy trees, we measure $overline(x)_"obs"=1.028$ for mean dye-layer density with a deviation of $s_"obs" = 0.163$.

  + #[
    The 95% confidence interval is derived from the fact (via CLT) that $p(-1.96 < z < 1.96) = 0.95$, where $z = sqrt(n) / sigma_x dot (overline(x) - mu_x)$. Our interval is $overline(x) plus.minus 1.96 sigma_x / sqrt(n)$, and making the approximation that $sigma_x approx s$ our observed interval is $1.028 plus.minus 0.0385$. This means that if we have that $s_x = sigma_x$ exactly, if we make this same calculation for different samples of size $n=69$, our interval will include $mu_x$ 95% of the time.

    Using the $t$-distribution instead, for $t = sqrt(n) / s_x dot (overline(x) - mu_x)$ we have a student $t$-distribution with $"df" = nu = n-1=68$ degrees of freedom. Here, our fact is $p(-2<t<2) = 0.95$ (approximating from table VI for $"df"=60$ for right-area = $(1-0.95)/2 = 0.025$). Thus, our interval is $overline(x) plus.minus 2 s_x / sqrt(n)$, and we have observed $1.028 plus.minus 0.0392$. This means that if we take different samples of size $n=69$ and calculate this interval, our interval will include $mu_x$ 95% of the time (here unlike our $z$-distribution version we account for the error in our measured $s_x$ from the true $sigma_x$).
  ]
  + #[
    Supposing we guess that we have a $s_x approx sigma_x approx 0.16$, we can calculate the sample size needed to get a confidence interval better than $plus.minus 0.05$ with 95% confidence. By the CLT, we have that $p(-1.96 < z < 1.96) = 0.95$, and our interval is $overline(x) plus.minus 1.96 sigma_x/sqrt(n)$. We want $1.96 sigma_x / sqrt(n) <= 0.05$, or $sqrt(n) >= 1.96 sigma_x / 0.05$. Computing $(1.96 sigma_x / 0.05)^2$, we get $n >= 39.34$, so we expect to need a sample of at least $n=40$ or greater to have a confidence better than $plus.minus 0.05$.
  ]
]
+ #[
  hw_lect17_2:
  + #[
    0.05 and 0.95 quantiles of $z$-distribution: $"CDF"^(-1)(0.05)$ and $"CDF"^(-1)(0.95)$ in table I, we have -1.64 and 1.64 respectively.
  ]
  + #[
    0.05 and 0.95 quantiles of $t$-distribution ($"df"=7$): right-area for 0.05 (reversed from CDF) in table VI: -1.9 and 1.9.
  ]
  + #[
    0.05 and 0.95 quantiles of $t$-distribution ($"df" = 120$): -1.7 to 1.7. ($"df" = infty$ is just $cal(N)(0,1)$).
  ]
]
+ #[
  hw_lect17_3: If sample size also changes from sample to sample, the sampling distribution of $t = sqrt(n)/s_x dot (overline(x) - mu_x)$ will become wider. Because $n$ is now random, $t$ no longer follows a student $t$-distribution. We have added a new source of randomness and thus we should expect more variance in the distribution of $t$, even if $overline(x)$ and $s_x$ are not completely independent from $n$. Just as going from the $z$-distribution to the $t$-distribution by adding $s_x$ as a source of randomness made our distribution wider, we should expect the same for adding $n$ as a source of randomness.
]