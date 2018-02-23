//////////////////////////////////////////////////////////////////////////////
//Name:
//  _____              _      _   _  __     _       _                   _    _ 
// |  __ \            (_)    | | | |/ /    | |     | |                 | |  (_)
// | |  | | __ _ _ __  _  ___| | | ' /_   _| | __ _| | _____  _   _ ___| | ___ 
// | |  | |/ _` | '_ \| |/ _ \ | |  <| | | | |/ _` | |/ / _ \| | | / __| |/ / |
// | |__| | (_| | | | | |  __/ | | . \ |_| | | (_| |   < (_) | |_| \__ \   <| |
// |_____/ \__,_|_| |_|_|\___|_| |_|\_\__,_|_|\__,_|_|\_\___/ \__,_|___/_|\_\_|
//Due Date: April 25,2016
//Description: Pong game with one player and two player modes
////////////////////////////////////////////////////////////////////////////// 

player1 player; //allows me to seperate my code into another tab and call it at a specific place
import ddf.minim.*; //allows me to import music
Minim minim;
AudioPlayer mPlayer; //background music
AudioSample hit; //music when ball hits something
AudioSample click; //music when buttons are clicked

PFont myFont; //imports custom font
PImage bg; //imports background image
PImage ball; //imports ball image
PImage rightBar; //imports boost bar image
PImage leftBar;

boolean music = true;

int timer; //allows the instruction screen to be on for a set time
float playerX1 = 20; //x-coordinate of left paddle
float playerY1 = 300; //y-coordinate of left paddle
float playerX2 = 780; //x-coordinate of right paddle
float playerY2 = 300; //y-coordinate of right paddle
float paddleW = 7.5; //paddle width
float ballX = 400; //ball x-coordinate
float ballY = 300; //ball y-coordinate
float changeX = 5; //x-speed
float changeY = 5; //y-speed
int score1 = 0; //left side score
int score2 = 0; //right side score

int buttonX1 = 265; //x-coordinate of left button
int buttonY1 = 450; //y-coordinate of left button
int bSize1 = 200; //size of left button

int buttonX2 = 535; //x-coordinate of right button
int buttonY2 = 450; //y-coordinate of right button
int bSize2 = 200; //size of right button

float buttonFill1 = 66; //red fill value
float buttonFill2 = 114; //green fill value
float buttonFill3 = 173; //blue fill value

float buttonFill4 = 75; //red fill value
float buttonFill5 = 165; //green fill value
float buttonFill6 = 90; //blue fill value

boolean onePlayer = false; //one player mode
boolean twoPlayers = false; //two player mode

int x = int(random(1, 3)); //generates a random number which decides which way to cast the ball on the first round

int w2 = 400; //coordinates of "Pong" text
int h2 = 300;

boolean[] keys; //allows me to use multiple keys at the same time

boolean p1 = false; //left point
boolean p2 = false; //right point

boolean boost1 = true; //left boost
boolean boost2 = true; //right boost

float lSize = 97; //left bar size
float rSize = 97; //right bar size

float growth1 = 0.5; //how much the boost bar grows by
float growth2 = 0.5;

boolean leftHit = false; //determines if left side hit the ball last
boolean rightHit = false; //determines if right side hit the ball last

boolean first = false; //allows cheat to be activated when up, down, left, then right keys are pressed
boolean second = false;
boolean third = false;
boolean fourth = false;
boolean ultimateCheat = false;
boolean one = true; //allows the cheat to work only once

int n = 1;

