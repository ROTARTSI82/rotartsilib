#import "/typst/misc/template.typ" : *

#show: hw.with(title: "Week 4", class: "STAT 390 AB")

= Mon - Jan 26
+ #[
  hw_lect9_1: Let $x ~ "Unif"(a,b)$, with probability density function $f(x) = 1/(b-a)$. Then the distribution mean is
  $
    E[x]= integral_a^b x 1/(b-a) "d"x = 1/(b-a) [1/2 x^2]_a^b = 1/2 (b^2-a^2)/(b-a) = 1/2(a+b). #h(1em) square
  $
  and the distribution variance is
  $
    "Var"[x] &= integral_a^b (x-1/2 (a+b))^2 1/(b-a) "d"x=1/(b-a) dot 1/3 [(x-1/2(a+b))^3]_(x=a)^b \
    &= 1/(b-a) dot 1/3 [(1/2 b-1/2a)^3-(1/2a-1/2b)^3]
  $

  We can calculate that $ (x-y)^3 - (y-x)^3 &= (x-y)^3 + (-1)^3 (y-x)^3 = 2(x-y)^3. $

  Thus, we have 
  $
    "Var"[x]&= 1/(b-a) dot 2/3 (1/2 b - 1/2 a)^3
    \ &= 1/(b-a) dot 2/(3 dot 8) (b-a)^3 = (b-a)^2/12. #h(1em) square
  $
]
+ #[
  hw_lect9_2:
  + #[
    We have $mu_x = n pi$ and $s_x^2 = n pi (1- pi)$. Thus,

    #figure(image("img/muvargraph.png"))
  ]
  Let $x ~ "Binom"(n=100, pi)$.
  #enum(
    enum.item(2)[The expected number of heads out of 100 is $100 pi$.],
    enum.item(3)[Typical deviation in the number of heads is $sqrt(100 pi (1- pi))$.],
    enum.item(4)[The typical deviation $sqrt(100 pi (1-pi))$ is maximized at $pi=0.5$, with a value of $5$.]
  )
]
+ #[
  hw_lect9_3: The probability that $x$ is within $1.5s_x$ of $mu_x$ for each of the distributions:
  + #[
    $x ~ "Binom"(n=20,pi=1/4): mu_x = n pi = 5, s_x = sqrt(n pi (1-pi)) = sqrt(5 dot 3/4)$. Thus $mu_x plus.minus 1.5 s_x approx 5 plus.minus 2.9$, and since $x$ is discrete we have $3 <= x <= 7$. By Mathematica we compute$sum_(i=3)^7 binom(20,i) (1/4)^i (3/4)^(20-i)approx 80.69%$
    `Sum[Binomial[20, k] (1/4)^k (3/4)^(20 - k), {k, 3, 7}] // N`
  ]
  + #[
    $x ~ "Poiss"(lambda = 5): mu_x = lambda = 5, s_x = sqrt(lambda) = sqrt(5)$. Thus $mu_x plus.minus 1.5 s_x approx 5 plus.minus 3.4$, so with discrete $x$ we have $2<=x<=8$. By Mathematica we compute $sum_(i=2)^8 e^(-5) 5^i/i! approx 89.15%$.
    `Sum[Exp[-5] 5^i/i!, {i, 2, 8}] // N`
  ]
  + #[
    $x ~ N(mu=5, sigma=1)$: For $mu_x plus.minus 1.5 s_x = 5 plus.minus 1.5$, we have continuous $x$ with the constraint $3.5 <= x <= 6.5$. After standardizing with $z = x-5$, we have $z ~N(0,1)$ and thus $P(3.5<=x<=6.5) = P(-1.5 <=z<=1.5)$, which we can look up in the CDF table: $"CDF"(1.5) - "CDF"(-1.5) approx .9332-.0668 approx 86.64%.$
  ]
]

