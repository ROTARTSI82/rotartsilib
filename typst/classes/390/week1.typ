#import "/typst/misc/template.typ": *

#show: hw.with(title: "Week 1", class: "STAT 390 AB")

= Monday - #date(1, 5)


#figure(image("img/normdist.webp", width: 75%))

Width is about 5. 


= Wednesday - #date(1, 7)
+ #fbox[A] The data ("red, green, red, red, green, blue, green, blue") point to one random variable with three levels.
+ #[
    + Continuous random variables: speed of a baseball pitch, height of a building. 
    + Discrete random variables: Number of products in a store, number of times someone has said 'um' in a speech.
    + Categorical random variables: The country in which a product was manufactured, the composer of a piece of music.]
+ #[ For my dataset, I chose to compute some statistics for files in the source code of the Linux kernel. Each case in my dataset corresponds to one file in the `torvalds/linux` Git repository at #link("https://github.com/torvalds/linux/commit/9c7ef209cd0f7c1a92ed61eed3e835d6e4abc66c", [commit `9c7ef209cd0f`]). For my two discrete random variables I computed the season in which the file was last modified (4 levels: winter, spring, summer, autumn) and the file type (5 levels: C source code, C header, Rust code, assembly code, and Python code). For my continuous variables, I computed the percentage of whitespace characters in the file and the average line length in characters. The dataset contains 64703 cases. See the appendix for further details to reproduce this dataset.

#v(19em)

 + Random sample of 30 cases: #table(columns: 4, [*Type*], [*Season*], [*Whitespace*], [*Line Length*],
	[header],[autumn],[0.1212],[22.00],
	[source],[summer],[0.1715],[23.26],
	[header],[summer],[0.1597],[30.00],
	[source],[autumn],[0.1630],[29.21],
	[header],[autumn],[0.2190],[28.64],
	[source],[autumn],[0.1692],[27.70],
	[source],[autumn],[0.1790],[31.10],
	[source],[autumn],[0.1518],[24.38],
	[source],[autumn],[0.1922],[34.05],
	[source],[winter],[0.1756],[26.34],
	[header],[winter],[0.1198],[27.62],
	[source],[autumn],[0.1419],[21.65],
	[header],[autumn],[0.1626],[28.57],
	[header],[winter],[0.1558],[43.56],
	[source],[summer],[0.2457],[22.33],
	[source],[spring],[0.1521],[27.84],
	[header],[winter],[0.2509],[23.43],
	[header],[autumn],[0.1701],[19.28],
	[source],[autumn],[0.1524],[30.30],
	[header],[summer],[0.1684],[22.30],
	[source],[winter],[0.1934],[23.95],
	[source],[summer],[0.1810],[21.37],
	[source],[summer],[0.2031],[27.68],
	[source],[autumn],[0.1695],[24.48],
	[source],[spring],[0.1567],[27.95],
	[source],[summer],[0.2464],[24.50],
	[header],[summer],[0.1050],[32.97],
	[header],[spring],[0.1307],[34.52],
	[header],[winter],[0.1837],[25.73],
	[source],[autumn],[0.1503],[32.45],
)

 + #[ #figure(image("img/linuxdataset.svg"))
    ```r
    dat <- read.csv("dataset.csv", header=T)
    svg(filename='out.svg')
    par(mfrow=c(2,2))
    hist(dat$linelen, breaks=60)
    hist(dat$whitespace, breaks=30)
    plot(as.factor(dat$season))
    plot(as.factor(dat$type))
    dev.off()
    ```
 ]
]

= Friday - #date(1, 9)

+ hw_lect3_1
    + bell: the price of a base Ford F-150. Most sales will happen at around MSRP, but there will be some variance either up or down depending on the specific dealer.
    + skewed: lifetime number of flights taken. This variable is bounded on one side but not really bounded on the other (at minimum you have taken 0 flights, but there's not really a firm upper limit). Most people will only fly occasionally, but one can find rare cases of people who fly an unusual amount (maybe they have a private jet or a job that requires a lot of travelling), so there is a long tail.
    + exponential-looking: the time a uranium atom takes to decay. Radioactive decay should be a Poisson process and produce an exponential-looking histogram, as at each moment in time the probability of decay is the same and independent of how much time has already passed. We expect an exponential half-life law, where there is a 50% chance of decaying within any given interval of that length. Most atoms will decay very quickly, and fewer and fewer atoms take a long time to decay, falling off exponentially.
    + bimodal: The weight of a car. Different car types will have different weight ranges: you might expect a cluster of heavier SUVs and another cluster of lighter sedans.
+ #[
    ```r 
    x <- c(28.1, 31.2, 13.7, 46.0, 25.8, 16.8, 34.8, 62.3,
           28.0, 17.9, 19.5, 21.1, 31.9, 28.9, 60.1, 23.7,
           18.6, 21.4, 26.6, 26.2, 32.0, 43.5, 17.4, 38.8,
           30.6, 55.6, 25.5, 52.1, 21.0, 22.3, 15.5, 36.3,
           19.1, 38.4, 72.8, 48.9, 21.4, 20.7, 57.3, 40.9)

    svg(file="out1.svg")
    hist(x, breaks=seq(0, 80, 10))
    dev.off()

    svg(file="out2.svg")
    hist(log10(x), breaks=seq(1,2,0.1))
    dev.off()
    ```]
    + #figure(image("img/hw1_1.svg", width: 75%))
    + #figure(image("img/hw1_2.svg", width: 75%))
    + This transformation has taken an exponential-looking histogram to more of a bell-shaped one. This makes sense as $log$ is the inverse of an exponential.

