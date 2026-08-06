#import "/typst/misc/template.typ": *

#show: hw.with(title: "Week 2", class: "STAT 390 AB")


= Mon - Jan 12
+ #[ The number of red lights encountered, $X$ is a Binomial random variable with parameters $n=10$ and $pi = 0.4$. The probability mass function is $ p(x) = binom(10,x) dot 0.4^x dot 0.6^(10-x) $.
#v(-2em)
+ #[ The probability of encountering at most two red lights is $ P(X <= 2)=sum_(x=0)^2 p(x)=0.6^10+10 dot 0.4 dot 0.6^9 + (10dot 9)/2 dot 0.4^2 dot 0.6^8 approx 16.73% $ so on approximately #fbox[16.73%] of days, she encounters at most two red lights. The probability of encountering at least 5 lights is $  P(X >= 5) &= 1- P(X < 5) = 1 - [P(X <=2) + p(3)+p(4)] \ &= 1-0.1673- (10 dot 9 dot 8)/(3 dot 2) dot 0.4^3 dot 0.6^7 - (10 dot 9 dot 8 dot 7)/ (4 dot 3 dot 2) dot 0.4^4 dot 0.6^6 approx 36.69%  $ so on approximately #fbox[36.69%] of days in the long run, she encounters at least five red lights.
]
+ #[
  The probability of encountering between 2 and 5 lights (inclusive) is
  $ P(2<= X<=5) &=  sum_(x=2)^5 p(x)  \ &= (10 dot 9)/2 dot 0.4^2 dot 0.6^8 + (10 dot 9 dot 8) / (3 dot 2) dot 0.4^3 dot 0.6^7 + (10 dot 9 dot 8 dot 7) / (4 dot 3 dot 2) dot 0.4^4 dot 0.6^6 \ &#h(2em)+ (10 dot 9 dot 8 dot 7 dot 6)/(5 dot 4 dot 3 dot 2) dot 0.4^5 dot 0.6^5 approx 78.74% $
  so on #fbox[78.74%] of days in the long run, she will encounter between 2 and 5 red lights (inclusive).
]

]

+ #[
  + #[  The exponential distribution has probability density function
  $ f(x) = lambda e^(-lambda x)  #h(4em) x in [0, infty). $ This is a distribution. We can verify that $forall x, f(x) >= 0$ since the parameter $lambda >= 0$ and thus we have a positive multiple of an exponential. We can verify that the probability integrates to 1:
  $ integral_0^infty f(x) "d"x= lambda integral_0^infty e^(-lambda x) "d"x = -lambda 
lr([1/lambda e^(-lambda x)])_(x=0)^infty = -lambda(0-1/lambda) = 1. #h(1em) qed $ ]
  + #[The Poisson distribution has probability mass function $ p(x) = e^(-lambda) lambda^x / x! #h(4em) x in NN. $
  This is a distribution. We can verify that $forall x, p(x) >=0$ because we have that the parameter $lambda >=0$ and the input $x >= 0$, so all the terms appearing ($lambda^x$, $x!$, and $e^(-lambda)$) are all positive. We can verify that the probabilities sum to 1:
  $ sum_(x=0)^infty p(x) = e^(-lambda) sum_(x=0)^infty lambda^x / x! = e^(-lambda) e^lambda = 1. #h(1em) qed  $]
]
+ #[ Students' rating for "Instructor Overall" looks exponential when interpreted as quantitative using the scale Very Poor = 0, Poor = 1, Fair = 2, Good = 3, Very Good = 4, Excellent = 5.
```r
svg("out.svg")
plot(0:5, c(3, 2, 7, 10, 28, 50), type='h',
     main="Instructor Overall Score", xlab="Score", ylab="% Freq")
dev.off()
```
#figure(image("img/expdemo.svg", width: 50%))
]
= Wed - Jan 14
+ #[ Finding the probability $P(x <= 1.8)$:
  + $x ~ "Bernoulli"(pi)$: $P(x <= 1.8) = p(0) + p(1) = boxed(1)$
  + $x ~ "Exp"(lambda = 3)$: $ P(x <= 1.8) = integral_0^1.8 lambda e^(-lambda x) "d"x = lambda 1/(-lambda) [e^(-lambda x)]_(x=0)^1.8 = 1 - e^(-1.8lambda) approx boxed(99.55%) $
  + $x ~ "Poiss"(lambda = 3)$: $ P(x <= 1.8) = p(0) + p(1) = e^(-lambda) (lambda^0/(0!) + lambda^1/(1!)) = e^(-3)(1+3) approx boxed(19.91%) $
  + #[$x ~ "Binom"(n=10,pi=1/4)$:
  $
    P(x<=1.8)=p(0)+p(1)= (1-1/4)^10+10dot (1/4) (1-1/4)^9 approx boxed(24.40%)
  $]
  + $x ~ N(0, 1)$: Looking it up in the table, #fbox[96.41%]
 ]
