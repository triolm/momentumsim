PointMass p1;
PointMass p2;
void setup() {
  size(1600, 900);
  p1 = new PointMass(new Point(800, 450), 10, 25);
  p2 = new PointMass(new Point(700, 650), 10, 25);
  globalEnergyLoss = .5;
}

void draw() {
  background(230, 230, 230);

  p1.draw();
  p1.applyGrav();
  p1.step();
  p2.draw();
  p2.applyGrav();
  p2.step();
}

void keyPressed() {
  if (key == 'r') {
    setup();
  }
  if(keyCode == UP&& globalEnergyLoss < .9){
    globalEnergyLoss += .1;
  }if(keyCode == DOWN&& globalEnergyLoss > 0){
    globalEnergyLoss -= .1;
  }
}
