#Importing the data 
data=read.csv("kraken-report-genus-col2-taxa.csv", header=TRUE, row.names = 1)
data_t=t(data)
data_matrix=as.matrix(data_t)

#data normalization using rarefaction method
data_t=as.data.frame(t(data))
S <- specnumber(data_t)
raremax <-min(rowSums(data_t))
Srare <- rrarefy(Data_t, raremax)

##PCA plots 
library(devtools)
#install_github("vqv/ggbiplot") #to install the ggbiplot
library(ggbiplot)

#step to remove the variables without a lot of variance 
Srare_clean=Srare[,apply(Srare, 2,var, na.rm=TRUE)!=0]

data.pca=prcomp(Srare_clean, center=TRUE, scale. = TRUE)
summary(data.pca)
#View(data.pca)

ggbiplot(data.pca)
#location=c("add in factors like environment etc here")
ggbiplot(data.pca, varname.size = 0, ellipse = TRUE, groups = location)


## NMDS plots 
#install.packages("vegan")
library(vegan)

d=vegdist(Srare, method="bray")
d_matrix=as.matrix(d, labels=T)
mds=metaMDS(d, distance = "bray", k=3) #k=number of dimensions
mds_data=as.data.frame(mds$points)
mds_data$SampleID =rownames(mds_data)

#one way to visaluze the MDS plots 
ggplot(mds_data, aes(x=MDS1, y=MDS2, color= location)) +geom_point()

#another way to visualize the MDS plots 
stressplot(mds)
plot(mds)  
ordihull(mds, location, display = "sites", draw=c("polygon"), col=NULL, border=c("blue", "red", "green", "orange", "yellow"), 
         lty = c(1, 2, 1, 2), lwd = 2.5, label = TRUE)

## Beta diversity index and PcoA plots 
## Calculate multivariate dispersions
mod_loc <- betadisper(d, location)
mod_water <- betadisper(d, water)

#Statistical test 
anova(mod_loc)
anova(mod_water)

## Permutation test for F
permutest(mod_loc, pairwise = TRUE, permutations = 99)
permutest(mod_water, pairwise = TRUE, permutations = 99)

#Post hoc Tukey HSD test 
(mod_loc.HSD <- TukeyHSD(mod_loc))
plot(mod_loc.HSD)

(mod_water.HSD <- TukeyHSD(mod_water))
plot(mod_water.HSD)

#Plot the groups and distances to centroids on the with data ellipses instead of hulls - PCoA plots 
plot(mod_loc, ellipse = TRUE, hull = FALSE) # 1 sd data ellipse
plot(mod_loc, ellipse = TRUE, hull = FALSE, conf = 0.90) # 90% data ellipse

plot(mod_water, ellipse = TRUE, hull = FALSE) # 1 sd data ellipse
plot(mod_water, ellipse = TRUE, hull = FALSE, conf = 0.90) # 90% data ellipse
