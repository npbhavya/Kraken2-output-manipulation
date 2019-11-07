library(vegan)

#importing the file and parsing the file correctly
# Replace the kraken_final name to the actual filename.
Data=read.table("kraken_report_all_R.csv", sep=",", row.names = 1, header=TRUE)
Data_t=as.data.frame(t(Data))

#count the number of species
S <- specnumber(Data_t)
raremax <-min(rowSums(Data_t))

#Rarefaction of the samples
Srare <- rarefy(Data_t, raremax)

#plotting the rarefaction curves
plot(S, Srare, xlab = "Observed No. of Species", ylab = "Rarefied No. of Species")
abline(0, 1)
pdf("Rarefaction_curve.pdf")
rarecurve(Data_t, step =20, sample = raremax, col = "blue", cex = 0.4, )
dev.off()

#PCA plots 
Data_add=cbind(Data_t,groups)
pca=rda(Data_t)
points(pca, display=c("sites"), pch=20, col=factor(Data_add$groups))

summary(pca)
biplot(pca, display=c("sites","species"), type=c("points"), xlab="PC1 (2.654508e+09%)", ylab="PC2 (1.748614e+09%)")
points(pca, display=c("sites"),pch=20, col=factor(Data_add$groups))

groupnames=levels(Data_add$groups)
legend("topright",
       col = factor(Data_add$groups),
       lty = 1,
       legend = groupnames)
