PImage [] allImage;
PImage daniela;
PImage smaller;

color[] colors; 

int scl = 10;
int mag = 100;
int w,h;

File[] listFiles(String dir) {
  
    File file = new File(dir);
    
    if (file.isDirectory()) {
      File[] files = file.listFiles();
      return files;
    }
    else {
      return null;
    }
  
}

void setup(){   
    
    size(18800,18800);
    
    daniela = loadImage("photomosiac.jpg");
    
    //set size of pixelated pictures
    w = daniela.width/scl;
    h = daniela.height/scl;
    
    smaller = createImage(w, h, RGB);
    smaller.copy(daniela, 0, 0,daniela.width,daniela.height, 0, 0, w, h);
    

}

void draw(){
  
    image(daniela,0,0,18800, 18800);
    smaller.loadPixels();
    
    //get the pictures data
    File[] files = listFiles(sketchPath("data"));
    
    
    int numOfPics = 150;
    allImage = new PImage[numOfPics];
    colors = new color[numOfPics];
      
    for(int i=0; i<numOfPics; i++){
      
        String fileName = files[i].toString();
        
        //store in array of images and then get the average color of the image
        allImage[i]=loadImage(fileName);
        colors[i] = getAverageColor(allImage[i]);  
        
    }
    //build the image 
    for(int x=0; x<w; x++){
      
         for(int y=0; y<h; y++){
           
             int index = x + y * w;
             int pixel = smaller.pixels[index];
             
             // get the pixel color
             int r = pixel>>16&0xFF;
             int g = pixel>>8&0xFF;
             int b = pixel&0xFF;
    
             color cPixel = color(r,g,b);
                
             int closer = 0;
          
             double cDistance = 999999999;
             //find smallest possible difference
             for(int i = 0; i < colors.length ; i++){
               //calculate the difference
                 double d = ColorDistance(cPixel, colors[i]);
                 
                    if(d < cDistance){
                        cDistance=d;
                        closer = i;
                    }
             }
    
                    image(allImage[closer], x*mag, y*mag, mag , mag);
                   tint(r,g,b);
          }
     }
     
     noLoop();
    save("GG");
}

 public color getAverageColor(PImage img) {
   
      img.loadPixels();
      double r = 0, g = 0, b = 0;
      
      //interate through each pixel and add the R G and B magnitude
      for (int i = 0; i < img.pixels.length ; i++) {
        
          int clr = img.pixels[i];
          r += clr>>16&0xFF;
          g += clr>>8&0xFF;
          b += clr&0xFF;
      }
      
      //divide the total numbers by the number of pixels
      r /= img.pixels.length;
      g /= img.pixels.length;
      b /= img.pixels.length;    
      
      return color((int)r,(int)g,(int)b);
}
     
public double ColorDistance(color c1, color c2){
  
        double rmean = (red(c1) + red(c2))/2;
        
        float r = red(c1)   - red(c2);
        float g = green(c1) - green(c2);
        float b = blue(c1)  - blue(c2);
        
        //algorithim to determin which image is closer to the color
        double weightR = 2 + rmean/256;
        double weightG = 4.0;
        double weightB = 2 + (255-rmean)/256;
        
        return Math.sqrt(weightR*r*r + weightG*g*g + weightB*b*b);
}
