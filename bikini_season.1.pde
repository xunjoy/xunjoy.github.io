//*********************************************************
// ** Game Level Project **

//import ddf.minim.*; 
PImage img1, img2, img3, img4, img5;
PImage coin;
PImage objective;
//Minim minim; //Declare Minim object
//AudioPlayer bgmPlayer; //Declare different AudioPlayers, a subclass in Minim that allows audio file control (playback, loop, pause etc.)
//AudioPlayer coinPlayer;
//AudioPlayer teleportPlayer;
//AudioPlayer screamPlayer;

//global variables to control the player's behavior
float gravity = 0.07;
float horizontalAcc = 0.09;
float maxPlayerSpeed = 6; //The maximum horizontal speed
float maxPlayerJumpAcc = 1.08; //The upward acceleration when a player jumps
float playerWidth = 150;
float playerHeight = 150;
int maxJumpCount = 2; //amount of in-the-air jumps possible (e.g. double jumping, triple jumping)

int mode = -1; //mode determines the game level. -1 refers to the start/end screen where the score is displayed
int levelName = mode +1;
int score = 0; //game score. Right now, it is 3 points for collecting a coin, and 0 points for reaching the level's portal.

ArrayList<Level> levels = new ArrayList<Level>(); //This ArrayList contains all the levels which we will define in setup()

int timeStamp = 0; //variable to store a timestamp. When a sketch begins, you can find the amount of milliseconds that has elapsed by using the millis() function
int changeLevelTimeInterval = 1500; //this variable determines the time between loading levels
boolean changeLevel = false; //boolean variable to check if there is a level transition
int lostRazor = 0;


//*********************************************************
// ** Character Sprite Animation **
String[] spriteFileNames = {
  "razor1.png", 
  "razor2.png", 
  "razor3.png", 
  "razor4.png", 
  "razor5.png", 
  "razor6.png", 
  "razor7.png", 
  "razor8.png"
}; 

Player player;


//////////////////////////////////////
////////////    SET UP    ////////////
//////////////////////////////////////

void setup() {
  size(700, 700);
  img1 = loadImage("leg level 1.png");    
  img2 = loadImage("arm level 2.png");    
  img3 = loadImage("armpit level.png"); 
  img4 = loadImage("default.png");
  img5 = loadImage("end.png");
  coin = loadImage("Coin.png");
  objective = loadImage("shaving cream.png");
  //We define the minim object as well as the AudioPlayers for sound effects and BGM
  //minim = new Minim(this);
  //bgmPlayer = minim.loadFile("bgm.mp3");
  //coinPlayer = minim.loadFile("coin.wav");
  //teleportPlayer = minim.loadFile("teleport.wav");
  //screamPlayer = minim.loadFile("scream.wav");
  //bgmPlayer.loop(); //Tell the BGM to play and continuously loop

  //pushMatrix();
  //scale(-1.0,1.0);
  //image(img,-img.width,0);
  //popMatrix();

  //We define the player object here
  //The order of arguments that is passed to create a player is:
  // 1) width of player sprite
  // 2) height of player sprite
  // 3) maximum player speed
  // 4) maximum jump acceleration
  // 5) maximum in-the-air jumps
  // 6) array of sprite animation file links
  player = new Player(playerWidth, playerHeight, maxPlayerSpeed, maxPlayerJumpAcc, maxJumpCount, spriteFileNames);

  //*********************************************************
  // ** Level Definition **
  // Create your three levels in this section, by adding and
  // positioning as many Platforms, Walls, Coins, and Objectives
  // as you need. Use these to make the story of your game.
  //*********************************************************

  // LEVEL ONE
  levels.add(new Level(50, 50)); //Add a new level object to the levels ArrayList
  levels.get(0).addPlatform(new PVector(0, height-540), 395); //Add a platform to the level with the addPlatform function
  levels.get(0).addPlatform(new PVector(400, height-80), 300);
  levels.get(0).addPlatform(new PVector(0, height-5), width);
  levels.get(0).addWall(new PVector(393, height-130), 390); //Add a wall to the level with the addWall function
  //levels.get(0).addCoin(new PVector(120, height-620), 20);
  levels.get(0).addCoin(new PVector(250, height-620), 20); //Add a coin to the level with the addCoin function
  levels.get(0).addCoin(new PVector(430, height-400), 20); 
  levels.get(0).addCoin(new PVector(430, height-300), 20); //Arguments for addCoin: 1) PVector defining position of coin, 2) size of coin
  levels.get(0).addObjective(600, height-250, 1); 

  //LEVEL TWO
  levels.add(new Level(200, height-370-playerHeight/2));
  levels.get(1).addPlatform(new PVector(50, height-250), 400);
  levels.get(1).addPlatform(new PVector(150, height-370), 160);
  levels.get(1).addPlatform(new PVector(350, height-530), 230);
  levels.get(1).addWall(new PVector(400, height-200), 350);
  levels.get(1).addCoin(new PVector(170, height-290), 20);
  levels.get(1).addCoin(new PVector(270, height-290), 20);
  levels.get(1).addCoin(new PVector(350, height-400), 20);
  levels.get(1).addCoin(new PVector(350, height-460), 20);
  levels.get(1).addObjective(500, height-700, 2);

  //LEVEL THREE
  levels.add(new Level(270, height-150-playerHeight/2));
  //levels.get(2).addPlatform(new PVector(0, height-5), 200);
  levels.get(2).addPlatform(new PVector(200, height-100), 290);
  levels.get(2).addPlatform(new PVector(300, height-390), 70);
  levels.get(2).addPlatform(new PVector(430, height-270), 300);
  //levels.get(2).addPlatform(new PVector(100, height-450), 100);
  levels.get(2).addWall(new PVector(200, height-5), 95);
  levels.get(2).addWall(new PVector(440, height-110), 160);
  levels.get(2).addCoin(new PVector(380, height-540), 20);
  levels.get(2).addCoin(new PVector(350, height-490), 20);
  levels.get(2).addObjective(50, height-600, -1);
}


