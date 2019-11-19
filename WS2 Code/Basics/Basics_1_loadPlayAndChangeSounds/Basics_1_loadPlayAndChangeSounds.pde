import processing.sound.*;
float volume, minVolume = 0.0001, maxVolume = 1, speed;

SoundFile sound1;
SoundFile sound2;

void setup() {
  size(800, 500);
  sound1 = new SoundFile(this, "drum_1.mp3");
  sound2 = new SoundFile(this, "drum_2.mp3");

  sound1.loop();
  //sound2.play();
}

void draw() {
  background(255);

  volume = map(mouseX, 0, width, minVolume, maxVolume);
  speed = map(mouseY, 0, height, 0.25, 2);
  sound1.amp(volume);
  sound1.rate(speed);
  sound2.amp(volume);
  sound2.rate(speed);

  fill(0);
  text("X - Volume: " + round(volume*100) + "%", mouseX-100, mouseY);
  text("Y - Speed: " + round(speed*100) + "%", mouseX-100, mouseY+20);
}

void keyReleased() {
  sound2.play();
}