= Wed - Jan 28
+ #[
  hw_lect10_1: The $p$th percentile of the $"Unif"(a,b)$ distribution is given by $a + (b-a)p/100$.
  + #[
    For $"Unif"(0,1)$, this becomes $eta_p (0,1)=0+(1-0)p/100 = p/100$.
  ]
  + #[
    For $"Unif"(a,b)$, we have $eta_p (a,b) = a + (b-a)p/100 = a+ (b-a) dot eta_p (0,1)$.
  ]
  + #[
    In plotting $eta_p (a,b)$ vs. $eta_p (0,1)$, let $eta_p (0,1) = t$. Then we are plotting the parametric curve $(t, a+(b-a)t)$, which is a line.
  ]
  + #[
    This line has a $y$-intercept of $a$ and a slope of $b-a$.
  ]
]
+ #[
  hw_lect10_2:
  #figure(
    stack(dir: ttb,
      grid(columns: 2, 
        image("img/hw4_qq_ll.svg"), image("img/hw4_qq_wsp.svg")
      ), image("img/hw4_scatter.svg", width: 50%)
    )
  )
  ```R
  x <- read.csv("dataset.csv", header=T)
  qqnorm(x$whitespace, main="whitespace vs. std normal")
  qqnorm(x$linelen, main="linelen vs. std normal")
  plot(x$whitespace, x$linelen)
  cor(x$whitespace, x$linelen)
  ```

  + #[ Both qq-plots for line length and percentage whitespace content follow a similar shape, so we might conjecture that they have the same or similar types of underlying distribution (or that they exhibit the same modes). Both appear to contain multiple distinct linear sections, suggesting that there may be multiple modes of normally distributed samples in these data. There seems to be a dominant mode at the lower end for both variables, with a much smaller secondary mode of files containing more whitespace content and longer lines. Line length also appears to have a sizable number of outliers at the upper end.]
  + #[ Just as we conjectured about two modes in the qq-plots, the scatterplot reveals what seem like two clusters: a big and fat cluster of shorter lines and less whitespace, and a much smaller and thinner cluster of longer lines and more whitespace. ]
  + #[ $r=0.4217373$. The Pearson correlation suggests a weak positive correlation (the longer the lines, the more whitespace content). However, this correlation can be explained by the presence of the two clusters we saw, so we really should not trust this. Visually looking at the two blobs by themselves, it is hard to tell if there is much correlation, though the secondary mode (long lines, more whitespace) appears to make a flat-ish line (line length remaining around 100 characters while whitespace content varies). This might be explained by the Linux code style guidelines capping line lengths at "80 columns." ]
]

= Fri - Jan 30