///////////////////////////////////////
////////////   DRAW LOOP   ////////////
///////////////////////////////////////

void draw() {


  //*********************************************************
  // ** Change Level Background and add start screen **
  // Provide a unique background for every level by adding
  // images or shapes in each case. Refer to level 3 for
  // an example. You will also need to add a case to create
  // a start screen, and change the default case to tbe the end screen. 
  //*********************************************************

  //Switch to a case depending on the value of "mode"
  //More information about switch case here: https://processing.org/reference/switch.html
  //Why do cases 0, 1 and 2 look identical?
  //That is because they are! 
  //However, separating them into different cases gives you the flexibility of changing how a particular looks, for example, level three has a yellow background.
  switch(mode) {
    //case -2: //END SCREEN
    //image(img5,0,0,width,height);
    //fill(0);
    //textSize(26);
    //textAlign(CENTER, CENTER);
    //text( +score+ "hairs shaved!", width-200, height-140);
    //text("Press spacebar to shave again", width-200, height-95);
  case 0: //LEVEL ONE
    background(255);
    imageMode(CORNER);
    image(img1, 0, 0, width, height);
    if (checkObjective(mode)) { //First we check if the player has reached the objective
      break; //If the objective has been reached, break out of the current draw loop
    }
    levels.get(mode).display(); //Render the level elements (platforms, coins etc.)
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls); //update the player's physics and position if objective has not been met
    }
    player.display(); //Render the player
    checkCoins(mode); //Check if player touches coins
    break;
  case 1: //LEVEL TWO
    background(255);
    imageMode(CORNER);
    image(img2, 0, 0, width, height);
    if (checkObjective(mode)) {
      break;
    }
    levels.get(mode).display();
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls);
    }
    player.display();
    checkCoins(mode);
    break;
  case 2: //LEVEL THREE
    imageMode(CORNER);
    image(img3, 0, 0, width, height);
    if (checkObjective(mode)) {
      break;
    }
    levels.get(mode).display();
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls);
    }
    player.display();
    checkCoins(mode);
    break;
  default: //START SCREEN
    imageMode(CORNER);
    image(img4, 0, 0, width, height);
    //background(255);
    fill(0);
    textAlign(CENTER, CENTER);
    if (lostRazor >=1){
      textSize(15);
      text("You have lost "+lostRazor+" razor(s) :(",width/2,height*5/7);
    }
    
    text();
    textSize(26);
    text("You have shaved "+score+" hairs!", width/2, height-140);
    text("Press spacebar to prepare for bikini weather", width/2, height-95);
    textSize(15);
    text("Left/right arrow keys to move, spacebar to jump. Double spacebar to super jump", width/2, height-30);  
    break;
  }

  //Draw the score on the top left corner if the game is in progress
  if (mode >= 0) {
    fill(0);
    textAlign(LEFT, TOP);
    textSize(15);
    text(score+" HAIRS SHAVED", width-130, 13);
    text("LEVEL "+levelName, 26, 13);
  }
  //println(player.pos)
}



