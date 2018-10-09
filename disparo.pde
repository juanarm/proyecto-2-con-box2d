class disparo {
  Body body;
  float r;
  float x;
  float y;
  float x2;
  float y2;
  boolean delete = false;

  disparo(float x_, float y_, float r_) {
    x=x_;
    y=y_;
    r = r_;
    makeBody(x, y, r);
    body.setUserData(this);
  }

  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    body.createFixture(fd);

    body.setAngularVelocity(100);
    body.setGravityScale(0);
  }

  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }

  void delete() {
    delete = true;
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  void natura() {
    nat.add(new naturaleza(220, 20));
  }


  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+r*2 || delete) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    x2=pos.x;
    y2=pos.y;
    fill(40, 40, 40);
    ellipse(0, 0, r*2, r*2);
    popMatrix();
  }
}
