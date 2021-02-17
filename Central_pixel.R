# Central pixel 

# 3 - Finding the central pixel of the yellow circle in the images####

install.packages("countcolors")
install.packages("colordistance")
install.packages("png")
library(countcolors)
library(colordistance)
library(png)


image<-readPNG("C:/Users/Vivianne Eilers/Dropbox/Videos_Scotland/Bresil_1_CAM1/2020-11-26/2020-11-26_10-10-18_Bresil-1_Cam1_record_1Det_18.avi/image_000018.png")

yellow.RGB<-c(0.93, 0.98, 0.12)

image.test<-sphericalRange(image, center=yellow.RGB, radius = 0.1, color.pixels = F, plotting=F); names(image.test)
image.test$img.fraction # fraction of the image covered 5.9%
image.test$pixel.id # list including row and column indices of pixels within the range
image.test$pixel.count # number of pixels within the range

changePixelColor(image,image.test$pixel.id, target.color = "magenta" )

# Image.hist<-getImageHist(image.test, bins=c(2, 2, 2), lower=c(0.9, 0.1), upper=c(0.95, 0,2))

