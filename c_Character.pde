class Character {
  //status
  float x, y;
  boolean hungry = false;
  int sword, hammer;
  int road;
  int heart = 3;
  int gameOver = 0;
  
  //counter
  int hungryCtr = 0;
  int accumulatedY = 0;
  
  //display
  PImage blue, grey;
  int direction = STRAIGHT;
  float scl = 0.8;
  
  Character(){
    blue = loadImage("character.png");
    grey = loadImage("hungry.png");
    road = road2;
    x = 100;
    y = road;
    sword = hammer = 0;
  }
  
  void update(Map map) {
    //check collision of character and map objects
    for (int i = map.objects.size() - 1; i >= 0; i--) {
      MapObjects item = map.objects.get(i);
      if (x + blue.width * scl > item.x && x < item.x && item.enable && road == item.road) {
        if (item.tag == SWORD)          { if (sword < 3) sword++; }
        else if (item.tag == HAMMER)    { if (hammer < 3) hammer++; }
        else if (item.tag == FOOD)      { map.objects.remove(i); map.objectCount[FOOD]--; hungry = false; }
        else if (item.tag == LADDER
                 && item.road != road3) direction = UPWARD;
        else if ((item.tag == PIT || 
                 item.tag == SHOVELPIT)
                 && item.road != road1) direction = DOWNWARD;
        else if (item.tag == MONSTER)   heart--;
        else if (item.tag == TRAP)      heart--;
        else if (item.tag == CLIFF)     gameOver = 1;
        item.enable = false;
      }
    }
    
    //update character's y position
    //x postion of character never changes. Instead, map objects' x positions change in class "Map".
    if (direction == UPWARD) {
      y -= verSpeed;
      accumulatedY += verSpeed;
      if (accumulatedY >= 300) {
        road -= roadGap;
        y = road;
        direction = STRAIGHT;
        accumulatedY = 0;
      }
    }
    else if (direction == DOWNWARD) {
      y += verSpeed;
      accumulatedY += verSpeed;
      if (accumulatedY >= 300) {
        road += roadGap;
        y = road;
        direction = STRAIGHT;
        accumulatedY = 0;
      }
    }
    
    //update hungry status
    if (!hungry) {
      if (random(1) < 0.001) hungry = true;
    }
    else {
      hungryCtr++;
      if (hungryCtr > (int)(width/verSpeed) * 60) {
        heart--;
        hungryCtr = 0;
        hungry = false;
      }
    }
  }
  
  void display() {
    if (!hungry) image(blue, x + 20, y - blue.height * scl, blue.width * scl, blue.height * scl);
    else image(grey, x + 20, y - grey.height * scl, grey.width * scl, grey.height * scl);
  }
}
