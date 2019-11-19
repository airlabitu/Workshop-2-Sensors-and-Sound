boolean showGUI = true;

void displaySoundData() {
  if (showGUI) {
    background(255);
    float textX = 60;
    float textY = height/2+40;

    line(0, height/2+15, width, height/2+15);

    for (int i = 0; i < sounds.length; i++) {
      text("Sound " + i + " Playing: " + sounds[i].isPlaying(), textX, textY + i * 20);
      text(fileNames[i], textX + 190, textY + i * 20);
    }

    text("Volume: " + round(volume*100) + "%", textX, textY+160);
    text("Speed: " + round(speed*100) + "%", textX, textY+180);
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
