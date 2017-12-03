// simulate Magic 8-Ball
transformed data {
  vector[20] theta = rep_vector(1.0 / 20.0, 20);
}
generated quantities {
  int ans = categorical_rng(theta);
  if (ans == 1) print("It is certain");
  if (ans == 2) print("It is decidedly so");
  if (ans == 3) print("Without a doubt");
  if (ans == 4) print("Yes definitely");
  if (ans == 5) print("You may rely on it");
  if (ans == 6) print("As I see it, yes");
  if (ans == 7) print("Most likely");
  if (ans == 8) print("Outlook good");
  if (ans == 9) print("Yes");
  if (ans == 10) print("Signs point to yes");
  if (ans == 11) print("Reply hazy try again");
  if (ans == 12) print("Ask again later");
  if (ans == 13) print("Better not tell you now");
  if (ans == 14) print("Cannot predict now");
  if (ans == 15) print("Concentrate and ask again");
  if (ans == 16) print("Don't count on it");
  if (ans == 17) print("My reply is no");
  if (ans == 18) print("My sources say no");
  if (ans == 19) print("Outlook not so good");
  if (ans == 20) print("Very doubtful");
}
