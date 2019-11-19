boolean showGUI = true;

void displaySoundData() {
  if (showGUI) {
    background(255);
    float textX = 60;
    float textY = height/2+40;

    line(0, height/2+15, width, height/2+15);

    text("Display Info Line 1", textX, textY);
    text("Display Info Line 2", textX, textY+20);

    text("Display Info Line X", textX, textY+180);
  }
}

void printFrameRate() {
  if (frameCount % 10 == 0) {
    println(frameRate);
  }
}


void keyPressed() {
  if (key == '1') {
    showGUI =! showGUI;
    println("Display GUI: " + showGUI);
  }
}
