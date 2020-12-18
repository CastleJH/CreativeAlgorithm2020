import oscP5.*;
import netP5.*;

//osc
OscP5 oscP5;
NetAddress dest;
float x, y, prevx=0, prevy=0;

//road
int road1, road2, road3;
int roadGap = 300;

//objects tag
int PIT = 0;
int CLIFF = 1;
int MONSTER = 2;
int TRAP = 3;
int SWORD = 4;
int HAMMER = 5;
int LADDER = 6;
int FOOD = 7;
int SHOVELPIT = 8;

//direction tag
int UPWARD = 0;
int DOWNWARD = 1;
int STRAIGHT = 2;

//character, map, player
Character character;
Player player;
Map map;

//level and speed
float horSpeed = 0;
float verSpeed = 0;
float speedAdd = 0;
float baseHorSpeed;
float baseVerSpeed;
float level = 0;

//start?
boolean start = false;

void setup() {
  size(1600, 900);
  frameRate(60);
  
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);
  
  //calculate each road's y position
  road1 = height - 80;
  road2 = road1 - roadGap;
  road3 = road2 - roadGap;
 
  initialize();
  
  background(255, 255, 240);
  noStroke();
}

void draw() {
  if (!start) {
    background(255);
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("Press any key to start", width/2, height/2);
    if (keyPressed) start = true;
    fill(220);
    ellipse(mouseX, mouseY, 20, 20);
  }
  else if (character.gameOver == 0) {
    //increase level every frame and change speed
    level++;
    speedAdd = (level / (60 * 10)) * 0.2;
    if (speedAdd > 3.5) speedAdd = 3.5;
    horSpeed = baseHorSpeed + speedAdd;
    verSpeed = baseVerSpeed + speedAdd;
    
    //update
    map.update(character);
    character.update(map);
    player.update(map, character);
    
    //display
    map.display(character);
    character.display();
    displayStatus();
    
    //osc
    if (mousePressed) {
      x = mouseX - prevx;
      y = mouseY - prevy;
      prevx = mouseX;
      prevy = mouseY;      
      sendOsc(x, y);
      fill(150, 150, 0);
    }
    else fill(200);
    ellipse(mouseX, mouseY, 20, 20);
    //check gameover
    if (character.heart == 0) character.gameOver = 1; 
  }
  else { //gameover
    fill(255);
    rect(0, height/2 - 100, width, 170);
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("SCORE: " + player.score, width/2, height/2 - 10);
    textSize(15);
    text("Press ENTER to restart", width/2, height/2 + 20);
  }
}

void oscEvent(OscMessage m) {
  if (m.checkAddrPattern("/wek/outputs")==true) {
    player.drawing = (int)m.get(0).floatValue();
  }
}

void sendOsc(float X, float Y) {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add(X); 
  msg.add(Y);
  oscP5.send(msg, dest);
}


void keyPressed() {
  if (character.gameOver == 1) {
    if (keyCode == ENTER) {
      initialize();
    }
  }
}

void initialize() {
  map = new Map();
  character = new Character();
  player = new Player();
  level = 0;
  horSpeed = 0;
  verSpeed = 9;
  speedAdd = 0;
  baseHorSpeed = 3;
  baseVerSpeed = 9;
}

void displayStatus() {
  fill(255, 0, 0);
  for (int i = 0; i < character.heart; i++) {
    ellipse(50 + i * 30, 50, 25, 25);
  }
  for (int i = 0; i < character.sword; i++) {
    image(player.swordImg, 140 + i * 30, 30, 25, 25);
  }
  for (int i = 0; i < character.hammer; i++) {
    image(player.hammerImg, 230 + i * 30, 30, 25, 25);
  }
  fill(0);
  textSize(20);
  textAlign(LEFT);
  text("score: " + player.score, width - 200, 50);
}
