import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

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

  println("Sketch Ready!");
}

void draw() {
  background(255);
  
  displaySoundData();
  
  button_a.run();
  button_b.run();
  potMeter.run();
  LDR.run();

  
}
