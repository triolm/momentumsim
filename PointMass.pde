double globalEnergyLoss;

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

    pos = pos.add(vel);

    walls();
  }


  public void walls() {
    clamp();

    checkCollision(new Point(pos.x, height), 3 *Math.PI/2);
    checkCollision(new Point(pos.x, 0), Math.PI/2)    ;
    checkCollision(new Point(width, pos.y), Math.PI);
    checkCollision(new Point(0, pos.y), 0);
  }

  public void collideAt(Point p, double energyLoss, double normalAngle) {
    Vector n = new Vector(normalAngle);
    collideAt(p, energyLoss, n);
  }

  public void collideAt(Point p, double energyLoss, Vector n) {
    //move to where they're not overlapping
    while (touchingHitbox(p)) {
      if (vel.length() == 0) break;
      pos = pos.add(vel.normalize().scale(-1));
    }
    //calculate bounce angle
    //source: https://stackoverflow.com/questions/573084/how-to-calculate-bounce-angle
    Vector u = n.scale(vel.dot(n) / n.dot(n));
    Vector w = vel.add(u.scale(-1));
    vel = w.add(u.scale(-1)).scale(energyLoss-1);

    //vel = vel.scale(-energyLoss);
  }


  public boolean checkCollision(Point p, double energyLoss, double angle) {
    if (!touchingHitbox(p)) return false;
    collideAt(p, energyLoss, angle);
    return true;
  }
  public boolean checkCollision(Point p, double angle) {
    return checkCollision(p, globalEnergyLoss, angle);
  }


  public boolean checkCollision(PointMass p) {
    boolean touchingV =
      //if top of other is between top and bottom of this
      (p.pos.y + p.rad < pos.y + rad) && (p.pos.y + p.rad > pos.y - rad) ||
      //if bottom of other is between top and bottom of this
      (p.pos.y - p.rad < pos.y + rad) && (p.pos.y - p.rad > pos.y - rad);
    boolean touchingH =
      //if top of other is between top and bottom of this
      (p.pos.x + p.rad < pos.x + rad) && (p.pos.x + p.rad > pos.x - rad) ||
      //if bottom of other is between top and bottom of this
      (p.pos.x - p.rad < pos.x + rad) && (p.pos.x - p.rad > pos.x - rad);

    if (!touchingH & touchingV) return false;

    Vector v = p.pos.subtract(pos);
    Vector dirn;
    if (Math.abs(v.dx) > Math.abs(v.dy)) {
      dirn = new Vector(v.dx, 0).normalize();
    }
    dirn = new Vector(0, v.dy).normalize();

    collideAt(pos, globalEnergyLoss, dirn);
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
    boolean touchingH = Math.abs(p.x-pos.x) < rad;
    boolean touchingV = Math.abs(p.y-pos.y) < rad;
    return touchingH & touchingV;
  }

  Point translate(Point p) {
    return new Point(p.getX(), height - p.y);
  }

  public void clamp() {
    if ( pos.x < 0 || pos.y < 0) {
      pos = new Point(pos.x < 0? 1:pos.x, pos.y < 0? 1:pos.y);
    }
    if (pos.x > width || pos.y > height ) {
      pos = new Point(pos.x > width? width-1 :pos.x, pos.y > height? height-1:pos.y);
    }
  }

  public void removeEpsilon() {
    if (vel.length() < .01) {
      vel = new Vector(0, 0);
    }
  }

  public void draw() {
    rectMode(CENTER);
    fill(0, 0, 0);
    Point t = translate(pos);
    rect((float)t.x, (float)t.y, 2f*(float)rad, 2f*(float)rad);
  }
}
