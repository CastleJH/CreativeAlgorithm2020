class MapObjects {
  //status
  int tag;
  float x, y, w, h;
  int road;  
  boolean enable;
  
  PImage img;
  
  MapObjects() {
    tag = -1;
    w = 0;
    h = 0;
  };
  void display() {
    image(img, x - w/2, y - h, w, h);
  }
}

//Natural Pit
class Pit extends MapObjects {
  Pit(int roadNum){
    tag = PIT;
    x = width + 60;
    y = roadNum;
    w = 90;
    h = 30;
    road = roadNum;
    enable = true;
  }
  
  void display() {
    fill(226, 240, 217);
    rect(x - w/2 - 17, y, w, h);
  }
}

//Pit made by shovel
class ShovelPit extends MapObjects {
  ShovelPit(float X, float Y){
    tag = SHOVELPIT;
    x = X;
    w = 90;
    h = 30;
    if (Y <= road3 + 80) y = road3;
    else y = road2;
    road = (int)y;
    enable = true;
  }
  
  void display() {
    fill(226, 240, 217);
    rect(x - w/2 - 17, y, w, h);
  }
}

//Game over pit
class Cliff extends MapObjects {
  Cliff(){
    tag = CLIFF;
    y = road1;
    w = 70;
    h = 100;
    x = width + w;
    road = road1;
    enable = true;
  }
  
  void display() {
    fill(226, 240, 217);
    rect(x - w/2, y, w, h);
  }
}


class Ladder extends MapObjects {
  Ladder(float X, float Y){
    tag = LADDER;
    x = X;
    if (Y <= road3) y = road3;
    else if (Y <= road2) y = road2;
    else y = road1;
    road = (int)y;
    img = loadImage("ladder.png");
    enable = true;
    w = img.width * 0.8;
    h = img.height * 0.8;
  }
  
  void display() {
    image(img, x - w/2 - 18, y - h, w, h);
  }
}


class Food extends MapObjects {
  Food(float X, float Y){
    tag = FOOD;
    x = X;
    if (Y < road3) y = road3;
    else if (Y < road2) y = road2;
    else y = road1;
    road = (int)y;
    img = loadImage("food.png");
    enable = true;
    w = img.width * 0.8;
    h = img.height * 0.8;
  }
}


class Monster extends MapObjects {
  Monster(int roadNum){
    tag = MONSTER;
    x = width;
    y = roadNum;
    road = roadNum;
    img = loadImage("monster.png");
    enable = true;
    w = img.width * 0.8;
    h = img.height * 0.8;
  }
}

class Trap extends MapObjects {
  Trap(int roadNum){
    tag = TRAP;
    x = width;
    y = roadNum;
    road = roadNum;
    img = loadImage("trap.png");
    enable = true;
    w = img.width * 0.8;
    h = img.height * 0.8;
  }
}


class PickableSword extends MapObjects {
  PickableSword(int roadNum){
    tag = SWORD;
    x = width;
    y = roadNum;
    road = roadNum;
    img = loadImage("sword.png");
    enable = true;
    w = img.width * 0.4;
    h = img.height * 0.4;
  }
}


class PickableHammer extends MapObjects {
  PickableHammer(int roadNum){
    tag = HAMMER;
    x = width;
    y = roadNum;
    road = roadNum;
    img = loadImage("hammer.png");
    enable = true;
    w = img.width * 0.4;
    h = img.height * 0.4;
  }
}
