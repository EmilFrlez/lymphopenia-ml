# plotting 1D histograms: age, lya.start, lya.decrease, rad dose
# plotting 2D histograms: lya.start vs lys.decrease, lya.start vs age
#                         lya.decrease vs age, lya.decrease vs rad dose

library(ggplot2)
library(ggthemes)

# input data file
clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
# check it out
print(head(clinical))

# age
pl1 <- ggplot(clinical, aes(x = age))
pl1 <- pl1 + geom_histogram(binwidth=2, color = 'black', fill = 'red', alpha = 0.4)
pl1 <- pl1 + theme_bw()
pl1 <- pl1 +
      labs(title="Clinical Variable: Patient Age", 
      subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/age.pdf")
print(pl1)
dev.off()

# lya.start
pl2 <- ggplot(clinical, aes(x = lya.start))
pl2 <- pl2 + geom_histogram(color = 'black', fill = 'red', alpha = 0.4)
pl2 <- pl2 + theme_bw()
pl2 <- pl2 +
  labs(title="Clinical Variable: Initial Lymphocyte Count", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/lya.start.pdf")
print(pl2)
dev.off()

# lya.decrease
pl3 <- ggplot(clinical, aes(x = lya.decrease))
pl3 <- pl3 + geom_histogram(color = 'black', fill = 'red', alpha = 0.4)
pl3 <- pl3 + theme_bw()
pl3 <- pl3 +
  labs(title="Clinical Variable: Final Lymphocyte Count", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/lya.decrease.pdf")
print(pl3)
dev.off()

# lya.decrease
pl4 <- ggplot(clinical, aes(x = Rx.tot))
pl4 <- pl4 + geom_histogram(binwidth=500,color = 'black', fill = 'red', alpha = 0.4)
pl4 <- pl4 + theme_bw()
pl4 <- pl4 +
  labs(title="RT: Total Radiation Dose (Gy)", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/Rx.tot.pdf")
print(pl4)
dev.off()
# lya.decrease
pl5 <- ggplot(clinical, aes(x = ptv.vol))
pl5 <- pl5 + geom_histogram(color = 'black', fill = 'red', alpha = 0.4)
pl5 <- pl5 + theme_bw()
pl5 <- pl5 +
  labs(title="Clinical Variable: Partial Tumor Volume", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/ptv.vol.pdf")
print(pl5)
dev.off()

# lya.decrease vs lya.start
pl6 <- ggplot(clinical, aes(x = lya.start, y = -lya.decrease))
pl6 <- pl6 + geom_point(color = 'red', alpha = 0.4)
pl6 <- pl6 + theme_bw() + geom_smooth( color = 'blue' )
pl6 <- pl6 +
  labs(title="Correlation: Initial Lymphocyte Count vs LYA Decrease", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/lya.change-2D.pdf")
print(pl6)
dev.off()

# lya.start vs age
pl7 <- ggplot(clinical, aes(x = age, y = lya.start))
pl7 <- pl7 + geom_point(color = 'red', alpha = 0.4)
pl7 <- pl7 + theme_bw() + geom_smooth(color = 'blue')
pl7 <- pl7 +
  labs(title="Lymphocyte Start Count Age", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/lya.start-age.pdf")
print(pl7)
dev.off()

# lya.decrease vs age
pl8 <- ggplot(clinical, aes(x = age, y = lya.decrease))
pl8 <- pl8 + geom_point(color = 'red', alpha = 0.4)
pl8 <- pl8 + theme_bw() + geom_smooth(color = 'blue')
pl8 <- pl8 +
  labs(title="Lymphocyte Count Decrease vs Age", 
       subtitle="86 Observations")
pdf("/home/ef2p/Kaggle/lymphopenia/figures/lya-change-age.pdf")
print(pl8)
dev.off()


