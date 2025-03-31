import java.util.*;

int cols = 4;
int rows = 4;
int totalCards = cols * rows;

Card[] cards = new Card[totalCards];
Card firstFlipped = null;
Card secondFlipped = null;
boolean lock = false;
int lockTimer = 0;

void setup() {
  size(400, 400);

  // Lav par af værdier (0-7 to gange)
  ArrayList<Integer> valueList = new ArrayList<Integer>();
  for (int i = 0; i < totalCards; i++) {
    valueList.add(i % (totalCards / 2));
  }
  Collections.shuffle(valueList);

  int[] values = new int[totalCards];
  for (int i = 0; i < totalCards; i++) {
    values[i] = valueList.get(i);
  }
  
  // Lav kortene
  for (int i = 0; i < totalCards; i++) {
    int x = (i % cols) * (width / cols);
    int y = (i / cols) * (height / rows);
    cards[i] = new Card(x, y, width/cols, height/rows, values[i]);
  }
}

void draw() {
  background(220);
  
  for (Card c : cards) {
    c.show();
  }
  
  // Tjek om vi skal vende kort tilbage
  if (lock && millis() - lockTimer > 1000) {
    if (firstFlipped.value != secondFlipped.value) {
      firstFlipped.faceUp = false;
      secondFlipped.faceUp = false;
    }
    firstFlipped = null;
    secondFlipped = null;
    lock = false;
  }
}

void mousePressed() {
  if (lock) return;
  
  for (Card c : cards) {
    if (c.contains(mouseX, mouseY) && !c.faceUp) {
      c.faceUp = true;
      if (firstFlipped == null) {
        firstFlipped = c;
      } else if (secondFlipped == null) {
        secondFlipped = c;
        lock = true;
        lockTimer = millis();
      }
      break;
    }
  }
}

class Card {
  int x, y, w, h;
  int value;
  boolean faceUp = false;

  Card(int x, int y, int w, int h, int value) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.value = value;
  }

  void show() {
    stroke(0);
    if (faceUp) {
      fill(255);
      rect(x, y, w, h);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(32);
      text(value, x + w/2, y + h/2);
    } else {
      fill(100, 150, 200);
      rect(x, y, w, h);
    }
  }

  boolean contains(int mx, int my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
