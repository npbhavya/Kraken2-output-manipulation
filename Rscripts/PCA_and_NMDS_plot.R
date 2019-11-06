library(devtools)
install_github("vqv/ggbiplot")
library(ggbiplot)

data=read.csv("kraken-report-family-col1-taxa.csv", header=TRUE, row.names = 1)
data_t=t(data)

data_matrix=as.matrix(data_t)
data_matrix_clean=data_matrix[,apply(data_matrix, 2,var, na.rm=TRUE)!=0]
#summary(data_matrix)
#summary(data_matrix_clean)

data.pca=prcomp(data_matrix_clean, center=TRUE, scale. = TRUE)
summary(data.pca)
View(data.pca)

ggbiplot(data.pca)
location=c("enter the factors here like locations")
ggbiplot(data.pca, varname.size = 0, ellipse = TRUE, groups = location  )


##NMDS
install.packages("vegan")
library(vegan)

d=vegdist(data_matrix, method="bray")
mds=metaMDS(d, distance = "bray", k=3, maxit=999, trymax=1000)
stressplot(mds)
plot(mds)  
#orditorp(mds, "sites")
#with(location, points(mds,display = "sites", col="black"))
ordihull(mds, location, display = "sites", draw=c("polygon"), col=NULL, border=c("blue", "red", "green", "orange", "yellow"), 
         lty = c(1, 2, 1, 2), lwd = 2.5, label = TRUE)

