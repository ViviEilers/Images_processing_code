# Triangulation

# 8 - Calculating altitude and distance of the bird using paired images####
i<-1831 # Number of horizontal pixels in the image
fv<-103 # Degrees ofthe camera with field of view of 2.8 mm
  
# Horizontal degree of field of view divided by the number of horizontal pixels
pixel<-fv/i
# 1 pixel is 0.0015 degrees for a 2.8 mm camera

PB_C1_1<-1407 # Number of pixels from the top of the pylon to the bird
PB_C2_1<-750 # Number of pixels from the top of the pylon to the bird

# Angle between the bird and the top of the pylon

AB_C1_1<- PB_C1_1 * pixel # 79.15
AB_C2_1<- PB_C2_1 * pixel # 42.19 

# Convert degrees into radians
RB_C1_1<-AB_C1_1*pi/180 # 1.38
RB_C2_1<-AB_C2_1*pi/180 # 0.74

x.C2<- 29  # distance from B1 to B2
z.C2<- 1.9 # altitude of B2 in relation to B1

#Complementary angle between the bird and Cam 1 horizon
A_C1_1 <- AB_C1_1 + 9.95
A_C2_1 <- AB_C2_1 + 10.63

# Convert degrees into radians
R_C1_1<-A_C1_1*pi/180 # 1.55
R_C2_1<-A_C2_1*pi/180 # 0.92


######
# General formula for Calculating distance and altitude of the bird
Z.B1<- (x.C2 * tan(R_C1_1) * tan(R_C2_1) - z.C2 * tan(R_C1_1)) / (tan(R_C2_1) - tan(R_C1_1))
# Z.B1 = -29.51
X.B1<- (x.C2 * tan(R_C2_1) - z.C2) / (tan(R_C2_1) - tan(R_C1_1))
#  X.B1 = -6.54
######


