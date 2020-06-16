class Cubes {
  // Starting Position of shapes
  float startingZ = -10000;

  // Max range of how far can it reach
  float maxZ = 1000;

  // Values of Positions
  float x, y, z;

  // Rotational values
  float rotateX, rotateY, rotateZ;
  float sumRotX, sumRotY, sumRotZ;

  // Constructor
  Cubes() {
    // Starting position
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);

    // Rotation
    rotateX = random(0, 1);
    rotateY = random(0, 1);
    rotateZ = random(0, 1);
  }

  // This is essentially creating a method
  // Method to display the shapes
  // Does take in a lot of fields
  void display(float sL, float sM, float sH, float intense, float sG) {
    // Set the colors for the shapes when music is playing!
    // Value follows RGBA format
    color disColor = color(sL * .9, sM * 2, sH * 4, intense * 0.67);
    fill(disColor);
    
    // Stroke lines
    // When there isn't music playing, show white lines
    //  Otherwise, they disappear with the intensity of the song
    color stroke = color(255, 150 - (20 * intense));
    stroke(stroke);
    strokeWeight(1 + (sG / 300));

    pushMatrix();

    // Move it to where it needs to be
    translate(x, y, z);

    // Rotate the shapes based on the intensity of the songs
    sumRotX += intense * (rotateX) / 50;
    sumRotY += intense * (rotateY) / 50;
    sumRotZ += intense * (rotateZ) / 50;

    // Apply the rotation effect!
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    fill(disColor);
    
    // Cube dimensions
    box(75 +(intense / 2));
    
    popMatrix();
    
    // Z positioning
    z += (1 + intense / 10) + (pow((sG / 150), 2));
    
    // Replaces shape back to canvas once it travels out of view
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}
