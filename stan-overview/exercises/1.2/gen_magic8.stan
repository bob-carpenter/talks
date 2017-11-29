// simulate Magic 8-Ball
transformed data {
  vector[20] theta = rep_vector(1.0 / 20.0, 20);
}
generated quantities {
  int a = categorical_rng(theta);
  if (a == 1) {
    print("It is certain");
  }
  if (a == 2) {
    print("It is decidedly so");
  }
  if (a == 3) {
    print("Without a doubt");
  }
  if (a == 4) {
    print("Yes definitely");
  }
  if (a == 5) {
    print("You may rely on it");
  }
  if (a == 6) {
    print("As I see it, yes");
  }
  if (a == 7) {
    print("Most likely");
  }
  if (a == 8) {
    print("Outlook good");
  }
  if (a == 9) {
    print("Yes");
  }
  if (a == 10) {
    print("Signs point to yes");
  }
  if (a == 11) {
    print("Reply hazy try again");
  }
  if (a == 12) {
    print("Ask again later");
  }
  if (a == 13) {
    print("Better not tell you now");
  }
  if (a == 14) {
    print("Cannot predict now");
  }
  if (a == 15) {
    print("Concentrate and ask again");
  }
  if (a == 16) {
    print("Don't count on it");
  }
  if (a == 17) {
    print("My reply is no");
  }
  if (a == 18) {
    print("My sources say no");
  }
  if (a == 19) {
    print("Outlook not so good");
  }
  if (a == 20) {
    print("Very doubtful");
  }
}