void setup() {
  size(800, 600); //sets size of the screen
  myFont = createFont("Hobo STD", 50); //imports my font
  bg = loadImage("background.jpg"); //loads my background image
  bg.resize(width, height); //changes the dimensions of my image to fit the screen
  ball = loadImage("ball.png"); //loads my ball
  ball.resize(20, 20); //changes the dimensions of the ball
  leftBar = loadImage("LeftBar.png"); //left boost bar
  rightBar = loadImage("RightBar.png"); //right boost bar
  comet = loadImage("commet.png"); //commet power up
  comet.resize(50, 50); //resizes the commet icon
  multiple = loadImage("multiple.png"); //multiple balls power up
  multiple.resize(50, 50); //resizes the multiple balls icon
  shield = loadImage("shield.png"); //shield power up
  shield.resize(50, 50); //resizes the shield icon
  textFont(myFont); //sets the font
  textAlign(CENTER); //aligns the text to the center
  frameRate(50); //sets the framerate
  timer = 5; //allows me to display a message in draw for 5 seconds
  player = new player1(); //allows me to seperate one player mode into another tab

  minim = new Minim(this); //loads music
  mPlayer = minim.loadFile("Sandstorm.mp3"); //loads background music
  hit = minim.loadSample("hit.wav"); //loads the music when the ball hits the paddle or sides of the screen
  click = minim.loadSample("click.wav"); //loads the music when the user clicks the buttons

  keys=new boolean[4]; //allows the players to press multiple buttons at the same time
  keys[0]=false;
  keys[1]=false;
  keys[2]=false;
  keys[3]=false;
}

void redrawGameField() { //draws the field, ball, paddles, etc
  if (back==true) { //changes background for when multiple balls power up is activated
    fill(random(255), random(255), random(255));
    rect(0, 0, width*2, height*2);
  }
  rectMode(CORNER); //draws rectangles from the top left corner
  fill(0); //fills with black
  rect(0, 0, width, 70); //draws the top rectangle to 
  rectMode(CENTER); //draws rectangles from the centre
  strokeWeight(7); //sets the thickness of the lines to 7
  stroke(0, 0, 255); //sets the colour of the lines to blue
  line(0+3, 0+3, 0+3, height+3); //draws the lines
  line(0-3, height-3, width-3, height-3);
  line(width-3, height-3, width-3, 0-3);
  line(width+3, 70+3, 0+3, 70+3);
  line(width+3, 0+3, 0+3, 0+3);
  line(width/2, 75, width/2, height);

  noStroke(); //takes away any stroke
  fill(255); //fills with white
  rect(playerX1, playerY1, paddleW*2, 100); //draws the left paddle

  fill(255); //fills with white
  rect(playerX2, playerY2, paddleW*2, 100); //draws the right paddle

  imageMode(CENTER);
  image(ball, ballX, ballY); //draws the ball

  fill(0, 255, 0); //fills with green
  textSize(50); //sets text size to 50
  text(score1+" : "+score2, width/2, 60); //shows the score on the top of the screen

  boostBar(); //calls the energy bar
}

void boostBar() { //draws the boost bar and allows it to fill up/down
  rectMode(CORNER); //alligns the rectangles to be drawn from the top left corner
  imageMode(CORNER); //alligns the images to be drawn from the top left corner
  fill(0, 255, 0); //fills bar green
  rect(113, 47.5, lSize, 5); //left

  image(leftBar, 10, 10); //loads image of left boost bar

  if (onePlayer==false) { //only loads the right bar if two player mode is enabled
    image(rightBar, 550, 10);
    fill(0, 255, 0);
    rect(593, 47.5, rSize, 5); //right
  }
  if (onePlayer==true) { //if one player mode is enabled, the text "Pong" appears instead of the bar
    fill(255, 0, 0);
    text("Pong", 620, 60);
  }

  if (boost1==false) { //if boost is used, size goes back to zero
    lSize = 0;
  }
  if (lSize<97) { //if the boost bar isn't full, the bar keeps growing
    lSize+=growth1;
  }

  growth1+=0.5; //keeps increasing the bar

  if (lSize>=97) { //if bar reaches maximum size, you can use the boost again
    boost1 = true;
    growth1 = 0;
  }

  if (onePlayer==false) { //if two player mode is enabled, same thing happens for the right bar
    if (boost2==false) { //if boost is used, size goes back to zero
      rSize = 0;
    }
    if (rSize<97) { //if the boost bar isn't full, the bar keeps growing
      rSize+=growth2;
    }

    growth2+=0.5; //keeps increasing the bar

    if (rSize>=97) { //if bar reaches maximum size, you can use the boost again
      boost2 = true;
      growth2 = 0;
    }
  }
}

