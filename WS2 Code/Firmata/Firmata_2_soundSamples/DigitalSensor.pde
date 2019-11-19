class DigitalSensor {
  float size = height/4, y = size/2, x;
  int pin, sensorValue, buttonState, state, previousState;
  boolean active, change;
  long lastDebounceTime = 0;  // the last time the output pin was toggled
  long debounceDelay = 30;    // the debounce time; increase if the output flickers

  String name;

  DigitalSensor(int _pin, float _x, String _name) {
    x = -size+_x*size*1.5;
    pin = _pin;
    name = _name;

    arduino.pinMode(pin, Arduino.INPUT);
    arduino.digitalWrite(pin, Arduino.INPUT_PULLUP);
  }

  void run() {
    sensorValues();

    if (showGUI) {
      //Title of Sensor
      fill(0);
      text(name, x, y-size/4);

      //Left Square
      if (buttonState == 0) {
        fill(0);
      } else {
        noFill();
      }
      rect(x, y, size/2, size, size/20);

      //Right Square 
      if (active) {
        fill(0);
      } else {
        noFill();
      }
      rect(x+size/2, y, size/2, size, size/20);

      //Details
      fill(0);
      text("Value:", x, y+size*1.25);
      text(sensorValue, x+size/2, y+size*1.25);
      text("Active:", x, y+size*1.5);
      text(str(active), x+size/2, y+size*1.5);
    }
  }


  void sensorValues() {
    sensorValue = arduino.digitalRead(pin);
    change = false;

    //Debounce
    if (sensorValue != previousState) {
      // reset the debouncing timer
      lastDebounceTime = millis();
    }

    //Check if active state has been changed 
    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (sensorValue != buttonState) {
        buttonState = sensorValue;
        if (buttonState == Arduino.LOW) {
          change = true;
          active = !active;
        }
      }
    }

    previousState = sensorValue;
  }
}
