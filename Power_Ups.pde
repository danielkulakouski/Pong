//////////////////////////////////////////////////////////////////////////////
//Name:
//  _____              _      _   _  __     _       _                   _    _ 
// |  __ \            (_)    | | | |/ /    | |     | |                 | |  (_)
// | |  | | __ _ _ __  _  ___| | | ' /_   _| | __ _| | _____  _   _ ___| | ___ 
// | |  | |/ _` | '_ \| |/ _ \ | |  <| | | | |/ _` | |/ / _ \| | | / __| |/ / |
// | |__| | (_| | | | | |  __/ | | . \ |_| | | (_| |   < (_) | |_| \__ \   <| |
// |_____/ \__,_|_| |_|_|\___|_| |_|\_\__,_|_|\__,_|_|\_\___/ \__,_|___/_|\_\_|
//Due Date: April 25, 2016
//Description: Pong game with one player and two player modes
////////////////////////////////////////////////////////////////////////////// 

PImage comet; //loads comet image
PImage multiple; //loads multiple balls image
PImage shield; //loads shield image

float powerUpX = random(50, 750); //sets coordinates of power ups to random
float powerUpY = random(90, 550);

float p = int(random(1, 4)); //picks a random number to determine what power up it will display

boolean multipleB = false; //sets multiple balls to false
boolean cometB = false; //sets comet to false

float mx; //multiple balls x-coordinate
float my; //multiple balls y-coordinate

boolean leftShield = false; //left side shield is false
boolean rightShield = false; //right side shield is false

boolean back = false; //background is false

void powerUps() { //power up function
  imageMode(CENTER); //centres all images
  if (p==1) { //if p is 1, then comet power up is spawned
    image(comet, powerUpX, powerUpY);
  }
  if (p==2) { //if p is 2, then multiple balls power up is spawned
    image(multiple, powerUpX, powerUpY);
  }
  if (p==3) { //if p is 3, then shield power up is spawned
    image(shield, powerUpX, powerUpY);
  }

  if ((ballX-10>=powerUpX-30 && ballX+10<=powerUpX+30) && (ballY-10>=powerUpY-30 && ballY+10<=powerUpY+30) && p==1) { //determines if the ball lands on the comet powerup
    cometB = true; //makes comet power up true
    p = int(random(1, 4)); //p becomes another random number
    powerUpX = random(50, 750); //power up coordinates change
    powerUpY = random(90, 550);
  }
  if ((ballX-10>=powerUpX-30 && ballX+10<=powerUpX+30) && (ballY-10>=powerUpY-30 && ballY+10<=powerUpY+30) && p==2) { //determines if the ball lands on the multiple balls powerup
    multipleB = true; //makes comet power up true
    p = int(random(1, 4)); //p becomes another random number
    powerUpX = random(50, 750); //power up coordinates change
    powerUpY = random(90, 550);
  }
  if ((ballX-10>=powerUpX-30 && ballX+10<=powerUpX+30) && (ballY-10>=powerUpY-30 && ballY+10<=powerUpY+30) && p==3 && leftHit == true) { //determines if the ball lands on the comet powerup and if left side hit the ball last
    leftShield = true; //left shield becomes true
    p = int(random(1, 4)); //p becomes another random number
    powerUpX = random(50, 750); //power up coordinates change
    powerUpY = random(90, 550);
  }

  if ((ballX-10>=powerUpX-30 && ballX+10<=powerUpX+30) && (ballY-10>=powerUpY-30 && ballY+10<=powerUpY+30) && p==3 && rightHit == true) { //determines if the ball lands on the comet powerup and if right side hit the balll last
    rightShield = true; //right shield becomes true
    p = int(random(1, 4)); //p becomes another random number
    powerUpX = random(50, 750); //power up coordinates change
    powerUpY = random(90, 550);
  }

  if (multipleB==true) { //determines if multiple balls power up is true
    back = true; //background becomes random
    fill(255, 0, 0); //fills with red
    for (int i = 0; i<30; i++) { //creates 30 circles
      mx = random(width); //draws circles randomly
      my = random(70, height);
      ellipse(mx, my, 20, 20);
    }
  }
  if (cometB==true) { //determines if comet power up is true
    if (leftHit==true) { //determines if left side hit the ball last
      changeX = 20; //xspeed becomes 20
      changeY = random(-5, 5); //yspeed becomes random
      cometB=false; //makes powerup false to prevent it from increasing everytime you hit the ball
    }
    if (rightHit==true) { //determines if right side hit the ball last
      changeX = -20; //xspeed become
      changeY = random(-5, 5); //yspeed becomes random
      cometB=false; //makes powerup false to prevent it from increasing everytime you hit the ball
    }
  }

  if (leftShield==true) { //determines if left shield is true
    rectMode(CORNER); //draws rectangles from top left corner
    fill(0, 255, 0, 100); //fills with green with opacity slightly decreased
    rect(0, 70, 20, 530); //draws rectangle
    if (ballX-10 <= 20) { //if it touches the rectangle, the shield disappears, but it saves you from giving a point to the other player
      changeX *= -1;
      leftShield = false;
      leftHit = true;
      rightHit = false;
    }
  }
  if (rightShield==true) { //determines if right shield is true
    rectMode(CORNER); //draws rectangles from top left corner
    fill(0, 255, 0, 100); //fills with green with opacity slightly decreased
    rect(780, 70, 20, 530); //draws recatngle
    if (ballX+10 >= width-20) { //if it touches the rectangle, the shield disappears, but it saves you from giving a point to the other player
      changeX *= -1;
      rightShield = false;
      rightHit = true;
      leftHit = false;
    }
  }
}