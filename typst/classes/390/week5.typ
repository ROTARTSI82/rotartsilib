#import "/typst/misc/template.typ" : *

#show: hw.with(title: "Week 5", class: "STAT 390 AB")

= Mon - Feb 2
+ #[
  hw_lect12_1: The mean square error is $"MSE"(alpha, beta) = 1/n sum_(i=1)^n (y_i-alpha - beta x_i)^2$. Let $hat(alpha)$ and $hat(beta)$ be the values that minimize MSE. From solving $partial / (partial beta) "MSE"|_(hat(alpha),hat(beta)) = 0$ in class, we have that $ hat(beta) = (overline(x y) - overline(x) dot overline(y)) / (overline(x^2) - [overline(x)]^2) $ where $overline(x) = 1/n sum_(i=1)^n x_i$ and  $overline(y) = 1/n sum_(i=1)^n y_i$ and $overline(x^2) = 1/n sum_(i=1)^n x_i^2$ and $overline(x y) = 1/n sum_(i=1)^n x_i y_i$. Next, we solve for $hat(alpha)$ with $partial / (partial alpha) "MSE"|_(hat(alpha),hat(beta)) = 0$:
  $
    0&= partial / (partial alpha) [1/n sum_(i=1)^n (y_i-alpha -beta x_i)^2]_(hat(alpha),hat(beta)) \
    &= 1/n sum_(i=1)^n partial/(partial alpha) [(y_i-alpha - beta x_i)^2]_(hat(alpha),hat(beta)) \
    &= 1/n sum_(i=1)^n 2(y_i - hat(alpha)-hat(beta) x_i) dot (-1) \
    &= 1/n sum_(i=1)^n [2 hat(beta) x_i +2 hat(alpha) - 2 y_i] \
    &= 2 hat(beta) dot overline(x) + 2 hat(alpha)-2  dot overline(y).
  $
  Multiplying both sides by $-1/2$, we get $overline(y) - hat(alpha) - hat(beta) dot overline(x) = 0$.
]
+ #[
  hw_lect12_2: From the result above, we have that $overline(y) = hat(alpha) + hat(beta) dot overline(x)$. However, since the line of best fit is simply $y = hat(alpha) + hat(beta) dot x$, we have that $(overline(x), overline(y))$ lies on the line of best fit.
]
+ #[
  hw_lect12_3: 
  ```R
  moe <- c(29.8,  33.2,  33.7,  35.3,  35.5,  36.1,  36.2,
           36.3,  37.5,  37.7,  38.7,  38.8,  39.6,  41.0,
           42.8,  42.8,  43.5,  45.6,  46.0,  46.9,  48.0,
           49.3,  51.7,  62.6,  69.8,  79.5,  80.0)
  stren <- c(5.9, 7.2, 7.3, 6.3, 8.1, 6.8, 7.0, 7.6, 6.8,
             6.5, 7.0, 6.3, 7.9, 9.0, 8.2, 8.7, 7.8, 9.7,
             7.4, 7.7, 9.7, 7.8, 7.7, 11.6, 11.3, 11.8, 10.7)
  plot(moe, stren)
  boxplot(moe, main="MOE")
  boxplot(stren, main="strength")
  qqnorm(stren, main="strength")
  qqnorm(moe, main="MOE")
  ```
  #let w = 95%
  + #[
    #figure(image("img/hw5_moestr_scat.svg", width: w * 50%))
  ]
  + #[ #figure(grid(columns: 2, image("img/hw5_moe_box.svg", width: w), image("img/hw5_str_box.svg", width: w))) ]
  + #[
    #figure(grid(columns: 2, image("img/hw5_moe_qq.svg", width: w), image("img/hw5_str_qq.svg", width: w)))
  ]
  + #[
    We start from the following formula for Pearson correlation.
