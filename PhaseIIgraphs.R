rm(list=ls())
#install.packages("ggplot2")
#install.packages("utils")
#install.packages("ggpubr")
#install.packages("tidyverse")
#install.packages("plyr")
#install.packages("ggsignif")
library("ggplot2")
library("utils")
library("ggpubr")
library("tidyverse")
library("plyr")
library("ggsignif")

# import data
setwd("C:/Users/mchar/OneDrive/Desktop/Data")
data <- read.csv("data.csv")
raw <- read.csv('rawdata.csv')
raw$Animal_ID <- as.factor(raw$Animal_ID)

# run stats
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

df_analyzed <- data_summary(raw, varname="Viability", 
                    groupnames=c("Tf", "Tr", "Animal_ID"))
# Convert dose to a factor variable
df_analyzed$Animal_ID=as.factor(df_analyzed$Animal_ID)
head(df_analyzed)




df1 <- df_analyzed
df2 <- df_analyzed
df1$Tr <- as.factor(df1$Tr)
df2$Tf <- as.factor(df2$Tf)
supp.labs <- c("0 minutes", "3 minutes", "5 minutes", "10 minutes", "20 minutes")
names(supp.labs) <- c("0", "3", "5", "10", "20")
df2 <- df2[-c(1,2),]
line_width=1
Rack <- ggplot(data=df1,aes(x=Tf,y=Viability, group=Animal_ID, color=Animal_ID, 
                            fill=Animal_ID)) +
  geom_point() +
  geom_errorbar(aes(ymin=Viability-sd, ymax=Viability+sd), width=0.7) +
  geom_line() + ylim(0,1) + 
  scale_color_manual(values =c("#0066CC", "#993399")) +
  xlab("Time Spent in Mr.Frosty (min)") +
  ylab("Viability") +
  geom_line(linewidth = line_width) + 
  theme_bw()+
  scale_x_continuous(breaks = seq(0, 20, 4)) +
  facet_grid(. ~ Tr,
             labeller = labeller(Tr = supp.labs))
Freezer <- ggplot(data=df2,aes(x=Tr,y=Viability, group=Animal_ID, color=Animal_ID, fill=Animal_ID)) +
  geom_point() +
  geom_errorbar(aes(ymin=Viability-sd, ymax=Viability+sd), width=0.7) +
  geom_line() + ylim(0,1) + 
  scale_color_manual(values =c("#0066CC", "#993399")) +
  xlab("Time Spent on rack (min)") +
  ylab("Viability") +
  geom_line(linewidth = line_width) +
  theme_bw()+
  scale_x_continuous(breaks = seq(0, 10, 2)) +
  facet_grid(. ~ Tf, labeller = labeller(Tf = supp.labs))
phaseII <- ggarrange( Rack, Freezer, nrow = 2)
phaseII
ggsave("PhaseIIPlots.tiff", plot = phaseII, dpi=1000, units="in", 
       width= 6, height= 5 )




lmPlot1a = lm(Viability~Tf, data = df1[df1$Animal_ID=="rhgb32" & df1$Tr=="0",]) #Create the linear regression
lmPlot2a = lm(Viability~Tf, data = df1[df1$Animal_ID=="rhgb32" & df1$Tr=="5",]) #Create the linear regression
lmPlot3a = lm(Viability~Tf, data = df1[df1$Animal_ID=="rhgb32" & df1$Tr=="10",]) #Create the linear regression
lmPlot4a = lm(Viability~Tr, data = df2[df2$Animal_ID=="rhgb32" & df2$Tf=="3",]) #Create the linear regression
lmPlot5a = lm(Viability~Tr, data = df2[df2$Animal_ID=="rhgb32" & df2$Tf=="10",]) #Create the linear regression
lmPlot6a = lm(Viability~Tr, data = df2[df2$Animal_ID=="rhgb32" & df2$Tf=="20",]) #Create the linear regression
lmPlot1b = lm(Viability~Tf, data = df1[df1$Animal_ID=="rh2489" & df1$Tr=="0",]) #Create the linear regression
lmPlot2b = lm(Viability~Tf, data = df1[df1$Animal_ID=="rh2489" & df1$Tr=="5",]) #Create the linear regression
lmPlot3b = lm(Viability~Tf, data = df1[df1$Animal_ID=="rh2489" & df1$Tr=="10",]) #Create the linear regression
lmPlot4b = lm(Viability~Tr, data = df2[df2$Animal_ID=="rh2489" & df2$Tf=="3",]) #Create the linear regression
lmPlot5b = lm(Viability~Tr, data = df2[df2$Animal_ID=="rh2489" & df2$Tf=="10",]) #Create the linear regression
lmPlot6b = lm(Viability~Tr, data = df2[df2$Animal_ID=="rh2489" & df2$Tf=="20",]) #Create the linear regression

