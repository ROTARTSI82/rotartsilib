#import "/typst/misc/template.typ": *

#show: hw.with(title: "Week 3", class: "STAT 390 AB")

#let occ0 = table.cell($pi^0 (1-pi)^3$, fill: red.lighten(60%))
#let occ1 = table.cell($pi^1 (1-pi)^2$, fill: orange.lighten(60%))
#let occ2 = table.cell($pi^2 (1-pi)^1$, fill: yellow.lighten(60%))
#let occ3 = table.cell($pi^3 (1-pi)^0$, fill: green.lighten(60%))

= Wed - Jan 21
+ #[
  hw_lect7_1: We take $n=3$ samples from a Bernoulli random variable $x in {0,1}$, with the parameter $pi$ being the proportion of $1$s in the population.
  #table(columns: 3, [Result], [Probability], [Min], [000], occ0, [0], [001], occ1, [0], [011], occ2, [0], [010], occ1, [0], [110], occ2, [0], [111], occ3, table.cell([1], fill: green.lighten(60%)), [101], occ2, [0], [100], occ1, [0] )
  + #[
    The minimum of the three samples is 0 if any of the three are zero, or equivalently if we did not get all ones. This happens with probability $boxed(1-pi^3)$. Looking at our table, this matches with $ 
      3 [pi^2 (1-pi) + pi (1-pi)^2]+(1-pi)^3 \
      = 3[pi^2-pi^3+pi (1-2pi+pi^2)]+1-3pi+3pi^2-pi^3 \
      = 3[pi-pi^2]+1-3pi+3pi^2-pi^3=1-pi^3. #h(1em) square
    $
  ]
  + #[
    The minimum of the three can only be $1$ if all three are one, which happens with probability $boxed(pi^3)$
  ]
]
+ #[
  hw_lect7_2: We expect "number of cars who do not stop per hour" to be Poisson distributed (it is a Poisson point proccess) since the events are independent and happen at a fixed rate. Let us call this random variable $x ~ "Poiss"(lambda)$, and over 10 hours, we observe the the following sample $vec(s)$: $2,2,3,2,4,2,0,1,0,2$. We know for the Poisson distribution, $mu_x = E[x] = lambda$, and so $overline(s) = 1/10 sum_i s_i approx lambda$. Thus, we can estimate that $lambda approx 1/10 (2 + 2+ 3+dots) approx 1.8$. Then, the probability that all cars stop at the sign in an hour (i.e. the probability that 0 cars blow the stop sign) is equal to $p(0) = lambda^0/0! e^(-lambda) = e^(-1.8) approx boxed(16.53%)$
]
+ #[
  hw_lect7_3: Suppose $x ~"Poiss"(lambda)$, i.e. the probability is given by $p(x)= lambda^x/x! e^(-lambda)$ with $x in NN$.
  + #[
    $"pr"(x=0) = p(0)=e^(-lambda)$, so $lambda = boxed(-ln("pr"(x=0)))$
  ]
  + #[
  $
     "pr"(x=2)/"pr"(x=1) = p(2)/p(1) = lambda^2/2 dot 1/lambda = 1/2 lambda. \
     therefore lambda = 2 dot "pr"(x=2)/"pr"(x=1)
  $
  ]
  + #[
    No, we cannot tell the value of $lambda$ because the value of $"pr"(x=lambda) / "pr"(x=lambda-1)$ is constant:#footnote[Note that in this setup, the existence of $"pr"(x=lambda-1)$ implies that $lambda  in ZZ^+$.]

      $
        "pr"(x=lambda)/"pr"(x=lambda-1) = p(lambda)/p(lambda-1) = lambda^lambda /lambda! dot (lambda-1)!/lambda^(lambda-1) =lambda/lambda = 1.
      $
  
  ]
  
]
= Fri - Jan 23
+ #[
  hw_lect8_1: 
  #figure(image("img/l8hist.png", width: 60%))
  + #[ $n = 1 + 2 + 3 + 2 + 1 = 9$
    $
      overline(x) = 1/n sum_(i=1)^n x_i &= 1/9 (1 dot 1 + 2 dot 2 + 3 dot 3 + 2 dot 4 + 1 dot 5) \ &= (1+4+9+8+5)/9 = 27/9 = boxed(3). 
    $
  ]
  + #[
    $
      s &= sqrt(1/(n-1) sum_(i=1)^n (x_i -overline(x))^2) \ &= sqrt(1/8 [1 (1-3)^2+2  (2-3)^2 + 3 cancel((3-3)^2) + 2(4-3)^2 + 1(5-3)^2]) \ 
      &= sqrt((4+2+2+4)/8) = sqrt(12/8) approx 1.225
    $
  ]
  + #[Mean and sample standard deviation drawn above in red.]
]

+ #[
  hw_lect8_2: Let $y_i = c dot x_i$. Sample variance is defined as $s^2_x = n/(n-1) (overline(x^2)-overline(x)^2)$, where \ $overline(x^2) = 1/n sum_(i=1)^n x_i^2$ and $overline(x) = 1/n sum_(i=1)^n x_i$. Then we can compute
  $
    s^2_y := n/(n-1) (overline(y^2)-overline(y)^2) &= n/(n-1) [1/n sum_(i=1)^n y_i^2 - (1/n sum_(i=1)^n y_i)^2] \
    &= n/(n-1) [1/n sum_(i=1)^n (c dot x_i)^2- (1/n sum_(i=1)^n c dot x_i)^2] \
    &= n/(n-1) [c^2 1/n sum_(i=1)^n x_i^2- c^2 (1/n sum_(i=1)^n x_i)^2] \
    &= c^2 dot n/(n-1) (overline(x^2) - overline(x)^2) = c^2 s_x^2. #h(1em) square
  $
  #v(5em)
]
+ #[
  hw_lect8_3: Let $x_i$ be a random sample of $n$ samples. Then we can compute the sample variance of $ln(x_i)$ like so:
  $
    [s_(ln(x))]^2 = n / (n-1)  (overline(ln(x)^2) - [overline(ln(x))]^2) #h(2em) "computational" \
    [s_(ln(x))]^2 = 1/(n-1) sum_(i=1)^n (ln(x_i)-overline(ln(x)))^2 #h(4em) "defining"
  $
  where we define
  $
    overline(ln(x)) = 1/n sum_(i=1)^n ln(x_i) \
    overline(ln(x)^2) = 1/n sum_(i=1)^n ln(x_i)^2.
  $
]