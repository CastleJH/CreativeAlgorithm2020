class Player {
  //status
  float x, y;
  int drawing;
  int score;
  
  //counter, buffer
  int maxCounter, oneSecondCounter;
  int[] ctrs, xbuffer, ybuffer;
  int b = 0;   //buffer index
  
  //display
  PImage swordImg, hammerImg;
  
  //these tags are only used in this class
  private int LADDER = 1, SHOVEL = 2, FOOD = 3, TOOL = 4;
  
  Player() {
    x = width/2;
    y = height/2;
    swordImg = loadImage("sword.png");
    hammerImg = loadImage("hammer.png");
    
    drawing = 1;
    maxCounter = 30;
    score = 0;
    ctrs = new int[4];
    ctrs[0] = ctrs[1] = ctrs[2] = ctrs[3] = 0;
    xbuffer = new int[30];
    ybuffer = new int[30];
  }
  
  void update(Map m, Character ch) {
    oneSecondCounter++;
    if (oneSecondCounter > 60) {
      oneSecondCounter = 0;
      score++;
    }
    if (mousePressed) {
      //check which one is being drawn
      ctrs[drawing - 1]++;
      //renew the average of mouse postion for lass 30 frames.
      xbuffer[b] = mouseX;
      ybuffer[b++] = mouseY;
      b %= 30;
      getXYAverage();
      //if ladder/shovel/food counter reaches maxCounter, add new map objects to map and initialize counters
      if (ctrs[LADDER - 1] > maxCounter) {
        m.objects.add(new Ladder(x, y));
        initializeCtrs();
      }
      else if (ctrs[SHOVEL - 1] > maxCounter) {
        m.objects.add(new ShovelPit(x, y));
        initializeCtrs();
      }
      else if (ctrs[FOOD - 1] > maxCounter) {
        m.objects.add(new Food(x, y));
        initializeCtrs();
      }
      //if the drawing was tool, remove monster/trap if possible 
      else if (ctrs[TOOL - 1] > maxCounter){
        for (int i = m.objects.size() - 1; i >= 0; i--) {
          MapObjects obj = m.objects.get(i);
          if (ch.sword > 0 && obj.tag == MONSTER && dist(obj.x, obj.y + obj.h/2, this.x, this.y) < 200) {
            m.objects.remove(i);
            m.objectCount[2]--;
            ch.sword--;
            score += 100;
            break;
          }
          else if (ch.hammer > 0 && obj.tag == TRAP && dist(obj.x, obj.y + obj.h/2, this.x, this.y) < 200) {
            m.objects.remove(i);
            m.objectCount[3]--;
            ch.hammer--;
            score += 100;
            break;
          }
        }
        initializeCtrs();
      }
    }
  }
  
  //calculate the average of xbuffer and ybuffer
  private void getXYAverage() {
    x = 0; y = 0;
    for (int i = 0; i < 30; i++) {
      x += xbuffer[i];
      y += ybuffer[i];
    }
    x /= 30; y /= 30;
  }
  
  //initialize drawing counters
  private void initializeCtrs() {
    for (int i = 0; i < 4; i++) ctrs[i] = 0;
  }
}
