import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

//Define digital and analog pins
int digitalPin = 2, analogPin = 3; 
int digitalValue, analogValue;

void setup() {
  size(800, 500);
  // Prints out the available serial ports.
  println("Available Serial Ports:");
  printArray(Arduino.list());
  println();

  // Modify this line, by changing the index of the serial port corresponding to your Arduino board
  arduino = new Arduino(this, Arduino.list()[3], 57600);
  
  //Define digitalPin as an input pin (similar to when using  the Arduino IDE)
  arduino.pinMode(digitalPin, Arduino.INPUT);
  //Make use of the internal pull-up resistor, since we only use 2 wires for the button
  arduino.digitalWrite(digitalPin, Arduino.INPUT_PULLUP);
}

void draw() {
  background(255);
  
  //Read the values of sensors and store these in variables
  analogValue = arduino.analogRead(analogPin);
  //println(analogValue);
  digitalValue = arduino.digitalRead(digitalPin);
  //println(digitalValue);
  
  //Map sensor values to color outputs
  float fill = map(analogValue, 0, 1023, 0, 200);
  float opacity = digitalValue*255;
  
  //Color an ellipse with color outputs from above
  fill(fill, opacity);
  ellipse(width/2, height/2, 200, 200);
  
  //Display values of sensors on canvas
  fill(0);
  textAlign(CENTER);
  text("Analog: " + analogValue + "  |  " + "Digital: " + digitalValue, width/2, height/4);
  
  //You can also write to pins like in Arduino, for example:
  //arduino.digitalWrite( e.g digitalPin, e.g. Arduino.HIGH);
}