void bounceBall() { //doesn't allow the ball to go through the walls or paddles
  if ((ballX-10 <= playerX1+paddleW) && (ballX+10 >= playerX1-paddleW) && (ballY >= playerY1-50) && (ballY <= playerY1+50)) { //if the ball hits the left paddle, the speed changes signs and moves in the opposite direction
    changeX = -changeX*random(1.003, 1.007); //changes the xspeed to negative 
    leftHit = true; //determines who hit the ball last
    rightHit = false;
    hit.trigger(); //plays the hit sound
  }
  if ((ballX+10 >= playerX2-paddleW) && (ballX-10 <= playerX2+paddleW)  && (ballY <= playerY2+50) && (ballY >= playerY2-50)) { //if the ball hits the right paddle, the speed changes signs and moves in the opposite direction
    changeX = changeX*random(-1.007, -1.003); //changes the xspeed to negative
    leftHit = false; //determines who hit the ball last
    rightHit = true;
    hit.trigger(); //plays the hit sound
  }
  if (ballY-10 <= 72) { //if the ball hits the top border, it bounces off
    changeY = changeY*random(-1.007, -1.003); //changes the yspeed to negative
    hit.trigger(); //plays the hit sonud
  } 
  if (ballY+10 >= height+2) { //if the ball hits the bottom border, it bounces off
    changeY = -changeY*random(1.003, 1.007); //changes the yspeed to negatived
    hit.trigger(); //plays the hit sound
  }
  if (ballX-10 <= 0) { //if the ball hits the left side, the second player's score increases and the ball is re-casted
    p1 = false; //allows for the direction to where the ball is spawned to be controlled
    p2 = true; //allows for the direction to where the ball is spawned to be controlled
    score2++; //increases the score
    castNewBall(); //casts a new ball
  }
  if (ballX+10 >= width) { //if the ball hits the right side, the first player's score increases and the ball is re-casted
    p2 = false; //allows for the direction to where the ball is spawned to be controlled
    p1 = true; //allows for the direction to where the ball is spawned to be controlled
    score1++; //increases the score
    castNewBall(); //casts a new ball
  }
}

void playerOne() { //allows the first player to move at the same time as the second player
  if ( keys[0]) {
    playerY1-=10;
  }
  if ( keys[1]) {
    playerY1+=10;
  }
}

void playerTwo() { //allows the second player to move at the same time as the first player
  if ( keys[2]) {
    playerY2-=10;
  }
  if ( keys[3]) {
    playerY2+=10;
  }
}

void moveBall() { //on the first round, a random number is generated and depending on that number, that is where the ball will go
  if (x == 1) { //if x is 1, the ball goes to the right
    ballX += changeX;
    ballY += changeY;
  }
  if (x == 2) { //if x is 2, the ball goes to the left
    ballX -= changeX;
    ballY -= changeY;
  }
}

void castNewBall() { //casts a new ball
  ballX = 400; //sets the spawn points of the ball
  ballY = 300;
  changeX = 5;
  changeY = 5;
  playerX1 = 20; //sets the paddles back to orignal places
  playerX2 = 780; //sets the paddles back to original places

  if (one==false) { //if the cheat was used, the paddles are reset to the middle
    playerY1 = 300;
    playerY2 = 300;
  }

  multipleB = false; //makes all the power ups false
  cometB = false;
  leftShield = false;
  rightShield = false;
  back = false; //changes the background back to normal
  ultimateCheat = false; //makes the cheat stop working

  if (p1==true) { //if the second player lost the point, then the ball goes towards the right side
    if (x==1) {
      changeX = 5;
      changeY = 5;
    }
    if (x==2) {
      changeX = -5;
      changeY = -5;
    }
  } 

  if (p2==true) { //if the first player lost the point, then the ball goes towards the left side
    if (x==1) {
      changeX = -5;
      changeY = -5;
    }
    if (x==2) {
      changeX = 5;
      changeY = 5;
    }
  }
}

