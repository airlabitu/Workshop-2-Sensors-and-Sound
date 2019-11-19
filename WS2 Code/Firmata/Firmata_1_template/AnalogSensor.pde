class AnalogSensor {
  float size = height/4, y = size/2, x;
  int pin, sensorValue, threshold;
  boolean active, previousState, change;
  String name;

  AnalogSensor(int _pin, float _x, int _threshold, String _name) {
    x = -size+_x*size*1.5;
    pin = _pin;
    name = _name;
    threshold = _threshold;
  }

  void run() {
    sensorValues();

    if (showGUI) {
      //Title of Sensor
      fill(0);
      text(name, x, y-size/4);

      //Left Square
      fill(255);
      rect(x, y, size/2, size, size/20);

      float relativeSize = int(map(sensorValue, 0, 1023, 0, size));
      fill(map(relativeSize, 0, size, 255, 0));
      rect(x, y+size, size/2, -relativeSize, size/20);

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
    sensorValue = arduino.analogRead(pin);

    //See if thresholds are surpassed
    if (sensorValue > threshold) {
      active = true;
    } else {
      active = false;
    }

    //Check if active state has been changed 
    if (previousState == active) {
      change = false;
    } else {
      change = true;
    }
    previousState = active;
  }
}
