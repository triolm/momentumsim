PointMass p1;

void setup() {
  size(1600, 900);
  p1 = new PointMass(new Point(800, 450), 10, 25);

  globalEnergyLoss = .5;
}

void draw() {
  background(230, 230, 230);

  p1.applyGrav();


  p1.step();

  p1.draw();
}

void keyPressed() {
  if (key == 'r') {
    setup();
  }
  if (keyCode == UP&& globalEnergyLoss < .9) {
    globalEnergyLoss += .1;
  }
  if (keyCode == DOWN&& globalEnergyLoss > 0) {
    globalEnergyLoss -= .1;
  }
}
