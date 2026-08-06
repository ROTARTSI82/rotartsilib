#import "/typst/misc/template.typ" : *

#show: hw.with(class: "STAT 390 AB", title: "Week 6")

= Mon - Feb 9
+ #[
  hw_lect15_1: 
  #figure(image("img/hw6_151.png", width: 80%))
  $ "SSE" = sum_(i=1)^n epsilon_i^2 $
  +  $ epsilon = 3/2 #h(2em) "SSE" = 3 dot (3/2)^2 = 27/4 = 6.75 $
  + $ epsilon= 1/2 #h(2em) "SSE" = 3 dot (1/2)^2 = 0.75 $
  + $ epsilon = 1 #h(2em) "SSE" = 3 dot 1^2 = 3 $
  + $ epsilon = 1 #h(2em) "SSE" = 3 dot 1^2 = 3 $
]
+ #[
  hw_lect15_2: 
  #figure(table(columns: 4, $x$, $0$, $4$, $8$, $p(x)$, $1/2$, $1/4$, $1/4$))
  + #[
    Computing $mu_x = E[x] = sum_x x p(x) = 0 dot 1/2 + 4 dot 1/4 + 8 dot 1/4 = 1 + 2 = 3. #h(1em) square$
  ]
  + #[
    $ sigma_x^2 &= V[x] = sum_x (x-mu_x)^2 p(x) \ &= sum_x (x - 3)^2 p(x) = (-3)^2 dot 1/2 + 1^2 dot 1/4 + 5^2 dot 1/4 = 9/2 + 26/4 = 11. #h(1em) square $
  ]
  + #[
    #let xb0 = table.cell($0$, fill: red.lighten(60%))
    #let xb2 = table.cell($2$, fill: yellow.lighten(60%))
    #let xb4 = table.cell($4$, fill: green.lighten(60%))
    #let xb6 = table.cell($6$, fill: rgb("#00ffff").lighten(60%))
    #let xb8 = table.cell($8$, fill: blue.lighten(60%))

    #table(columns: 4, 
      $x_1$, $x_2$, $overline(x)$, $p(overline(x))$,
      $0$, $0$, xb0, $1/2 dot 1/2 = 1/4$,
      $0$, $4$, xb2, $1/2 dot 1/4 = 1/8$,
      $0$, $8$, xb4, $1/2 dot 1/4 = 1/8$,
      $4$, $0$, xb2, $1/4 dot 1/2 = 1/8$,
      $4$, $4$, xb4, $1/4 dot 1/4 = 1/16$,
      $4$, $8$, xb6, $1/4 dot 1/4 = 1/16$,
      $8$, $0$, xb4, $1/4 dot 1/2 = 1/8$,
      $8$, $4$, xb6, $1/4 dot 1/4 = 1/16$,
      $8$, $8$, xb8, $1/4 dot 1/4 = 1/16$,
    )
  ]
  + #[
    #table(columns: 6, $overline(x)$, $0$, $2$, $4$, $6$, $8$,
    $p(overline(x))$, $1/4$, $1/4$, $5/16$, $1/8$, $1/16$)
  ]
  + $ mu_overline(x) &= E[overline(x)] = sum_overline(x) overline(x) p(overline(x)) = 0 dot 1/4 + 2 dot 1/4 + 4 dot 5/16 + 6 dot 1/8 + 8 dot 1/16 \ &= 1/2 + 20/16 + 6/8 + 1/2 = 2+1/2 + 1/2 = 3. #h(1em) square $
  + $ V[overline(x)] &= sum_overline(x) (overline(x) - mu_overline(x))^2 p(overline(x)) = sum_overline(x) (overline(x) - 3)^2 p(overline(x)) \ &= (-3)^2 dot 1/4 + (-1)^2 dot 1/4  + 1^2 dot 5/16 + 3^2 dot 1/8 + 5^2 dot 1/16 \ &= 9/4 + 1/4 + 5/16 + 9/8 + 25/16 = (40 + 5 + 18 + 25)/16 = 88/16 = 11/2. #h(1em) square $
]
+ #[
  hw_lect15_3: 
  ```R
  means = numeric(5000)
  for (i in 1:5000) {
    means[i] = mean(rexp(100, 2))
  }
  qqnorm(means)
  ```
  + #[
    #figure(image("img/hw6_153.svg", width: 50%), caption: [I love the central limit theorem.])
  ]
  + #[
    Looking at the qq-plot, the $y$-intercept is about 0.50, and the line also seems to pass through the point $(2, 0.6)$, yielding a slope of about $approx 0.1 / 2 approx 0.05$. This suggests that our data are distributed from $cal(N)(mu = 0.5,sigma=0.05)$. This is consistent with our knowledge of the exponential distribution with $lambda = 2$: the population mean is $1/lambda$, and the variance is $1/lambda^2$ so the standard deviation is also $1/lambda$. In our case, we have the population mean $mu_x = 1/lambda = 0.5$, and our standard deviation $sigma_x = 1/lambda = 0.5$. With sample sizes of $n=100$, we do get the expected distribution for sample means: $mu_overline(x) = mu_x = 0.5$, and $sigma_overline(x) = sigma_x / sqrt(n) = 0.5/10 = 0.05$.
  ]
]