+ #[
  Let $f(x)$ be a uniform distribution supported on $x in [-5, 5]$, given by $f(x)=1/(b-a)=1/10$. Suppose temperatures are drawn from this distribution.
  + In the long run, we would expect negative temperatures to account for #fbox[1/2] of samples: $integral_(-5)^0 1/10 "d"x=1/2$.
  + In the long run, we would expect #fbox[2/5] of samples to lie between -2 and 2, and #fbox[1/2] of samples to lie between -2 and 3. $integral_(-2)^2 1/10 "d"x = 4/10=2/5$, and $integral_(-2)^3 1/10 "d"x=1/2$.
 ]
+ #[ If $x in [0, 1/2]$ about 28% of the time, we expect $integral_0^(1/2) f(x) "d"x approx 0.28$. Checking it for option A, we get $integral_0^(1/2) 2x "d"x = [x^2]_(x=0)^(1/2)=1/4$. This is about 25%, but let's check option B. We get: \ 

$integral_0^(1/2) e^(-x) "d"x = [-e^(-x)]_(x=0)^(1/2)=1-e^(-1/2) approx 39.35%$, which is not as close to 28%, so #fbox[option A] is more reasonable. ]

= Fri - Jan 16

+ #[
  If $x ~ N(mu, sigma)$, then $(x - mu)/ sigma ~ N(0, 1)$. Looking at the standard normal table, we have that $
  P(mu - 1.95sigma <= x <= mu +1.95sigma) &= P(-1.95<= (x-mu)/sigma <= 1.95) \ &= "CDF"(1.95) - "CDF"(-1.95) \ &approx 0.9744 - 0.0256 approx boxed(94.88%)
  $
]
+ #[
  In order to have $x^2 ~ N(2, 1)$, $x$ must take on complex values, and there are infinitely many different ways that $x$ can be distributed. We assume that $x in [0, i dot infty) union [0, infty)$. In this case, $P(0<x<2)=P(0<x^2 < 4)=P(-2<x^2 - 2<2)$. Since $(x^2-2)~N(0,1)$, we can use the standard normal CDF table: $approx 0.9772 - 0.0228 approx boxed(95.44%)$
]
+ #[
  Considering the exponential distribution $f(x) = lambda e^(-lambda x)$:
  + #[
    The CDF is $integral_0^x f(v) "d"v= 1-e^(-lambda x)$. The $n$th percentile is $ "CDF"^(-1)(n/100)=-1/lambda ln(1-1/100 n). $
  ]
  + The box portion of the boxplot is the difference between the 75th and 25th percentiles, which is $lambda^(-1)[ln(0.75)-ln(0.25)]approx 1.099 lambda^(-1).$
]
+ #[
  + #[Making box plots of the average whitespace content with respect to file type for source code files in the Linux kernel at commit `9c7ef209cd0f`:
  #figure(image("img/w2_boxplots.svg", width: 75%))

  ```r
  x <- read.csv("dataset.csv", header=T)
  svg("w2_boxplots.svg")
  # from ?boxplot: we can plot using a formula too.
  boxplot(whitespace ~ type, data = x)
  dev.off()
  ```
  ]
  + #[
    In our sample, C source code and C headers had the two lowest average whitespace content, followed by assembly code. All three of these code types were relatively consistent (lower variance), though C sources were the most consistent. However, since C sources and headers make up the vast majority of our dataset, they also had many outliers. The average whitespace content of Python and Rust code was more varied, and they had the highest average whitespace content of these types.
  ]
  + #[The boxes for C sources and headers lie below those of the other file types, but the other three file types (assembly, Python, and Rust) overlap. For the general population (of source code written for UNIX kernels or something like that), we can say that C sources and headers likely have less average whitespace content than the other types. However, we cannot really make out a finer ordering beyond that because of the overlapping boxes.
  ]
]