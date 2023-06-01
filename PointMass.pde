public class PointMass {
  Point pos;
  Vector vel;
  double mass;
  double rad;
  boolean held;

  public PointMass(Point pos, double mass, double rad) {
    this.pos = pos;
    this.vel = new Vector(0, 0);
    this.mass = mass;
    this.rad = rad;
    held = false;
  }

  public void step() {
    if (mouseInteraction()) {
      return;
    }

    checkCollision(new Point(pos.x, height), .50);
    checkCollision(new Point(pos.x, 0), .50)    ;
    checkCollision(new Point(width, pos.y), .50);
    checkCollision(new Point(width, 0), .50);

    pos = pos.add(vel);
  }
  public void collideAt(Point p, double energyLoss, angle) {
    while (touchingHitbox(p)) {
      pos = pos.add(vel.normalize().scale(-1));
    }
    vel = vel.scale(-energyLoss);
  }

  public boolean checkCollision(Point p, double energyLoss, double angle) {
    if (!touchingHitbox(p)) return false;
    collideAt(p, energyLoss, angle);
    return true;
  }


  public boolean mouseInteraction() {
    Point mouse= translate(new Point(mouseX, mouseY));
    if (!held && mousePressed && touchingHitbox(mouse)) {
      held = true;
    }

    if (held && !mousePressed) {
      vel = mouse.subtract(translate(new Point(pmouseX, pmouseY)));
      held = false;
      return false;
    }

    if (held) {
      pos = mouse;
      vel = new Vector(0, 0);
      return true;
    }
    return false;
  }

  public void applyForce(Vector v) {
    vel = vel.add(v.scale(1/mass));
  }

  public void applyGrav() {
    applyForce(getGrav());
  }

  public Vector getGrav() {
    double TIMESTEP = 1/60d;
    return new Vector(0, -mass * 9.81 * TIMESTEP);
  }

  public boolean touchingHitbox(Point p) {
    return p.getDist(pos) < rad;
  }

  Point translate(Point p) {
    return new Point(p.getX(), height - p.y);
  }

  public void draw() {
    rectMode(CENTER);
    fill(0, 0, 0);
    Point t = translate(pos);
    rect((float)t.x, (float)t.y, 2f*(float)rad, 2f*(float)rad);
  }
}