+ #[To show that the normal distribution is a distribution, we need to show that the probability density function integrates to 1 and is non-negative for all $x$. Our density function is
$ f(x) = 1/sqrt(2 pi sigma^2) e^(-1/(2 sigma^2) (x-mu)^2). $
By inspection, the function is a positive multiple of an exponential, so $forall x, f(x) >= 0$, and in fact $forall x, f(x) > 0$. Next, we can compute the integral by u-substitution with $u = (x - mu) / (sigma sqrt(2))$,
$ 
    integral_(-infty)^infty f(x) "d"x &= 1/sqrt(2 pi sigma^2) integral_(-infty)^infty e^(-1/(2 sigma^2) (x-mu)^2)"d"x \
    &= 1/sqrt(2 pi sigma^2) sigma sqrt(2) integral_(-infty)^infty e^(-u^2)"d"u
$

Now the integral is simply the Gaussian integral, and we know $integral_(-infty)^infty e^(-u^2)"d"u=sqrt(pi)$.#footnote[Derivation: Let $I = integral_(-infty)^infty e^(-x^2)"d"x.$ Then 
$
 I^2 &= integral_(-infty)^infty e^(-x^2)"d"x integral_(-infty)^infty e^(-y^2)"d"y = integral_(-infty)^infty integral_(-infty)^infty e^(-x^2-y^2)"d"x"d"y \ &= integral_0^(2pi) integral_0^infty e^(-r^2) r"d"r"d"theta = 2 pi integral_0^infty e^(-r^2)"d"r =-pi integral_0^infty e^u"d"u #h(2em) (u=-r^2).
$
Thus, $I^2 = -pi(0-1) = pi$ and since $forall x, e^(-x^2)>0$, we have $I>0$. Therefore, $I = sqrt(pi).$ $qed$
 ] Thus:

$ 
    integral_(-infty)^infty f(x) "d"x &= 1/sqrt(2 pi sigma^2) sigma sqrt(2 pi) = 1. " " qed
$

]




#newpage()
= Appendix - Dataset Reproduction
```sh
git clone git@github.com:torvalds/linux.git
cd linux/
git checkout 9c7ef209cd0f7c1a92ed61eed3e835d6e4abc66c

# awk script written with help from Gemini
git log --name-only --format="COMMIT %ai" | awk '
  /^COMMIT/ {date=$2} 
  /^[^\t]/ && !/^COMMIT/ {if (!seen[$0]) {print date, $0; seen[$0]=1}}
' | tee log.log

# move gendataset.py into the directory and run it:
python3 gendataset.py
```

Code for `gendataset.py`:
```python
import glob
import json

rawset = dict()
with open('log.log', 'r') as fp:
    lines = fp.readlines()
    for l in lines:
        if not l:
            continue
        dat = l.split(' ')
        rawset[dat[1].strip()] = {'modified': dat[0]}

rust = glob.glob('**/*.rs', recursive=True)
source = glob.glob('**/*.c', recursive=True)
header = glob.glob('**/*.h', recursive=True)
asm = glob.glob('**/*.S', recursive=True)
py = glob.glob('**/*.py', recursive=True)

stuff = [rust, source, header, asm, py]
labels = ["rust", "source", "header", "asm", "py"]

for i, typ in enumerate(stuff):
    print(f"{labels[i]} - {len(typ)}")
    for fname in typ:
        if fname not in rawset:
            continue
        print(fname)
        rawset[fname]['type'] = labels[i]
        with open(fname, 'r') as fp:
            rawset[fname]['content'] = fp.read()

cleandat = dict()
csvout = "type,season,whitespace,linelen\n"
for name, dat in rawset.items():
    print(name)
    if 'content' not in dat:
        continue

    lines = len(dat['content'].split('\n'))
    contlen = len(dat['content'])
    chars = len("".join(dat['content'].split()))

    if contlen <= 0:
        continue

    mon = int(dat['modified'].split('-')[1])

    season = "winter"
    if 3 <= mon <= 5:
        season = 'spring'
    elif 6 <= mon <= 8:
        season = 'summer'
    elif 9 <= mon <= 11:
        season = "autumn"

    d = cleandat[name] = {
        'type': dat['type'],
        'whitespace': 1 - chars/contlen,
        'linelen': contlen / lines,
        'season': season
    }
    csvout += f"{d['type']},{d['season']},{d['whitespace']},{d['linelen']}\n"

with open('dataset.json', 'w') as fp:
    json.dump(cleandat, fp)
with open("dataset.csv", "w") as fp:
    fp.write(csvout)
```



```python
import random, json

with open('dataset.json', 'r') as fp:
    datset = [i for i in json.loads(fp.read()).items()]
random.shuffle(dataset)

print("#table(columns: 4, [*Type*], [*Season*], [*Whitespace*], [*Line Length*], ")
for name, row in dataset[:30]:
    print(f"\t[{row['type']}],[{row['season']}],[{row['whitespace']:.4f}],[{row['linelen']:.2f}],")
print(")")
```