///////////////////////////////////////////
////////////   PLAYER OBJECT   ////////////
///////////////////////////////////////////

//This is how you create a custom object class
//For more information, visit: https://processing.org/tutorials/objects/
class Player {

  PVector pos = new PVector(0, 0);
  PVector vel;
  PVector acc;
  float w;
  float h;
  float maxSpeed;
  float jumpYAcc;
  PImage[] sprite;
  PImage[] spritel;
  int jumping = 0;
  int jumpCount;
  boolean grounded = false;
  boolean moveSideways = false;

  Player(float wW, float hH, float mS, float jYA, int jC, String[] spr) {
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    w = wW;
    h = hH;
    maxSpeed = mS;
    jumpYAcc = jYA;
    jumpCount = jC;
    sprite = new PImage[spr.length];
    for (int i=0; i<spr.length; i++) {
      sprite[i] = loadImage(spr[i]);
    }

    spritel = new PImage[spr.length];
    for (int i=0; i<spr.length; i++) {
      spritel[i] = loadImage(spr[i]);
    }
  }


  void display() {
    int whichSprite  = floor(floor(pos.x/10)%sprite.length/2);
    imageMode(CENTER);
    if (keyCode == LEFT) {
      image(sprite[whichSprite+4], pos.x, pos.y, w, h);
    } //overall length of vector is 8, so 8/2=4
    else {
      image(sprite[whichSprite], pos.x, pos.y, w, h);
    }
  }

  //This function updates the player's physics
  //It consists of smaller functions
  void update(ArrayList<Platform> p, ArrayList<Wall> w) {
    calVel();
    calPos(p, w);
  }

  //Velocity + accel
  void calVel() {
    if (jumping > 0 || !grounded) {
      acc.y = acc.y + gravity;
    }
    vel.add(acc.x, acc.y);
    if (!moveSideways) {
      vel.x = vel.x * 0.9;
    }
    if (vel.x >= maxSpeed) {
      vel.x = maxSpeed;
    } else if (vel.x <= -maxSpeed) {
      vel.x = -maxSpeed;
    }
  }


  //Player position + interaction
  void calPos(ArrayList<Platform> plt, ArrayList<Wall> wall) {

    //If player is going to hit a wall, stop the player
    //This first checks if the player's body is not below or above the wall
    //Then it checks if collision is imminent
    //If collision is going to happen, stop the player depending if player is approaching wall from the left or from the right
    for (Wall wa : wall) {
      if (pos.y - h/2 < wa.base.y && pos.y + h/2 > wa.base.y - wa.h) {
        if (pos.x + w/4 <= wa.base.x && pos.x + w/4 + vel.x > wa.base.x) {
          pos.x = wa.base.x - w/4;
          vel.x = 0;
        } else if (pos.x - w/4 >= wa.base.x && pos.x - w/4 + vel.x < wa.base.x) {
          pos.x = wa.base.x + w/4;
          vel.x = 0;
        }
      }
    }

    //Update the player's position by add it to velocity
    pos.add(vel.x, vel.y);

    //Stop player from leaving the left and right edges of the screen
    if (pos.x >= width-w/2) {
      pos.x = width-w/2;
      acc.x = 0;
      vel.x = 0;
    } else if (pos.x <= w/2) {
      pos.x = w/2;
      acc.x = 0;
      vel.x = 0;
    }

    //Check which platform player should rest on after landing
    //Essentially, if player is going to collided into platform based on current velocity
    //then, stop the player
    boolean onPlatform = false;
    for (Platform p : plt) {
      if (pos.x > p.pos.x && pos.x < p.pos.x + p.w) {
        if (vel.y >= 0 && abs(pos.y+h/2-p.pos.y) < 2+vel.y) {
          pos.y = p.pos.y - h/2;
          jumping = 0;
          acc.y = 0;
          vel.y = 0;
          onPlatform = true;
        }
      }
    }

    //Ensure that player does not land into a wall
    if (!onPlatform) {
      grounded = false;
      for (Wall wa : wall) {
        if (pos.y - h/2 + vel.y < wa.base.y &&  pos.y + h/2 + vel.y > wa.base.y - wa.h) {
          if (wa.base.x > pos.x - w/4 && wa.base.x < pos.x + w/4) {
            if (vel.x > 0) {
              pos.x = pos.x + w/4;
            } else {
              pos.x = pos.x - w/4;
            }
          }
        }
      }
    }

    //If player falls through the bottom of the canvas
    //Game ends (and play screamPlayer)
    if (pos.y > height) {
      mode = -1;
      lostRazor = lostRazor + 1; //affects display screen
      //screamPlayer.rewind();
      //screamPlayer.play();
    }
  }


