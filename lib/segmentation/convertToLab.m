function labImage = convertToLab(rgbImage)
cform = makecform('srgb2lab');
labImage = applycform(rgbImage, cform);