void draw() { 
  background(bg); //sets the background
  if (music==true) {
    if (!mPlayer.isPlaying()) { //allows the background music to be looped by rewinding it when it finishes
      mPlayer.rewind();
      mPlayer.play();
    }
  }

  rectMode(CENTER); //draws the paddles from the middle
  textAlign(CENTER); //aligns the text to the centre
  textSize(100); //sets the text size to 100
  fill(255, 0, 0); //fills with red
  text("Pong", w2, h2); //displays "Pong"
  textSize(20); //changes text size to 20
  textAlign(RIGHT); //aligns text to the right
  text("Press 'm' to mute the background music\nand 'u' to unmute it", 780, 40); //displays text
  textAlign(CENTER); //aligns the text to the centre
  textSize(20); //sets the text size to 20
  fill(buttonFill1, buttonFill2, buttonFill3); //fills with variables so that the fill can change when the mouse hovers over the buttons
  rect(buttonX1, buttonY1, bSize1, bSize1-140); //draws the button
  fill(0); //fills with black
  text("Click For One Player", 265, 455); //displays text on the button
  fill(buttonFill4, buttonFill5, buttonFill6); //fills with variables so that the fill can change when the mouse hovers over the buttons
  rect(buttonX2, buttonY2, bSize2, bSize2-140); //draws the button
  fill(0); //fills with black
  text("Click For Two Players", 535, 455); //displays text on the button

  if ((mouseX >= buttonX1-100 && mouseX <= buttonX1+100) && (mouseY >= buttonY1-30 && mouseY <= buttonY1+30)) { //if the player hovers over the left button, it changes colours and grows bigger
    buttonFill1 = 109;
    buttonFill2 = 164;
    buttonFill3 = 229;
    bSize1 = 210;
  } else { //if the player moves the mouse away again, the colours and size change back to normal
    buttonFill1 = 66;
    buttonFill2 = 114;
    buttonFill3 = 173;
    bSize1 = 200;
  }
  if ((mouseX >= buttonX2-100 && mouseX <= buttonX2+100) && (mouseY >= buttonY2-30 && mouseY <= buttonY2+30)) { //if the player hovers over the right button, it changes colours and grows bigger
    buttonFill4 = 157;
    buttonFill5 = 247;
    buttonFill6 = 171;
    bSize2 = 210;
  } else { //if the player moves the mouse away again, the colours and size change back to normal
    buttonFill4 = 75;
    buttonFill5 = 165;
    buttonFill6 = 90;
    bSize2 = 200;
  }

  if ((mouseX >= buttonX1-100 && mouseX <= buttonX1+100) && (mouseY >= buttonY1-30 && mouseY <= buttonY1+30) && mousePressed == true) { //if the player clicks the left button, one player mode is enabled (located in OnePlayer tab)
    onePlayer = true;
    click.trigger(); //click sound is played
  }
  if ((mouseX >= buttonX2-100 && mouseX <= buttonX2+100) && (mouseY >= buttonY2-30 && mouseY <= buttonY2+30) && mousePressed == true) { //if the player clicks the right button, two player mode is enabled
    twoPlayers = true;
    click.trigger(); //click sound is played
  }
  if (onePlayer == true) { //if one player mode is enabled, then the button is moved out of the way with the text and the draw function is enabled in the tab OnePlayer
    player.draw();
    buttonX1 = -100;
    buttonY1 = -100;
    buttonX2 = -100;
    buttonY2 = -100;
    w2 = -100;
    h2 = -100;
  }
  if (twoPlayers == true) { //if two player mode is enabled, then the button is moved out of the way along with the text
    background(bg);
    buttonX1 = -100;
    buttonY1 = -100;
    buttonX2 = -100;
    buttonY2 = -100;
    if (frameCount%(int)frameRate==0) { //if one second passes, the timer decreases
      timer--;
    }
    if (timer>0) { //if the timer isn't zero, it displays the "Get Ready!" screen
      fill(255, 0, 0); //fills with red
      textSize(100); //changes text size to 100
      text("Get Ready!", width/2, height/2-50); //displays text
      textSize(70); //changes text size to 70
      text("First To Seven Wins!", width/2, height/2+80); //displays text
      textSize(20); //changes text size to 20
      fill(0, 255, 0); //fills with green
      text("Boost: Left Side Press 'W' and Right Side Press 'O' \n Cheat: Press Up, Down, Left, then Right keys", width/2, height/2+150); //displays text
      fill(0); //fills with black
      textSize(30); //changes text size to 30
      fill(0, 255, 0); //fills with green
      text("Player 1: Q/A", 200, 50); //displays text
      text("Player 2: P/L", 600, 50); //displays text
      return; //returns
    }
    smooth(); //smooths everything

    redrawGameField(); //calls all the functions when the timer is done
    bounceBall();
    moveBall();
    playerOne();
    playerTwo();
    powerUps();
    endOfGame();
  }
}

