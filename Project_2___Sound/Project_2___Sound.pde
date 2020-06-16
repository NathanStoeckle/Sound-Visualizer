// Libraries
// I had to use Minim in order to get the code to work properly
import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
//import ddf.minim.spi.*;
//import ddf.minim.ugens.*;

// Global Variables - Fields
// Basic sound stuff
//[Band] bands;
Minim minim;
AudioPlayer song, song2, song3;
FFT fft;

// Variables that relate to the spectrum of the band
float specLow = 0.03;
float specMid = 0.125;
float specHi = .20;

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Value
float scoreDecreaseRate = 25;

// Cubes
int nbCubes;
Cubes[] cubes;

// Triangles
int nbTriangles;
Triangles[] triangles;

// Spheres
int nbSphere;
Sphere[] spheres;

// Boolean to change the song
boolean songPlay, song2Play, song3Play;

// Text for displaying!
String text1 = "Playing with spheres";
String text2 = "Playing with cubes";
String text3 = "Playing with triangles";

// Time function stuff
int holdSecond = second();
int lengthToShow = 10;  // How long does it take to show the text?

void setup() {
  // Play the song/video at full screen
  // IMPORTANT: Press Esc to end the program
  fullScreen(P3D);
  // Was trying to see if I could do it in a windowed screen... Was not possible
  //size(displayWidth, displayHeight, P3D);

  // Load the Minim library
  minim = new Minim(this);

  // Load the song from the folder
  song = minim.loadFile("media/Is It Like Today - Eliza Gilkyson.mp3");
  song2 = minim.loadFile("media/Hot Blooded - Foreigner.mp3");
  song3 = minim.loadFile("media/Losing My Religion - R.E.M..mp3");

  // Analyize the song via FFT
  // bufferSize - Internal buffer size of sound object
  // sampleRate - Returns the sample rate of the sound object
  fft = new FFT(song.bufferSize(), song.sampleRate());

  // Create cube based on frequency bands
  //  Basically, one cube per frequency band
  // specSize() -  Returns the number of frequency bands produced by this transform
  nbCubes = (int)(fft.specSize() * specHi);

  // Create an array based on the song bands
  cubes = new Cubes[nbCubes];

  // Create the actual cubes here
  for (int i = 0; i < nbCubes; i++) {
    cubes[i] = new Cubes();
  }

  // Create triangle based on frequency bands
  //  Basically, one triangle per frequency band
  nbTriangles = (int)(fft.specSize() * specHi);

  // Create an array based on the song bands
  triangles = new Triangles[nbTriangles];

  // Create the actual triangles here
  for (int i = 0; i < nbTriangles; i++) {
    triangles[i] = new Triangles();
  }

  // Create sphere based on frequency bands
  //  Basically, one sphere per frequency band
  nbSphere = (int)(fft.specSize() * specHi);

  // Create an array based on the song bands
  spheres = new Sphere[nbSphere];

  // Create the actual cubes here
  for (int i = 0; i < nbSphere; i++) {
    spheres[i] = new Sphere();
  }

  // Set the background as black
  background(0);

  // Play the chosen song
  // Moved this to mousePressed!
  //song.play();
}

