import processing.serial.*;
import cc.arduino.*;
import processing.sound.*;
Arduino arduino;

String[] fileNames = {"chords", "foundation", "synth"}; 
SoundFile [] sounds = new SoundFile[fileNames.length];

DigitalSensor button_a;
DigitalSensor button_b;
AnalogSensor potMeter;
AnalogSensor LDR;

PFont monoFont;
int channel = 0;
float [] previousChannelVolume = new float[fileNames.length];
float volume, minVolume = 0.0001, maxVolume = 1, speed;

int analogSensorThreshold = 750, analogSensorMax = 1023;

void settings() {
  size(800, 500);
  // Prints out the available serial ports.
  println("Available Serial Ports:");
  printArray(Arduino.list());
  println();

  // Modify this line, by changing the index of the serial port corresponding to your Arduino board
  arduino = new Arduino(this, Arduino.list()[3], 57600);

  println("Available Sounds:");
  printArray(fileNames);

  //Initialize sensor classes
  //DigitalSensor(Pin to measure on, Position (1-4), name/title of sensor)
  button_a = new DigitalSensor(2, 1, "BUTTON LEFT");
  button_b = new DigitalSensor(3, 2, "BUTTON RIGHT");
  //AnalogSensor(Pin to measure on, Position (1-4), activation threshold, name/title of sensor)
  potMeter = new AnalogSensor(2, 3, analogSensorThreshold, "POTENTIOMETER");
  LDR = new AnalogSensor(3, 4, analogSensorThreshold, "LDR");
}

void setup() {
  //Load a mono font
  monoFont =createFont("Roboto Mono", 12);
  textFont(monoFont, 12);

  //Load soundfiles array
  println("Loading...");
  for (int i = 0; i < fileNames.length; i++) {
    sounds[i] = new SoundFile(this, fileNames[i] + ".mp3");
    previousChannelVolume[i] = maxVolume/2;
    sounds[i].amp(previousChannelVolume[i]);
  }

  //Loop soundfiles array, only when all files are loaded (only important if sync is important)
  for (int i = 0; i < fileNames.length; i++) {
    sounds[i].loop();
  }
  println("Sketch Ready!");
}

void draw() {
  background(255);
  displaySoundData();
    
  button_a.run();
  button_b.run();
  potMeter.run();
  LDR.run();

  volume = map(potMeter.sensorValue, 0, analogSensorMax, minVolume, maxVolume);
  sounds[channel].amp(volume);

  //If channel is changed, save the current volume on that channel
  if (button_a.change || button_b.change) {
    previousChannelVolume[channel] = volume;
  }
  //Change channels
  if (button_a.change) {
    channel--;
  }
  if (button_b.change) {
    channel++;
  }

  //Keep channel changes within the size of the array
  if (channel < 0) {
    channel = sounds.length-1;
  }
  if (channel > sounds.length-1) {
    channel = 0;
  }

  //If the LDR is in its active state, change the speed of the playback according to the sensor values
  for (int i = 0; i < sounds.length; i++) {
    if (LDR.active) {
      //0.25 speed is four times slower, 2 speed is two times faster
      speed = map(LDR.sensorValue, analogSensorThreshold, analogSensorMax, 0.25, 2);
      //Else play at normal speed
    } else {
      speed = 1;
    }
    sounds[i].rate(speed);
  }


}