  //Function to run when spacebar (jump) is pressed
  void jump() {
    if (jumping < jumpCount) {
      acc.y = -jumpYAcc;
      vel.y = 0;
      jumping = jumping + 1;
    }
  }

  //Function to reset the player variables when a new level is loaded
  void reset() {
    player.acc = new PVector(0, 0);
    player.vel = new PVector(0, 0);
    player.jumping = 0;
    player.grounded = false;
  }
}



/////////////////////////////////////////////
////////////   PLATFORM OBJECT   ////////////
/////////////////////////////////////////////

class Platform {
  PVector pos;
  float w;
  Platform(PVector p, float wW) {
    pos = new PVector(p.x, p.y);
    w = wW;
  }
  void display() {
    noFill();
    noStroke();
    strokeWeight(5);
    line(pos.x, pos.y, pos.x+w, pos.y);
  }
}


/////////////////////////////////////////
////////////   WALL OBJECT   ////////////
/////////////////////////////////////////

class Wall {
  PVector base;
  float h;
  Wall(PVector b, float hH) {
    base = new PVector(b.x, b.y);
    h = hH;
  }
  void display() {
    noFill();
    noStroke();
    strokeWeight(5);
    line(base.x, base.y, base.x, base.y-h);
  }
}


/////////////////////////////////////////
////////////   COIN OBJECT   ////////////
/////////////////////////////////////////

class Coin {
  PVector pos;
  float size;
  boolean isDisplayed = true;
  Coin(PVector p, float s) {
    pos = new PVector(p.x, p.y);
    size = s;
  }

  //*********************************************************
  // ** Modify Coin Appearance **
  // Change the content inside display() to modify the appearance
  // of your coins. The line starting with 'float' is an example
  // of how you can create a basic looping animation. 
  //*********************************************************

  void display() {
    if (isDisplayed) {
      float w = size*sin(parseFloat(millis()%1500)/1500*PI);
      image(coin, pos.x + w, pos.y);
    }
  }
}

/////////////////////////////////////////
////////  OBJECTIVE OBJECT   ////////////
/////////////////////////////////////////

class Objective {
  PVector pos;
  float o;
  Objective(PVector n, float Oo) {
    pos = new PVector(n.x, n.y);
    o = Oo;
  }
  void display() {
    image(objective, pos.x, pos.y);
  }
}

//////////////////////////////////////////
////////////   LEVEL OBJECT   ////////////
//////////////////////////////////////////

class Level {
  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Wall> walls = new ArrayList<Wall>();
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<PVector> objectiveLocations = new ArrayList<PVector>();
  ArrayList<Integer> objectiveMode = new ArrayList<Integer>();

  PVector playerPos;
  Level(float x, float y) {
    playerPos = new PVector(x, y);
  }
  void addPlatform(PVector p, float wW) {
    platforms.add(new Platform(p, wW));
  }
  void addWall(PVector b, float hH) {
    walls.add(new Wall(b, hH));
  }
  void addCoin(PVector p, float s) {
    coins.add(new Coin(p, s));
  }
  void resetCoins() {
    for (Coin c : coins) {
      c.isDisplayed = true;
    }
  }
  void addObjective(float x, float y, int m) {
    objectiveLocations.add(new PVector(x, y));
    objectiveMode.add(m);
  }

  //*********************************************************
  // ** Change Objective Appearance **
  // Change the content inside ''for (PVector p : objectiveLocations) {
  // to change the appearance and animation of your objectives.
  //*********************************************************  