void draw() {
  // This is needed to give the desire effect of color and shape manipulation
  if (songPlay) {
    fft.forward(song.mix);
  }
  if (song2Play) {
    fft.forward(song2.mix);
  }
  if (song3Play) {
    fft.forward(song3.mix);
  }

  // Values that have to be softed due to reduction
  float oldScoreLow = scoreLow;
  float oldScoreMid = scoreMid;
  float oldScoreHi = scoreHi;

  // Reset the original values to zero
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  // Calculate the new score
  for (int i = 0; i < fft.specSize() * specLow; i++) {
    scoreLow += fft.getBand(i);
  }

  for (int i = 0; i < fft.specSize() * specMid; i++) {
    scoreMid += fft.getBand(i);
  }

  for (int i = 0; i < fft.specSize() * specHi; i++) {
    scoreHi += fft.getBand(i);
  }

  // Expermenting with this, but it should slow the descent down
  // This forces the shapes to stay at a consistent speed instead
  //  of rapidly speeding up
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - 50;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - 50;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - 50;
  }

  // Manipulation of the shapes animation - Mainly speed
  float scoreGlobal = 0.33 * scoreLow + 0.4 * scoreMid + .5 * scoreHi;

  background(scoreLow / 500, scoreMid / 500, scoreHi / 500);

  // Key Press coding for specific shapes to be created
  if (keyCode != 't' || keyCode != 'T' || keyCode != 's' || keyCode != 'S' ||
    keyCode != 'c' || keyCode != 'C') {
    textSize(20);
    textAlign(CENTER);
    fill(255);
    text("Press C, S, or T to play this with shapes!" + 
      "\nPress 1, 2, or 3 to pause and play a song." +
      "\nPress the Up arrow key to increase audio," +
      "\nPress the Down arrow key to decrease audio.", 
      displayWidth / 2, displayHeight / 2);
  }
  // Spheres
  if (keyCode == 's' || keyCode == 'S') {
    background(scoreLow / 500, scoreMid / 500, scoreHi / 500);
    text("Press the Up arrow key to increase audio.", 250, 50);
    text("Press the Down arrow key to decrease audio.", displayWidth - 250, 50);
    for (int i = 0; i < nbSphere; i++)
    {
      float bandValue = fft.getBand(i);
      spheres[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
      textSize(20);
      textAlign(CENTER);
      text(text1, displayWidth / 2, displayHeight - 50);
    }
  }

  // Cubes
  if (keyCode == 'c' || keyCode == 'C') {
    background(scoreLow / 500, scoreMid / 500, scoreHi / 500);
    text("Press the Up arrow key to increase audio.", 250, 50);
    text("Press the Down arrow key to decrease audio.", displayWidth - 250, 50);
    for (int i = 0; i < nbCubes; i++)
    {
      textSize(20);
      textAlign(CENTER);
      text(text2, displayWidth / 2, displayHeight - 50);
      float bandValue = fft.getBand(i);
      cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
    }
  }

  // Triangles
  if (keyCode == 't' || keyCode == 'T') {
    background(scoreLow / 500, scoreMid / 500, scoreHi / 500);
    text("Press the Up arrow key to increase audio.", 250, 50);
    text("Press the Down arrow key to decrease audio.", displayWidth - 250, 50);
    for (int i = 0; i < nbTriangles; i++)
    {
      textSize(20);
      textAlign(CENTER);
      text(text3, displayWidth / 2, displayHeight - 50);
      float bandValue = fft.getBand(i);
      triangles[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
    }
  }

  // Adjust the audio for the player
  // Increase the audio - Probably never going to be touched
  //  The songs I used are loud when I used it for testing
  if (keyCode == UP) {
    song.shiftGain(song.getGain(), 10, 2500);
    song2.shiftGain(song.getGain(), 10, 2500);
    song3.shiftGain(song.getGain(), 10, 2500);
  }

  // Decrease the audio - Will be used often
  if (keyCode == DOWN) {
    song.shiftGain(song.getGain(), -10, 2500);
    song2.shiftGain(song.getGain(), -10, 2500);
    song3.shiftGain(song.getGain(), -10, 2500);
  }
}

void keyPressed() {
  if (keyCode == '1') {
    if (song.isPlaying()) {
      song.pause();
    } else {
      songPlay = true;
      song2Play = false;
      song3Play = false;
      song2.pause();
      song3.pause();
      song.rewind();
      song.play();
    }
  }

  if (keyCode == '2') {
    if (song2.isPlaying()) {
      song2.pause();
    } else {
      song2Play = true;
      song3Play = false;
      songPlay = false;
      song.pause();
      song3.pause();
      song2.rewind();
      song2.play();
    }
  }

  if (keyCode == '3') {
    if (song3.isPlaying()) {
      song3.pause();
    } else {
      song3Play = true;
      song2Play = false;
      songPlay = false;
      song.pause();
      song2.pause();
      song3.rewind();
      song3.play();
    }
  }
}