$ r = s_(x y) / sqrt(s_(x x) s_(y y)) $
We derived in HW 4 (hw_lect11_2 b) that $s_(x y) = n (overline(x y) - overline(x) dot overline(y))$. This formula for $s_(x y)$ automatically implies that $s_(x x) = n(overline(x^2) - [overline(x)]^2)$ and that $s_(y y) = n(overline(y^2) - [overline(y)]^2)$. Substituting these expressions into the formula for $r$ above, the $n$s all cancel out and we have the follwoing formula for Pearson correlation:
$ r = (overline(x y) - overline(x) dot overline(y)) / sqrt((overline(x^2) - [overline(x)]^2)(overline(y^2)-[overline(y)]^2)) $
    We have $x = "MOE"$ and $y = "strength"$. By R, we can compute the relevant means:
    ```R
    xbar <- mean(moe) # 45.10741
    ybar <- mean(stren) # 8.140741
    xybar <- mean(moe * stren) # 385.4259
    x2bar <- mean(moe * moe) # 2204.178
    y2bar <- mean(stren * stren) # 68.9237
    ```
    Plugging these in, we get $r=0.8592721$ from `(xybar - xbar * ybar) / sqrt((x2bar - xbar^2)*(y2bar - ybar^2))`.
  ]
  + #[
    By R, `cor(moe, stren)` is $0.8592721$, which is exactly what we got by hand.
  ]
  + #[
    We have the following formulas for $hat(beta)$:
    $ hat(beta) = (overline(x y) - overline(x) dot overline(y))/(overline(x^2)-[overline(x)]^2). $
    Plugging in our means, we get our slope $hat(beta) = 0.1074821$ `betahat = (xybar - xbar * ybar) / (x2bar - xbar^2)`.
    
    We also have the following for $hat(alpha)$:
    $ 
      overline(y) = hat(alpha) + hat(beta) dot overline(x) #h(1em) implies #h(1em) hat(alpha) = overline(y) - hat(beta) dot overline(x).
    $
    Plugging in our means, we get our intercept $hat(alpha) = 3.2925$
    `alphahat = ybar - betahat * xbar`.
    Thus, our best fit line is $y = 3.2925 + 0.1074821 x$ (where $y = "strength"$ and $x = "MOE"$).
  ]
  + #[
    The slope is in units of MPa per GPa, and it is (on average) how much the flexural strength of a concrete beam increases (in MPa) if the modulus of elasticity increases by 1 GPa.
  ]
  + #[
    At a modulus of elasticity of $x=39.0$ MPa, our model $y=3.2925+0.1074821x$ predicts that our flexural strength would be $y=7.5$ GPa.
    `alphahat + betahat * 39  # 7.484304`
  ]
  + #[
    The sum squared error (SSE, SSResid) is given by $ 
      "SSE" &= sum_(i=1)^n (y_i - hat(alpha) - hat(beta) x_i)^2 \
      &= sum_(i=1)^n [y_i^2 -hat(alpha) y_i - hat(beta) x_i y_i- hat(alpha) y_i+hat(alpha)^2+hat(alpha)hat(beta)x_i-hat(beta)x_i y_i+hat(alpha)hat(beta)x_i+hat(beta)^2x_i^2] \
      &= n [overline(y^2) - hat(alpha) dot overline(y) - hat(beta) dot overline(x y)-hat(alpha)overline(y) +hat(alpha)^2+hat(alpha)hat(beta) dot overline(x)-hat(beta) dot overline(x y) + hat(alpha)hat(beta) dot overline(x)+hat(beta)^2 overline(x^2) \
      &= n [overline(y^2) -2 hat(alpha) dot overline(y) - 2hat(beta) dot overline(x y) + hat(alpha)^2 + 2hat(alpha)hat(beta)dot overline(x)+hat(beta)^2 overline(x^2)]
    $
    Plugging in our values for these quantities (with $n = 27$), we get $"SSE" = 18.7356$. `27*(y2bar - 2*alphahat*ybar - 2*betahat*xybar + alphahat^2 + 2*alphahat*betahat*xbar + betahat^2*x2bar)`
  ]
]