+ #[
  hw_lect11_1: We define $z_i = (x_i - overline(x))/(s_x)$, where $overline(x) = 1/n sum_(i=1)^n x_i$.
  + #[
    We can compute
    $
      overline(z)=1/n sum_(i=1)^n z_i = 1/n sum_(i=1)^n (x_i-overline(x))/s_x = 1/(n s_x)[sum_(i=1)^n x_i-n overline(x)] = 1/s_x [1/n (sum_(i=1)^n x_i) - overline(x)] = 0. #h(1em) square
    $
  ]
  + #[
    For variance we compute
    $
      1/(n-1) sum_(i=1)^n (z_i - overline(z))^2 = 1/(n-1) sum_(i=1)^n ((x_i-overline(x))/s_x - 0)^2 = 1/s_x^2 dot 1/(n-1) sum_(i=1)^n (x_i-overline(x))^2 = s_x^2 / s_x^2 = 1. #h(1em) square
    $
  ]
]
+ #[
  hw_lect11_2:
  + #[
    Recall that $s_x^2 = 1/(n-1) sum_(i=1)^n (x_i-overline(x))^2$ and that $s_y^2 = 1/(n-1) sum_(i=1)^n (y_i - overline(y))^2$. We compute:
    $
      r&= 1/(n-1) sum_(i=1)^n (x_i - overline(x))/(s_x) (y_i - overline(y))/s_y = 1/(n-1) dot 1/(s_x s_y) sum_(i=1)^n (x_i - overline(x))(y_i - overline(y))\ 
      &= 1/(n-1) 1/(sqrt([1/(n-1) sum_(j=1)^n (x_j-overline(x))^2][1/(n-1) sum_(k=1)^n (y_k - overline(y))^2])) sum_(i=1)^n (x_i - overline(x))(y_i - overline(y)) \
      &= 1/(n-1) 1/(1/(n-1) sqrt([sum_(j=1)^n (x_j-overline(x))^2][ sum_(k=1)^n (y_k - overline(y))^2])) sum_(i=1)^n (x_i - overline(x))(y_i - overline(y)) \
      &= (sum_(i=1)^n (x_i-overline(x))(y_i-overline(y))) / (sqrt([sum_(j=1)^n (x_j-overline(x))^2 ][sum_(k=1)^n (y_k-overline(y))^2]) ). #h(1em) square
    $
  ]
  + #[
    Define $s_(x y) = sum_(i=1)^n (x_i - overline(x)) (y_i - overline(y))$. Recall that $overline(x) = 1/n sum_(i=1)^n x_i$ and $overline(y) = 1/n sum_(i=1)^n y_i$. Then, we can compute:
    $
      s_(x y)&= sum_(i=1)^n (x_i - overline(x)) (y_i - overline(y)) = sum_(i=1)^n (x_i y_i - x_i overline(y) - overline(x) y_i + overline(x) dot overline(y)) \
      &= (sum_(i=1)^n x_i y_i) - (sum_(i=1)^n x_i overline(y)) - (sum_(i=1)^n y_i overline(x) ) + n overline(x) dot overline(y)
      \ &= (sum_(i=1)^n x_i y_i) - overline(y)(sum_(i=1)^n x_i) - overline(x)(sum_(i=1)^n y_i ) + n overline(x) dot overline(y) \
      &= (sum_(i=1)^n x_i y_i) - overline(y) dot n overline(x) - overline(x) dot n overline(y) + n overline(x) dot overline(y) \ &= (sum_(i=1)^n x_i y_i) - n overline(x) dot overline(y) = n(overline(x y) - overline(x) dot overline(y)). #h(1em) square
    $
    where $overline(x y) = 1/n sum_(i=1)^n x_i y_i$.
  ]
  + #[
    hw_lect11_3: Under the transformation $x_i mapsto x_i + c$, the Pearson correlation $r$ does not change. Let us use the definition we derived above, that $r = s_(x y) / sqrt(s_(x x) s_(y y))$. Because $y$ did not change, we know that $s_(y y)$ also did not change. We only need to show that $s_(x x)$ and $s_(x y)$ are constant.
    
    We can see that $overline(x) mapsto overline(x) + c$ since $overline(x) = 1/n sum_(i=1)^n x_i $ and $1/n sum_(i=1)^n x_i mapsto 1/n sum_(i=1)^n (x_i + c) = 1/n sum_(i=1)^n x_i + 1/n n c = overline(x) + c$. With this, we can show that for all $i$, we have $x_i - overline(x)$ remains constant under the mapping $x_i mapsto x_i + c$, since $x_i - overline(x) mapsto x_i + c - (overline(x) + c) = x_i - overline(x)$. Thus, $s_(x x)$ and $s_(x y)$ must remain constant too, as their only dependence on $x$ is $x_i - overline(x)$:
    $
      s_(x x) = sum_(i=1)^n (x_i - overline(x))^2 #h(2em) s_(x y) = sum_(i=1)^n (x_i - overline(x))(y_i - overline(y)).
    $
    Thus, because $s_(x x)$, $s_(x y)$, and $s_(y y)$ all remained constant under the mapping $x_i mapsto x_i + c$, we know that the Pearson correlation $r = s_(x y) / sqrt(s_(x x) s_(y y))$ must also remain constant. $square$
  ]
]