stats1a <- as.data.frame(coef(summary(lmPlot1a))) 
stats2a <- as.data.frame(coef(summary(lmPlot2a)))
stats3a <- as.data.frame(coef(summary(lmPlot3a)))
stats4a <- as.data.frame(coef(summary(lmPlot4a)))
stats5a <- as.data.frame(coef(summary(lmPlot5a)))
stats6a <- as.data.frame(coef(summary(lmPlot6a)))
stats1b <- as.data.frame(coef(summary(lmPlot1b)))
stats2b <- as.data.frame(coef(summary(lmPlot2b)))
stats3b <- as.data.frame(coef(summary(lmPlot3b)))
stats4b <- as.data.frame(coef(summary(lmPlot4b)))
stats5b <- as.data.frame(coef(summary(lmPlot5b)))
stats6b <- as.data.frame(coef(summary(lmPlot6b)))

stats_pvalue1a <- stats1a$`Pr(>|t|)`[2]
stats_pvalue2a <- stats2a$`Pr(>|t|)`[2]
stats_pvalue3a <- stats3a$`Pr(>|t|)`[2]
stats_pvalue4a <- stats4a$`Pr(>|t|)`[2]
stats_pvalue5a <- stats5a$`Pr(>|t|)`[2]
stats_pvalue6a <- stats6a$`Pr(>|t|)`[2]
stats_pvalue1b <- stats1b$`Pr(>|t|)`[2]
stats_pvalue2b <- stats2b$`Pr(>|t|)`[2]
stats_pvalue3b <- stats3b$`Pr(>|t|)`[2]
stats_pvalue4b <- stats4b$`Pr(>|t|)`[2]
stats_pvalue5b <- stats5b$`Pr(>|t|)`[2]
stats_pvalue6b <- stats6b$`Pr(>|t|)`[2]

pvalue <- c(stats_pvalue1a,
            stats_pvalue2a,
            stats_pvalue3a,
            stats_pvalue4a,
            stats_pvalue5a,
            stats_pvalue6a,
            stats_pvalue1b,
            stats_pvalue2b,
            stats_pvalue3b,
            stats_pvalue4b,
            stats_pvalue5b,
            stats_pvalue6b)

stats_Slope1a <- stats1a$`Estimate`[2]
stats_Slope2a <- stats2a$`Estimate`[2]
stats_Slope3a <- stats3a$`Estimate`[2]
stats_Slope4a <- stats4a$`Estimate`[2]
stats_Slope5a <- stats5a$`Estimate`[2]
stats_Slope6a <- stats6a$`Estimate`[2]
stats_Slope1b <- stats1b$`Estimate`[2]
stats_Slope2b <- stats2b$`Estimate`[2]
stats_Slope3b <- stats3b$`Estimate`[2]
stats_Slope4b <- stats4b$`Estimate`[2]
stats_Slope5b <- stats5b$`Estimate`[2]
stats_Slope6b <- stats6b$`Estimate`[2]

Slope <- c(stats_Slope1a,
           stats_Slope2a,
           stats_Slope3a,
           stats_Slope4a,
           stats_Slope5a,
           stats_Slope6a,
           stats_Slope1b,
           stats_Slope2b,
           stats_Slope3b,
           stats_Slope4b,
           stats_Slope5b,
           stats_Slope6b)

animal <- c("rhgb32",
            "rhgb32",
            "rhgb32",
            "rhgb32",
            "rhgb32",
            "rhgb32",
            "rh2489",
            "rh2489",
            "rh2489",
            "rh2489",
            "rh2489",
            "rh2489")
plotn <- c(1, 2, 3, 4, 5, 6,
           1, 2, 3, 4, 5, 6)
df <- data.frame(animal, plotn, Slope, pvalue)
df$Significance <- ""
df$direction[df$Slope>0] <- "Pos"
df$direction[df$Slope<0] <- "Negative"
df$Significance <- ""
df$Significance[df$pvalue>0.05] <- "insig"
df$Significance[df$pvalue<=0.05] <- "Significant"

df
sort(df$pvalue)

stats_rack <- c(stats_pvalue1a, stats_pvalue2a, stats_pvalue3a, stats_pvalue1b, 
                stats_pvalue2b, stats_pvalue3b )