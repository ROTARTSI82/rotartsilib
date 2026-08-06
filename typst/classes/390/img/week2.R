x <- read.csv("dataset.csv", header=T)
svg("w2_boxplots.svg")
# from ?boxplot: we can plot using a formula too.
boxplot(whitespace ~ type, data = x)
dev.off()
