class Map {
  //Map objects
  ArrayList<MapObjects> objects;
  
  //creating map objects
  int[] objectCount = {0, 0, 0, 0, 0, 0, -1, -1, -1};
  float nextAddGap = 0;
  MapObjects last;
  
  //display
  float backgroundX = 0;
  
  Map() {
    objects = new ArrayList();
  }
  
  void update(Character ch) {
    //check lastly generated object's position
    boolean overlap = false;
    if (objects.size() != 0) {
      if (last.x > width - nextAddGap) overlap = true;
    }
    
    //if that object moved enough to create next object
    if (!overlap) {
      //what to create
      int objectTag = (int)random(4);
      if (random(1) < 0.05) objectTag = (int)random(4, 6);
      
      //where to create
      int objectRoad;
      int loopBreak = 0;
      while (true) {
        loopBreak++;
        // 50% chance to be created on character's current road
        if (random(1) < 0.5) objectRoad = ch.road;
        else objectRoad = height - 80 - ((int)random(3)) * roadGap;
        //but, pit must not be created on road1.
        if (objectTag == PIT) objectRoad = height - 80 - ((int)random(2) + 1) * roadGap;
        //check whether this road is full. (maximum 4 map objects per road)
        int count = 0;
        for (int i = objects.size() - 1; i >= 0; i--) {
          if (objects.get(i).road == objectRoad) count++;
        }
        //if road is not full(== okay to create),
        //or after 100 times of try, creating new objects is impossible
        if (count < 5 || loopBreak > 100) break;
      }
      
      //add objects
      if (objectTag == PIT     && objectCount[objectTag] < 4) {
        objects.add(new Pit(objectRoad));
        objectCount[objectTag]++;
      }
      if (objectTag == CLIFF   && objectCount[objectTag] < 2) {
        objects.add(new Cliff()); 
        objectCount[objectTag]++;
      }
      if (objectTag == MONSTER && objectCount[objectTag] < 3) {
        objects.add(new Monster(objectRoad));
        objectCount[objectTag]++;
      }
      if (objectTag == TRAP    && objectCount[objectTag] < 4) {
        objects.add(new Trap(objectRoad));
        objectCount[objectTag]++;
      }
      if (objectTag == SWORD   && objectCount[objectTag] < 1) {
        objects.add(new PickableSword(objectRoad));
        objectCount[objectTag]++;
      }
      if (objectTag == HAMMER  && objectCount[objectTag] < 1) {
        objects.add(new PickableHammer(objectRoad));
        objectCount[objectTag]++;
      }
      //decide when to create the next object(this will be used on checking overlap)
      last = objects.get(objects.size() - 1);
      float stage = level / 60 * 20;  //create more often on high level
      if (stage > 10) stage = 10;
      nextAddGap = random(150 - stage * 5, 350 - stage * 10);
    }
    
    //if character is moving straight, map moves to left.
    if (ch.direction == STRAIGHT)
      for (int i = objects.size() - 1; i >= 0; i--) {
        MapObjects obj = objects.get(i);
        obj.x -= horSpeed;
        //if objects disappear from the screen, remove them
        if (obj.x < -100 ||
            (obj.enable == false && (obj.tag == FOOD || obj.tag == SWORD || obj.tag == HAMMER)) ) {
          objectCount[obj.tag]--;
          objects.remove(i);
        }
      }
  }
  
  void display(Character ch) {
    if (ch.direction == STRAIGHT) {
      backgroundX -= 0.3;
    }    
    mapBackground();
    
    //draw fixed map objects
    for (int i = objects.size() - 1; i >= 0; i--) {
      objects.get(i).display();
    }
  }
  
  void cloud(float x, float y) {
    fill(255);
    ellipse(x + 40, y, 80, 80);
    ellipse(x - 40, y, 80, 80);
    ellipse(x + 20, y + 20, 90, 60);
    ellipse(x - 10, y - 20, 70, 60);
  }
  
  void mountain(float x, float y, float w, float h, int r, int g, int b) {
    fill(r, g, b);
    triangle(x - w/2, y, x + w/2, y, x, y-h);
  }
  
  void mapBackground() {
    //sky
    fill(226, 240, 217);
    rect(0, 0, width, height);
    //clound and mountain
    backgroundX %= width;
    cloud(width/2 - 300 + backgroundX, road3 - roadGap/3);
    cloud(width/2 + 700 + backgroundX, road2 - roadGap/5);
    mountain(width/2 - 200 + backgroundX, height, 400, 250, 180, 220, 180);
    mountain(width/2 - 400 + backgroundX, height, 400, 300, 190, 230, 190);
    mountain(width/2 + 600 + backgroundX, height, 500, 220, 180, 220, 180);
    cloud(width/2*3 - 300 + backgroundX, road3 - roadGap/3);
    cloud(width/2*3 + 700 + backgroundX, road2 - roadGap/5);
    mountain(width/2*3 - 200 + backgroundX, height, 400, 250, 180, 220, 180);
    mountain(width/2*3 - 400 + backgroundX, height, 400, 300, 190, 230, 190);
    mountain(width/2*3 + 600 + backgroundX, height, 500, 220, 180, 220, 180);
    //road 1, 2, 3
    fill(100, 50, 0);
    rect(0, road1, width, road1);
    rect(0, road2, width, 30);
    rect(0, road3, width, 30);
  }
}
