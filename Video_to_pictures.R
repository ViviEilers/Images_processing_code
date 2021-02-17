# Video to pictures

# 1- Creating the folders to store the output ####

# folder "images"
dir.create("C:/Users/Vivianne Eilers/Dropbox/Vivianne/Doutorado/Uni documents/Fieldwork Scotland/Videos/Processed_videos/Field_2/Images")

# cam names and dates
cam_names<-c("Bresil_1_CAM1", "Bresil_1_CAM2", "Bresil_1_CAM3", "Bresil_1_CAM4", "Bresil_2_CAM1", "Bresil_2_CAM2", "Bresil_2_CAM3", "Bresil_2_CAM4")
dates_names<-c("2020-11-26", "2020-11-27", "2020-12-01", "2020-12-03")

# loop to create folders with cam_names
for (a in 1 : length(cam_names)){
  
  dir.create(paste0("C:/Users/Vivianne Eilers/Dropbox/Vivianne/Doutorado/Uni documents/Fieldwork Scotland/Videos/Processed_videos/Field_2/Images/",      cam_names[a]))
  
  # loop to creating folder dates inside cam_names
  for(b in 1:length(dates_names)) {
    
    dir.create(paste0("C:/Users/Vivianne Eilers/Dropbox/Vivianne/Doutorado/Uni documents/Fieldwork Scotland/Videos/Processed_videos/Field_2/Images/",     paste(cam_names[a], dates_names[b], sep="/")))
    
  }
}


# Converting video to pictures

install.packages("av")
library(av)

install.packages("fs")
library(fs)

folders_all<-list.files("C:/Users/Vivianne Eilers/Dropbox/Vivianne/Doutorado/Uni documents/Fieldwork Scotland/Videos/Processed_videos/Field_2")

for (z in 1:length(folders_all)){
  path1<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne", "Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2", folders_all[z])
  folders_cam<-list.files(path1)
  
  for (i in 1:length(folders_cam)){
    cam_path<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne","Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2", folders_all[z], folders_cam[i])
    videos<-list.files(cam_path, pattern = "\\.avi$")  
    
    for (j in 1:length(videos)){
      outdir<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne", "Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2", "Images",folders_all[z],folders_cam[i],videos[j])
      indir<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne", "Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2",folders_all[z],folders_cam[i], videos[j])
      av_video_images(indir,destdir = outdir,format = "png", fps=5)   
      
    }
  }
}    

# The folder "Bresil_2_CAM4/2020-12-01" is empty, so the code stops
# There is only one folder letf, so I decided to use another code for that

last_folder<-list.files("C:/Users/Vivianne Eilers/Dropbox/Vivianne/Doutorado/Uni documents/Fieldwork Scotland/Videos/Processed_videos/Field_2/Bresil_2_CAM4/2020-12-03")

for (i in 1:length(last_folder)){
  
  last_outdir<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne", "Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2", "Images", "Bresil_2_CAM4", "2020-12-03")
  last_videos<-list.files(last_outdir, pattern="\\.avi$")
  last_indir<-path("C:","Users","Vivianne Eilers","Dropbox","Vivianne", "Doutorado", "Uni documents", "Fieldwork Scotland", "Videos", "Processed_videos", "Field_2", "Bresil_2_CAM4", "2020-12-03", last_folder[i])
  
  av_video_images(last_indir, destdir = last_outdir, format = "png", fps=5)   
}



