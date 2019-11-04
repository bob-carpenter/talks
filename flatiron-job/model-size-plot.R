library(ggplot2)
y <- seq(-3, 3, by = 0.05)
p_y <- dnorm(y)
plot <- ggplot(data.frame(y = y, p_y = p_y), aes(x = y, y = p_y)) +
  geom_line(size = 1) +
  scale_x_continuous(breaks = c(-3, -2, -1, 0, 1, 2, 3),
                     labels = c("0", "1e0", "1e3", "1e6", "1e9",
		                "1e12", "1e15")) +
  scale_y_continuous(breaks = c()) +
  xlab("data size") +
  ylab("max model complexity")
ggsave("img/model-size.pdf", height=2, width = 4)
