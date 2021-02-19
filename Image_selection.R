# Image selection

# 2 - Selecting images with yellow circle in the area of the cables ####

library(raster)
library(rgdal)
library(ggplot2)

setwd( "C:/Users/Vivianne Eilers/Dropbox/Videos_Scotland")

# create list of files names in folder (pictures to be selected from)
folders<-unique(dirname(list.files(rec=T)))

# coordinates to crop the images according to camera name
Cam_coordinates<-read.csv("../Cam_crop.csv")

# create a data frame to store the output of images selected
selection.folders<-data.frame()

# create a buffer to use around rgb ranges
buff<-10 

# number of pixels bewteen two birds
cluster.dist<-100 


# create dataframe with file names and keep "yes" or "no"
for (z in 1:length(folders)){
  
  files<- list.files(folders[z]) 
  selection<-as.data.frame(files) 
  selection$keep<-NA
  selection$folder<-folders[z] 
  selection$position.x<-NA
  selection$position.y<-NA
  selection$birdNo<-NA
  selection.i<-data.frame()

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
      
      d<-dist(yellow.position[,c("x","y")])
      
      hc<-hclust(d)
      
      yellow.position$cluster<-cutree(hc, h=cluster.dist)
      
      ggplot(yellow.position, aes(x,y, color=factor(cluster)))+
        geom_point()+ theme_classic()
      
      bird.position.x<-tapply(yellow.position$x,yellow.position$cluster, mean)
      bird.position.y<-tapply(yellow.position$y,yellow.position$cluster, mean)
      
      bird.position<-cbind(bird.position.x,bird.position.y)
      colnames(bird.position)<-c("x","y")
      
      plot(yellow.position$x,yellow.position$y)
      points(bird.position["x"],bird.position["y"], col="red", pch=4, cex=3)
      
      selection.temp<-data.frame()
      
      for (j in 1:dim(bird.position)[1]){
        selection[i,]$position.x<-bird.position[j,"x"]
        selection[i,]$position.y<-bird.position[j,"y"]
        selection[i,]$birdNo<-paste(j,dim(bird.position)[1], sep="/")
        selection.temp<-rbind(selection.temp,selection[i,])
        
      }
      
    } else selection.temp<-selection[i,]
    
    selection.i<-rbind(selection.i,selection.temp)
    
    indicator<-selection[i, c("folder","files","keep")]
    colnames(indicator)<-NULL
    print(indicator)
    }
  
  selection.folders<- rbind(selection.folders, selection.i) 
  }

selection.folders # check which images were selected

write.csv(selection.folders [, c("folder","files","keep", "position.x", "position.y", "birdNo")], "C:/Users/Vivianne Eilers/Dropbox/Videos_Scotland/selection_results.csv")
