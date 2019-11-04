library(ggplot2)
x = seq(0.005, 0.995, 0.005)
y = log(x)
df <- data.frame(x = x, y = y)
plot <- ggplot(df, aes(x = x, y = y)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = c()) +
    scale_y_continuous(breaks = c()) +
    xlab("risk") +
    ylab("expected utility")
plot
ggsave("efficient-frontier.pdf", width = 3, height = 1.5)
