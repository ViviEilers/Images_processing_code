# Image selection

# 2 - Selecting images with yellow circle in the area of the cables ####

install.packages('raster')
library(raster)
library(rgdal)

setwd( "C:/Users/Vivianne Eilers/Dropbox/Videos_Scotland")

# create list of files names in folder (pictures to be selected from)
folders<-unique(dirname(list.files(rec=T)))

# coordinates to crop the images according to camera name
Cam_coordinates<-read.csv("../Cam_crop.csv")

# create a data frame to store the output of images selected
selection.folders<-data.frame()

# create a buffer to use around rgb ranges
buff<-10 


# create dataframe with file names and keep "yes" or "no"
for (z in 1:length(folders)){
  
  files<- list.files(folders[z]) 
  selection<-as.data.frame(files) 
  selection$keep<-NA
  selection$folder<-folders[z] 
  selection$position.x<-NA
  selection$position.y<-NA

  # loop going through all files listed in the dataframe  
  for (i in 1:dim(selection)[1]){ 
    
    par(mfrow=c(2,2))
    test.raster<-stack(paste(folders[z], selection[i,"files"],sep="/")) # upload file
    
    names(test.raster)<-c('r','g','b')
    
    plotRGB(test.raster) # plot original file
    
    yellow.pixel<-crop(test.raster,extent(34,35,1014,1015))
    plotRGB(yellow.pixel)
    RGB.values<-yellow.pixel@data@values
    crop_limits<-unlist(Cam_coordinates[Cam_coordinates$folder==folders[z],][,c("xmin","xmax","ymin","ymax")])
    
    for (n in 1: dim(Cam_coordinates)[1]){
      if(grepl(Cam_coordinates[n,"folder"],folders[z])) break else next
    }
    
    crop_limits<-unlist(Cam_coordinates[n,c("xmin","xmax","ymin","ymax")])
    
    test.yellow<-crop(test.raster,extent(crop_limits)) 
    
    plotRGB(test.yellow) # plot cropped file
    
    test.yellow$Yellow_spots<-0 # create vector that will be 1 if yellow spot is detected in the cropped image
    
    test.yellow$Yellow_spots[test.yellow$r %in% seq(RGB.values[,"r"]-buff,RGB.values[,"r"]+buff) & 
                               test.yellow$g %in% seq(RGB.values[,"g"]-buff,RGB.values[,"g"]+buff) & 
                               test.yellow$b %in% seq(RGB.values[,"b"]-buff,RGB.values[,"b"]+buff)]<-1
    
    plot(test.yellow$Yellow_spots)
    
    if (sum(test.yellow$Yellow_spots[test.yellow$r %in% seq(RGB.values[,"r"]-buff,RGB.values[,"r"]+buff) & 
                                     test.yellow$g %in% seq(RGB.values[,"g"]-buff,RGB.values[,"g"]+buff) & 
                                     test.yellow$b %in% seq(RGB.values[,"b"]-buff,RGB.values[,"b"]+buff)])>0) 
     
      selection[i,"keep"]<-"yes" else 
      selection[i,"keep"]<-"no" 
    
    if(selection[i,"keep"]=="yes"){
      
      par(mfrow=c(1,1))
      
      yellowdf<-as.data.frame(stack(test.yellow$Yellow_spots),xy=T)
      
      yellow.position<-yellowdf[yellowdf$Yellow_spots==1,]
      
      bird.position<-apply(yellow.position,2, mean)
      
      plot(yellow.position$x,yellow.position$y)
      points(bird.position["x"],bird.position["y"], col="red", pch=4, cex=3)
      
      selection[i,]$position.x<-bird.position["x"]
      selection[i,]$position.y<-bird.position["y"]
    }
    
    indicator<-selection[i, c("folder","files","keep")]
    colnames(indicator)<-NULL
    print(indicator)
    }
  
  selection.folders<- rbind(selection.folders, selection) 
  }

selection.folders # check which images were selected

write.csv(selection.folders [, c("folder","files","keep", "position.x", "position.y")], "C:/Users/Vivianne Eilers/Dropbox/Videos_Scotland/selection_results.csv")