void endOfGame() { //displays the end of the game screen
  if (score1 == 7 || score2 == 7) { //if the left side or right side score is 7 then it displays the game over screen
    delay(300); //delays the screen when the background is flashing with random colours
    fill(random(255), random(255), random(255)); //fills with random colours
    ballX = width/2; //places the ball back to the middle
    ballY = height/2;
    changeX = 0; //stops moving the ball
    changeY = 0;
    rect(0, 0, width*2, height*2); //draws a large rectangle that covers the whole screen
    fill(0, 255, 0); //fills with green
    text(score1+" : "+score2, width/2, 70); //displays the final score
    textSize(100); //sets text size to 100
    fill(255, 0, 0); //fills with red
    text("Game Over!", width/2, height/2-30); //displays game over
    textSize(70); //sets text size to 70

    if (score1 == 7) {
      text("Left Side Wins!", width/2, height/2+50); //displays left side wins
      textSize(40); //changes text size to 40
      text("(Press And Hold 'R' To restart)", width/2, height/2+100); //allows the game to be restarted by resetting everything
      if (keyPressed == true) {
        if (key == 'r'||key == 'R') {
          score1 = 0;
          score2 = 0;
          changeX = random(3, 7);
          changeY = random(3, 7);
          boost1 = true;
          boost2 = true;
          first = false;
          second = false;
          third = false;
          fourth = false;
          one = true;
          draw();
        }
      }
    }
  }
  if (score2 == 7) { //if the right side score is 7 then it displays the game over screen
    text("Right Side Wins!", width/2, height/2+50);
    textSize(40); //changes text size to 40
    text("(Press And Hold 'R' To restart)", width/2, height/2+100); //allows the game to be restarted by resetting everything
    if (keyPressed == true) {
      if (key == 'r'||key == 'R') {
        score1 = 0;
        score2 = 0;
        changeX = random(3, 7);
        changeY = random(3, 7);
        boost1 = true;
        boost2 = true;
        first = false;
        second = false;
        third = false;
        fourth = false;
        one = true;
        draw();
      }
    }
  }
}

