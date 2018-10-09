import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

color c1, c2;
PImage tanque;
PImage hojas1;
PImage hojas2;

int tiro = 0;
ArrayList <disparo> disparos;
float bala=10;
float angulo=50;

ArrayList <naturaleza> nat;
int natura=0;

ArrayList<pared> paredes;
pared suelo;

float natx, naty;

void setup() {
  frameRate(60);
  noStroke();
  size(1000, 600);
  smooth();

  //Box2D
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();


  // Colores de fondo
  c1 = color(85, 98, 130);
  c2 = color(154, 160, 181);


  //tanque
  tanque = loadImage("tanque.png");
  tanque.resize(300, 225);
  disparos = new ArrayList<disparo>();

  hojas1 = loadImage("planta1.jpg");
  hojas1.resize(50, 50);
  hojas2 = loadImage("planta2.jpg");
  hojas2.resize(50, 50);
  nat = new ArrayList<naturaleza>();

  //paredes
  paredes = new ArrayList<pared>();
  for (int i=0; i<10; i++)
  {
    paredes.add(new pared(300+(70*i), random(0, 300), 50, 50));
  }
  suelo = new pared(width/2, 550, 1000, 100);
}

void draw() {  
  //fondo
  background(c2);

  box2d.step();


  //disparos
  for (int i = disparos.size()-1; i >= 0; i--) {
    disparo d = disparos.get(i);
    d.display();

    if (d.done()) {
      disparos.remove(i);
    }
  }

  for (disparo b : disparos) {
    Vec2 impulso = new Vec2(200, angulo);
    b.applyForce(impulso);
  }

  //naturaleza
  for (int j = nat.size()-1; j >= 0; j--) {
    naturaleza n = nat.get(j);
    n.display();
  }

  //Suelo
  suelo.display();

  //tanque
  imageMode(CORNER);
  image(tanque, 0, 350);

  //println(angulo);
}




// Colisiones
void beginContact(Contact cp) {

  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1==null || o2==null) {
    return;
  }

  if (o1.getClass() == pared.class && o2.getClass() == disparo.class) {
    disparo p = (disparo) o2;
    natx = p.x2;
    naty = p.y2;
    natura=1;
    p.delete();
  }
  if (o1.getClass() == disparo.class && o2.getClass() == pared.class) {
    disparo p = (disparo) o1;
    natx = p.x2;
    naty = p.y2;
    natura=1;
    p.delete();
  }
}

void endContact(Contact cp) {
  if (natura==1) { 
    nat.add(new naturaleza(natx, naty));
    natura=0;
  }
}


//Accionar disparo
void keyPressed()
{
  if (key  == ' ' && tiro == 0)
  {
    disparos.add(new disparo(265, 395, bala));
    tiro=1;
  }
  
  if (key == 'w' || key == 'W') {
    angulo+=20;
  } else if (key == 's' || key == 'S') {
    angulo-=20;
  }
}

void keyReleased()
{
  if (key == ' ')
  {
    tiro=0;
  }
}