  //Display all the level objects: platforms, walls, coins, objectives
  void display() {
    for (Platform p : platforms) {
      p.display();
    }
    for (Wall w : walls) {
      w.display();
    }
    for (Coin c : coins) {
      c.display();
    }
    for (PVector p : objectiveLocations) {
    //for (PVector p : objectiveLocations) {
      image(objective,p.x,p.y);
      //fill(#A0A0A0);
      //stroke(#F7F7CA);
      //strokeWeight(7);
      //pushMatrix();
      //translate(p.x, p.y);
      //rotate(parseFloat(millis()%2000)/2000*PI/2);
      //rectMode(CENTER);
      //rect(0, 0, 25, 25);
      //popMatrix();
    }
  }
}


//Function to load a new level
//One argument, the level index in the array list
void loadLevel(int i) {
  if (i >= 0) {
    player.reset();
    levels.get(i).resetCoins();
    player.pos = new PVector(levels.get(i).playerPos.x, levels.get(i).playerPos.y,0);
    //println(player.pos);
  } else {
  }
  mode = i;
}

//Function to check if player has touched a coin
void checkCoins(int i) {
  
  if (!changeLevel && mode >= 0) {
    for (Coin c : levels.get(i).coins) {
      //println("----");
      //println(player.pos);
      //println(c.pos);
      PVector tempPlayer = new PVector(player.pos.x,player.pos.y,0);
      float d = PVector.dist(c.pos, tempPlayer);
      //println(d);
      //println(c.isDisplayed)
      if (d < playerWidth/2 && c.isDisplayed) {
        //println(d)
        //coinPlayer.rewind();
        //coinPlayer.play();
        score = score + 3;
        c.isDisplayed = false;
      }
    }
  }
}

//*********************************************************
// ** Change Level Teleportation Effect **
// Change the content inside the 'else if' with the ellipse
// to alter the teleportation effect. Choose one that 
// matches your story.
//********************************************************* 

//Function to check if player has touched an objective
boolean checkObjective(int i) {
  boolean bool = false;
  int count = 0;
  if (!changeLevel) {
    for (PVector p : levels.get(i).objectiveLocations) {
      tempPlayer = new PVector(player.pos.x, player.pos.y, 0);
      //println(tempPlayer);
      float d = PVector.dist(p, tempPlayer);
      //println(player.pos);
      //println(d);
      //println(playerWidth/2);
      if (d < playerWidth/2+22.5) {
        //teleportPlayer.rewind();
        //teleportPlayer.play();
        timeStamp = millis();
        changeLevel = true;
        //score = score + 100;
        break;
      }
      count++;
    }
  } else if (changeLevel && timeStamp + changeLevelTimeInterval > millis()) {
    for (int j=0; j<millis()-timeStamp; j=j+80) {
      fill(255, random(300), random(255));
      noStroke();
      ellipse(player.pos.x + random(-playerWidth/2, playerWidth/2), player.pos.y + random(-playerHeight/2, playerHeight/2), random(40), random(40));
      //ellipse(tempPlayer.pos.x + random(-playerWidth/2, playerWidth/2), tempPlayer.pos.y + random(-playerHeight/2, playerHeight/2), random(40), random(40));
    }
  } else {
    loadLevel(levels.get(i).objectiveMode.get(count));
    //fill(random(255), random(255), random(255));
    //noStroke();
    //ellipse(0, 0, random(10), random(10));
    changeLevel = false;
    bool = true;
  }
  return bool;
}

//Keyboard functions
//For more information, visit: https://processing.org/tutorials/interactivity/
//TIP: if you are impatient, go straight to the section that talks about "Events"
void keyPressed() {
  if (key == ' ') {
    //screamPlayer.pause();
    if (mode >= 0) {
      player.jump();
    } else {
      score = 0;
      loadLevel(0);
    }
  }
  if (keyCode == RIGHT) {
    player.acc.x = player.acc.x + horizontalAcc;
    player.moveSideways = true;
  } else if (keyCode == LEFT) {
    player.acc.x = player.acc.x - horizontalAcc;
    player.moveSideways = true;
  }
}

void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT) {
    player.acc.x = 0;
    player.moveSideways = false;
  }
}
