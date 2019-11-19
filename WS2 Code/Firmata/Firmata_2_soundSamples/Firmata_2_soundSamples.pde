import processing.serial.*;
import cc.arduino.*;
import processing.sound.*;
Arduino arduino;

String[] fileNames = {"drum_1", "drum_2", "bass", "bell", "piano_1", "piano_2", "piano_3"}; 
SoundFile [] sounds = new SoundFile[fileNames.length];

DigitalSensor button_a;
DigitalSensor button_b;
AnalogSensor potMeter;
AnalogSensor LDR;

PFont monoFont;
float volume, minVolume = 0.0001, maxVolume = 1, speed;

int analogSensorMax = 1023, analogSensorThreshold = analogSensorMax/2; 

void setup() {
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

  //Load a mono font
  monoFont =createFont("Roboto Mono", 12);
  textFont(monoFont, 12);

  //Load soundfiles array
  println("Loading...");
  for (int i = 0; i < fileNames.length; i++) {
    sounds[i] = new SoundFile(this, fileNames[i] + ".mp3");
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

  //Play a bass sound if both buttons are changed in state
  if (button_a.change && button_b.change) {
    sounds[2].play();
  } else if (button_a.change) { // else play drum_1
    sounds[0].play();
  } else if (button_b.change) { // else play drum_2
    sounds[1].play();
  }

  //If potentiometer threshold is crossed play a piano note
  if (potMeter.change && potMeter.active) {
    sounds[4].play();
  }
  if (potMeter.change && !potMeter.active) {
    sounds[5].play();
  } 

  //Play a bell note if LDR state is not active anymore
  if (LDR.change && !LDR.active) {
    sounds[3].play();
  }

  //Set the volume of the sounds to the sensor value of the potentiometer
  volume = map(potMeter.sensorValue, 0, analogSensorMax, minVolume, maxVolume);

  //If the LDR is not in its active state, change the speed of the playback according to the sensor values
  for (int i = 0; i < sounds.length; i++) {
    if (!LDR.active) {
      //0.25 speed is four times slower, 2 speed is two times faster
      speed = map(LDR.sensorValue, 0, analogSensorThreshold, 0.25, 2);
      //Else play at normal speed
    } else {
      speed = 1;
    }
    //Change the volume and speed of the sound samples
    sounds[i].amp(volume);
    sounds[i].rate(speed);
  }

  
}
