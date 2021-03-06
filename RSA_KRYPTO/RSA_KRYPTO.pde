import controlP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

import java.util.Random;
import java.util.List;
import java.math.BigInteger;

float messageLength, value;
int ascii;
List<Integer> asc = new ArrayList<Integer>();
List<BigInteger> encrypedMessage = new ArrayList<BigInteger>();
List<BigInteger> decryptedMessage = new ArrayList<BigInteger>();
ArrayList<GUI> g = new ArrayList<GUI>();
BigInteger cryptedMessage;
BigInteger bigI;
String decrpyOut = "";

ControlP5 cp5;
GUI gui;

ExtendedEuclidean Euclidean;

void setup() {
  size(800, 600);
  fill(0);
  textSize(14);
  cp5 = new ControlP5(this);
  gui = new GUI();
  Euclidean = new ExtendedEuclidean();
  encr();
  Decrypt();
}


void draw() {
  background(215);
}

/*
* https://www.geeksforgeeks.org/rsa-algorithm-cryptography/
 * https://github.com/ergesmema/RSA-Java/blob/main/src/RSA/RSA.java
 */

void encyptMessage(String message) {
  BigInteger p = BigInteger.valueOf(1031);
  BigInteger q = BigInteger.valueOf(907);
  BigInteger n = p.multiply(q);
  BigInteger phi = p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE)); //(p-1)*(q-1)
  
  int e1;
  // For loop for at regne e
  for (e1 = 2; e1 < phi.intValue(); e1++) {
    BigInteger a = gcd(BigInteger.valueOf(e1), phi);
    // e is for public key exponent
    if (a.intValue() == 1) {
      break;
    }
  }
  BigInteger e = BigInteger.valueOf(e1);
  //Private key exponent
  BigInteger d = Euclidean.modInverse(e, phi); //<>//

  messageLength = message.length();
  for (int i = 0; i < messageLength; i++) {
    char character = message.charAt(i);
    ascii = (int) character;
    asc.add(ascii);
  }

  //Encryption
  for (int i=0; i < asc.size(); i++) {
    BigInteger c = encrypt(asc.get(i), e, n);
    encrypedMessage.add(c);
  }

  //Decryption
  for (int i=0; i < encrypedMessage.size(); i++) {
    BigInteger decrypted = decrypt(encrypedMessage.get(i), d, n);
    decryptedMessage.add(decrypted);
  }
}

/*
* https://github.com/ergesmema/RSA-Java/blob/main/src/RSA/RSA.java
 * Line: 51
 */
public BigInteger gcd(BigInteger a, BigInteger b) {
  if (BigInteger.ZERO.equals(b)) {
    return a;
  }
  BigInteger gcd = gcd(b, a.mod(b));
  return gcd;
}

public BigInteger modPow(BigInteger base, BigInteger exponent, BigInteger mod) {
  if (exponent.equals(BigInteger.ZERO)) {
    return BigInteger.ONE;
  }
  BigInteger z = modPow(base, exponent.divide(BigInteger.TWO), mod);
  if (exponent.mod(new BigInteger("2")).equals(BigInteger.ZERO)) {
    return z.multiply(z).mod(mod);
  } else
    return base.multiply(z.multiply(z)).mod(mod);
}


public BigInteger encrypt(int message, BigInteger e, BigInteger N) {
  return modPow(BigInteger.valueOf(message), e, N);
}

public BigInteger decrypt(BigInteger Cryptedmessage, BigInteger d, BigInteger N) {
  return modPow(Cryptedmessage, d, N);
}


void Decrypt() {
  for ( BigInteger x : decryptedMessage) {
    int xint= x.intValue();
    char str = (char) xint;
    decrpyOut+= str;
  }

  String res = decrpyOut;
  gui.getEncryptedTextField();
  gui.DecryptedMessage(res);
}

void encr() {
  String res = gui.getPlainTextField();
  encyptMessage(res);
  gui.setEncText(encrypedMessage.toString());
}