= Wed - Feb 4
+ #[
  hw_lect13_1: 
  + #[ Sample variance is $s_y^2 = 1/(n-1) sum_(i=1)^n (y_i - overline(y))^2$. We have $"SST" = sum_(i=1)^n (y_i - overline(y))^2 = s_(y y)$. Thus, we have $ "SST" = (n-1) s_y^2 = s_(y y). $]
  + #[
  We can consider the sample variance for $hat(y)_i$ by defining $s_hat(y)^2 = 1/(n-1) sum_(i=1)^n (hat(y)_i - overline(hat(y)))^2$. However, we have that $overline(hat(y)) = overline(y)$, so with $hat(y)_i = hat(alpha)+hat(beta)x_i$, we have$ s_hat(y)^2 = 1/(n-1) sum_(i=1)^n (hat(y)_i - overline(y))^2. $
  // #box([_Actually I'm not sure if it's supposed to be $n-1$ or $n-2$, but I'm rolling with this._], fill: red.lighten(70%), inset: 0.1em)
  ]
  + #[
    This variance we have defined is exactly $ s_hat(y)^2 = 1/(n-1) "SS"_"explained". $
  ]
]
+ #[
  hw_lect13_2:
  ```R
  x <- c(45, 58, 71, 71, 85, 98, 108)
  y <- c(3.20, 3.40, 3.47, 3.55, 3.60, 3.70, 3.80)
  xbar <- mean(x)
  ybar <- mean(y)
  x2bar <- mean(x * x)
  xybar <- mean(x * y)
  ```
  + #[
    For an OLS fit, we have 
    $
      hat(beta) = (overline(x y) - overline(x) dot overline(y))/(overline(x^2) - [overline(x)]^2) #h(5em) hat(alpha) = overline(y) - hat(beta) dot overline(x)
    $
    Computing these values and plugging in, we get $hat(beta)=0.008821631$ and $hat(alpha) = 2.855944$ for $hat(y) = hat(alpha) + hat(beta) x$.
    ```R
    bhat <- (xybar - xbar * ybar) / (x2bar - xbar * xbar)
    ahat <- ybar - bhat * xbar
    ```
  ]
  + #[
    $"SST" = sum_(i=1)^n (y_i - overline(y))^2 = 0.2364857$ by `sst <- sum((y - ybar)^2)`.
  ]
  + #[     ```R
    yhat <- ahat + bhat * 
    sse <- sum((y - yhat)^2)
    ssexpl <- sst - sse
    ```
    $
    "SST" &= "SS"_"expl" + "SSE" \
      &= sum_(i=1)^n (hat(y)_i - overline(y))^2 + sum_(i=1)^n (y_i - hat(y)_i)^2
    $
    We have $"SSE" = 0.009114473$ and $"SS"_"expl" = "SST" - "SSE" = 0.2273712$.
  ]
  + #[ We have `R2 <- ssexpl / sst`, or $R^2 = 0.9614587$. This means that about 96% of the variance in $y$ can be explained by the variance of $x$, i.e. 96% of the variance of $y$ is explained by a linear dependence on $x$.
  ]
  + #[
    We have $n=7$ datapoints, so $s_e = sqrt(1/(n-2) "SSE") = 0.04269537$. `se <- sqrt(sse / 5)`. This means that on average, our prediction for $y$ based on the value of $x$ is about $0.0427$ off from the true value of $y$ (this is the typical error).
  ]
]
+ #[
  hw_lect13_3: 
  ```R
  dat <- read.csv("dataset.csv", header=T)
  linelen <- dat$linelen
  whitespace <- dat$whitespace
  model <- lm(linelen ~ whitespace)
  ```

  + #[
    `model$coefficients`: $hat(alpha) = 16.18984$, $hat(beta) = 70.34793$. For every 100% that the whitespace content of a file increases, the average line length increases by 70.3 characters on average (or, for every 1% increase in whitespace content we expect a 0.7 character increase in average line length). At 0% whitespace content, we would expect an average line length of 16 characters. 
  ]
  + #[
    ```R
    plot(linelen ~ whitespace)
    abline(16.18984, 70.34793, col="red")
    ```
    #figure(image("img/hw5_linscat.svg", width: 50%))
  ]
  + #[
    `cor(linelen, whitespace)^2` or `summary(model)$r.squared`: $R^2 = 0.1778623$. Only about 17.8% of the variance in average line length can be predicted by a linear dependence on the whitespace content of the file. Our model is not great, and as mentioned last time with the qq plots, in reality it might actually be worse because it looks like our data consists of two distinct clusters.
  ]
  + #[
    `sqrt(sum((linelen - model$fitted.values)^2) / (length(linelen) - 2))` or `model$sigma`: $s_e = 7.629886$. On average, our prediction for the line length based (linearly) on whitespace content is off by 7.6 characters (this is our typical error).
  ]
  + #[
    It does not look like transforming the data or doing a multiple regression will help. The primary problem is the width/blobbiness-- it's that we don't have much of a relationship between whitespace and line length to begin with, not that this relationship is nonlinear. Also, as mentioned, neither transforming the data nor doing fancier regression solves the problem of our two distinct clusters.
  ]
]

= Fri - Feb 6
+ #[
  hw_lect_14_1: Consider the model $y_i = alpha + beta x_(1 i) x_(2 i) + epsilon_i$. We minimize $"SSE" = sum_(i=1)^n epsilon_i^2$ w.r.t. $alpha$ and $beta$ by setting $nabla_(alpha, beta) "SSE" = 0$:
  $
    0 &=(partial)/(partial alpha) "SSE" = partial/(partial alpha) sum_(i=1)^n (y_i - alpha - beta x_(1 i) x_(2 i))^2 \
    &= sum_(i=1)^n 2(y_i- alpha -beta x_(1 i) x_(2 i))dot (-1) \
    &= 2n 1/n sum_(i=1)^n [alpha- y_i+beta x_(1 i) x_(2 i)] \
    &= 2 n [alpha+beta dot overline(x_(1) x_(2)) - overline(y)]
  $

  $
    0 &= partial / (partial beta) "SSE" = partial/(partial beta) sum_(i=1)^n (y_i - alpha - beta x_(1 i) x_(2 i))^2 \
    &= sum_(i=1)^n 2(y_i-alpha-beta x_(1 i) x_(2 i))(-x_(1 i) x_(2 i)) \
    &= 2n 1/n sum_(i=1)^n (-x_(1 i) x_(2 i) y_i + alpha x_(1 i) x_(2 i) + beta x_(1 i)^2 x_(2 i)^2) \
    &= 2n[alpha #h(0.15em) overline(x_1 x_2) + beta #h(0.15em) overline(x_1^2 x_2^2) - overline(x_1 x_2 y)]
  $
  $
    therefore 0 = alpha + beta#h(0.15em)overline(x_1 x_2)- overline(y) = alpha#h(0.15em)overline(x_1 x_2) + beta #h(0.15em) overline(x_1^2 x_2^2) - overline(x_1 x_2 y).
  $
]
+ #[
  hw_lect14_2:
  #figure(image("img/hw5_vis.png"))
  + #[In green]
  + In blue
  + In cyan
  + In red
]
+ #[
  hw_lect14_3: Data in `hw5_dat.txt`
  ```
  Obs Depth Content Strength
  1 8.9 31.5 14.7
  2 36.6 27.0 48.0
  3 36.8 25.9 25.6
  4 6.1 39.1 10.0
  5 6.9 39.2 16.0
  6 6.9 38.3 16.8
  7 7.3 33.9 20.7
  8 8.4 33.8 38.8
  9 6.5 27.9 16.9
  10 8.0 33.1 27.0
  11 4.5 26.3 16.0
  12 9.9 37.0 24.9
  13 2.9 34.6 7.3
  14 2.0 36.4 12.8
  ```

  ```R
  data <- read.table("hw5_data.txt", header=T)
  y <- data$Strength # kPa shear strength of sandy soil
  x1 <- data$Depth # m depth
  x2 <- data$Content # % water content
  x3 <- x1^2
  x4 <- x2^2
  x5 <- x1 * x2
  model <- lm(y ~ x1 + x2 + I(x1^2) + I(x2^2) + x1:x2)
  ```
  + #[
    $
      hat(y) = -140.22976 - 16.47521 x_1 + 12.82710 x_2 + 0.09555 x_1^2 -0.24339 x_2^2 + 0.49864 x_1 x_2
    $
  ]
  + #[
    These regression coefficients are not easily interpretable as the predictors are deeply interdependent/collinear. For example, we _cannot_ say that for every 1 unit increase in $x_1$, we expect $y$ to decrease by $16.48$ as that is only true when all other predictors remain constant, which is impossible as $x_1^2$ and $x_1 x_2$ explicitly depend on $x_1$ (i.e. we do not have that $("d"y) / ("d"x_1) = -16.48$ as we need to consider the chain rule with the other predictors).
  ]
  + #[
    `summary(model)$r.squared`: $R^2 = 0.7561284$. This says that about 76% of the variance in $y$ (shear strength) can be explained by a linear dependence on the terms we have: depth, percentage water content, the square of each, and the interaction term.
  ]
  + #[
    `summary(model)$sigma`: $s_e = 7.02349$. The typical deviation between our prediction using the model and the true value is about 7.023.
  ]
  + #[
    `plot(model$residuals ~ model$fitted.values)`. There does not appear to be a correlation, which is to be expected by construction of the model as if there were a correlation, that indicates that we could've picked better parameters to minimize SSE.
    #figure(image("img/hw5_residplot.svg", width: 50%))
  ]
  + #[
    `model2 <- lm(y ~ x1 + x2)`: $hat(y) = 14.8893 + 0.6607 x_1 -0.0284 x_2$.
  ]
  + #[
    `summary(model2)$r.squared`: $R^2 = 0.4470343$. This says that around 45% of the variance in $y$ can be explained purely from a linear dependence on $x_1$ and $x_2$, without any of the interaction or square terms.
  ]
  + #[
    Whereas with the square and interaction terms, we could explain about 76% of the variance, with only the linear terms we can only explain 45%. The higher order terms nearly doubled the amount of variance in $y$ that we could explain with our model, so yes, the higher order terms do provide useful information about shear strength.
  ]
]

+ #[
  Bonus content.
  + #[```R dat <- read.table("https://sites.stat.washington.edu/marzban/390/stuff/transform_dat.txt", header=T)```]
  + #[`plot(dat$y ~ dat$x)`
  #figure(image("img/hw5_bonus.svg", width: 50%))
  ]
  + #[
    `yprime <- dat$y^3` (this seems to give a better $R^2$ than $y^2$).
  ]
  + #[
    `mod3 <- lm(dat$y^3 ~ dat$x)`: $hat(y)^3 = 86.97 + 5619.69 x$.
  ]
  + #[
    ```R 
    plot(dat$y^3 ~ dat$x)
    abline(86.97, 5619.69, col="red")
    ```
    #figure(image("img/hw5_bonusab.svg", width: 50%))
  ]
  + #[
    `summary(mod3)$sigma`: $s_e = 15.26818$. Typical error in the prediction of $y^3$. \
    `summary(mod3)$r.squared`: $R^2 = 0.9890271$. This means 99% of the variation in $y^3$ can be explained by a linear dependence on $x$.
  ]
]