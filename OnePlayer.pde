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

class player1 { //allows me to call at a specific place
  int gameMode; //this is adjusted depending if the mode is easy or hard
  boolean easyMode = false; //easy mode
  boolean hardMode = false; //hard mode

  int button1X1 = 265; //button x-coordinate
  int button1Y1 = 500; //button y-coordinate
  int b1Size1 = 200; //button size

  int button1X2 = 535; //button x-coordinate
  int button1Y2 = 500; //button y-coordinate
  int b1Size2 = 200; //button size

  int button1Fill1 = 66; //button red fill
  int button1Fill2 = 114; //button green fill
  int button1Fill3 = 173; //button blue fill

  int button1Fill4 = 75; //button red fill
  int button1Fill5 = 165; //button green fill
  int button1Fill6 = 90; //button blue fill

  int w = 400; //text x-coordinate
  int h = 300; //text y-coordinate

  int ew = 265; //easy text x-coordinate
  int eh = 505; //easy test y-coordinate

  int hw = 535; //hard text x-coordinate
  int hh = 505; //hard text y-coordinate

  void player2() { //moves the right player
    if (playerY2>ballY) { //if the y-coordinate of right player is greater than the y-coordinate of the ball, it moves up depending on what mode it is in
      playerY2-=gameMode;
    }
    if (playerY2<ballY) { //if the y-coordinate of right player is less than the y-coordinate of the ball, it moves down depending on what mode it is in
      playerY2+=gameMode;
    }

    if (easyMode == true) { //easy mode makes the player move only by 2
      gameMode = 2;
    }
    if (hardMode == true) { //hard mode makes the player move only by 7
      gameMode = 7;
    }
  }

  void draw() { 
    background(bg); //background
    rectMode(CENTER); //draws the rectangles from the centre
    textAlign(CENTER); //aligns the text to the centre
    textSize(100); //changes font size to 100
    fill(255, 0, 0); //fills with red
    text("One Player", w, h); //displays text
    textSize(20); //changes text size to 20
    fill(button1Fill1, button1Fill2, button1Fill3); //fills with variables so that they can be changed later
    rect(button1X1, button1Y1, b1Size1, b1Size1-140); //draws the button
    fill(0); //fills with black
    text("Click For Easy Mode", ew, eh); //displays text
    fill(button1Fill4, button1Fill5, button1Fill6); //fills with variables so that they can be changed later
    rect(button1X2, button1Y2, b1Size2, b1Size2-140); //draws the button
    fill(0); //fills with black
    text("Click For Hard Mode", hw, hh); //displays text

    if ((mouseX >= button1X1-100 && mouseX <= button1X1+100) && (mouseY >= button1Y1-30 && mouseY <= button1Y1+30)) { //if the mouse hovers over the button, it changes colour and size
      button1Fill1 = 109;
      button1Fill2 = 164;
      button1Fill3 = 229;
      b1Size1 = 210;
    } else { //if it moves back out of the way, it changes back to normal
      button1Fill1 = 66;
      button1Fill2 = 114;
      button1Fill3 = 173;
      b1Size1 = 200;
    }
    if ((mouseX >= button1X2-100 && mouseX <= button1X2+100) && (mouseY >= button1Y2-30 && mouseY <= button1Y2+30)) { //if the mouse hovers over the button, it changes colour and size
      button1Fill4 = 157;
      button1Fill5 = 247;
      button1Fill6 = 171;
      b1Size2 = 210;
    } else { //if it moves back out of the way, it changes back to normal
      button1Fill4 = 75;
      button1Fill5 = 165;
      button1Fill6 = 90;
      b1Size2 = 200;
    }

    if ((mouseX >= button1X1-100 && mouseX <= button1X1+100) && (mouseY >= button1Y1-30 && mouseY <= button1Y1+30) && mousePressed == true) { //if easy mode button is pressed, then easy mode it true
      easyMode = true;
      click.trigger(); //plays click sound
    }
    if ((mouseX >= button1X2-100 && mouseX <= button1X2+100) && (mouseY >= button1Y2-30 && mouseY <= button1Y2+30) && mousePressed == true) { //if hard mode button is pressed, then hard mode it true
      hardMode = true;
      click.trigger(); //plays click sound
    }
    if (easyMode == true || hardMode == true) { //if either button is pressed, the buttons and text move out of the way
      button1X1 = -100;
      button1Y1 = -100;
      button1X2 = -100;
      button1Y2 = -100;
      w = -100;
      h = -100;
      ew = -100;
      eh = -100;
      hw = -100;
      hh = -100;

      if (frameCount%(int)frameRate==0) { //if one second passes the timer decreases
        timer--;
      }
      if (timer>0) { //while the timer is greater than 0, the "Get Ready" screen is shown
        fill(255, 0, 0); //fills with red
        textSize(100); //changes text size to 100
        text("Get Ready!", width/2, height/2-50); //displays text
        textSize(70); //changes text size to 70
        text("First To Seven Wins!", width/2, height/2+80); //displays text
        textSize(20); //changes text size to 20
        fill(0, 255, 0); //fills with green
        text("Boost: Press 'W' \n Cheat: Press Up, Down, Left, then Right keys", width/2, height/2+150); //displays text
        fill(0); //fills with black
        textSize(30); //changes text size to 30
        fill(0, 255, 0); //fills with green
        text("Player 1: Q/A", width/2, 50); //displays text
        return; //returns
      }
      smooth(); //smooths everything

      redrawGameField(); //calls all the functions
      bounceBall();
      moveBall();
      playerOne();
      player2();
      powerUps();
      endOfGame();
    }
  }
}