void keyPressed() { //controls all keys that are pressed
  if (key==' ') { //determines if spacebar is pressed
    if (looping) { //determines if the draw function is looping
      textSize(50); //text size changes to 50
      fill(255); //fills with white
      text("Paused \n Press Space To Continue", width/2, height/2); //displays pause message
      mPlayer.pause(); //pauses music
      noLoop(); //stops looping the draw function
    } else { //determines if the draw function isn't looping
      loop(); //starts looping the draw function
      mPlayer.play(); //plays music
    }
  }

  if (key=='q')  keys[0]=true; //when q is pressed key[0] is true
  if (key=='a')  keys[1]=true; //when a is pressed key[1] is true
  if (key=='p')  keys[2]=true; //when p is pressed key[2] is true
  if (key=='l')  keys[3]=true; //when l is pressed key[3] is true

  if (boost1) { //determines if boost 1 is true
    if (key=='w') { //determines if 'w' is pressed
      if (leftHit==true) { //determines if left side hit last
        changeX = changeX*random(1, 1.5); //horizontal speed changes to positive so that it goes to the right
      }
      if (rightHit==true) { //determines if right side hit last
        changeX = -changeX*random(1, 1.5); //horizontal speed changes to positive (because it turns negative when it bounces off the paddle) so that it goes to the right
      }
      if (changeY>0) { //if vertical speed is positive, it changes to negative
        changeY = changeY*random(1, 1.5);
      }
      if (changeY<0) { //if vertical speed is negative, it changes to positive
        changeY = changeY*random(-1.5, -1);
      }
      boost1 = false; //makes boost false
    }
  }
  if (onePlayer==false) { //only works if two player mode is enabled
    if (boost2) { //determines if boost2 is true
      if (key=='o') { //determines if the key 'o' is pressed
        if (leftHit==true) { //determines if left side hit the ball last
          changeX = -changeX*random(1, 1.5); //horizontal speed changes to negative so that it goes to the left
        }
        if (rightHit==true) { //determines if right side hit the ball last
          changeX = changeX*random(1, 1.5); //horizontal speed changes to negative (because it turns negative when it bounces off the paddle) so that it goes to the left
        }
        if (changeY>0) { //if vertical speed is positive, it changes to negative
          changeY = changeY*random(1, 1.5);
        }
        if (changeY<0) { //if vertical speed is negative, it changes to positive
          changeY = changeY*random(-1.5, -1);
        }
        boost2 = false; //makes boost false
      }
    }
  }
  if (keyCode==UP) { //if up is pressed, then first becomes true
    first=true;
  }
  if (keyCode==DOWN && first==true) { //if down is pressed and first is true, second becomes true
    second=true;
  }
  if (keyCode==LEFT && first==true && second==true) { //if left is pressed and first and second are true, third becomes true
    third=true;
  }
  if (keyCode==RIGHT && first==true && second==true && third==true) { //if right is pressed and first, second, and third are true, fourth becomes true
    fourth=true;
  }
  if (fourth==true) { //if fourth is true, then the ultimate cheat becomes true
    ultimateCheat=true;
  }
  if (ultimateCheat==true && one==true) { //if ultimate cheat is true and one is true (allows for cheat only to work once) then switch x-coorcinates of playerX1 and playerX2
    playerX1 = 780;
    playerX2 = 20;
    one=false; //one becomes false which prevents the cheat from being used again
  }
  
  /* the cheat is that the paddles switch places until the ball reaches either side
  of the screen. This will allow for the player to gain an extra point against the
  opponent. To activate the cheat, you must press the up, down, left, and then right
  key in that order and then the x values of the paddles will switch, and will be back
  to normal once the code reaches the castNewBall function. Also, if you get to the
  game over screen and press and hold 'r' to restart, the cheat is reset so that you
  can use it again.
  */

  if (key=='m') {
    music = false;
    mPlayer.pause();
  }
  if (key=='u') {
    music = true;
    mPlayer.play();
  }
}

void keyReleased() { //once the keys are released, they become false and the paddles stop moving
  if (key=='q') keys[0]=false;
  if (key=='a') keys[1]=false;
  if (key=='p') keys[2]=false;
  if (key=='l') keys[3]=false;
} 