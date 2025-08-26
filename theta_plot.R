pdf('thetaboth.pdf', width = 10, 4)
# png('thetaboth.png', width = 480*2, 360)
par(mfrow=c(1,2))

camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'dataNeuro.csv'),
               col.names = colnames(read.csv(paste0(camino, 'dataNeuro.csv'), nrows=1)))
df <- df[df$ID == 1,]
# t <- (1:length(df[, 1]))/(250*60)
t <- 1:length(df[,1])
data <- df$Theta_C4
smoothing_span <- 3
smoothed_data <- smooth.spline(seq_along(data), data, spar = 1 - 1 / smoothing_span)
smoothed_values <- predict(smoothed_data)

# png('thetaC4_subject1.png', height = 360)
plot(t/60, smoothed_values$y, type = 'l', xlab = 'Time (minutes)',
     ylim = c(-0.15, 0.7),
     ylab = expression(paste(theta, ' C4 Power (', mu, 'V^2/Hz)')),
     axes = FALSE, lwd = 2)
axis(side = 1)
axis(side = 2)
for (i in 1:4){abline(v = 150*i/60, lwd = 2, lty = 2, col = 'red')}
text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, 0.6,
     c('L1', 'L2', 'H1', 'H2'))
# text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, 0.7,
#      c('(Correct)', '(Incorrect)', '(Incorrect)', '(Incorrect)'))
# text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, 0.7,
#      c(expression(symbol(("\326"))), "o", "o", "o"))
points(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, rep(0.7, 4),
       pch = c(1, 4, 4, 4), cex = 1.5)
lines(c(0, 60)/60, c(0, 0), lwd = 2); text(30/60, -0.05, 'TRT')
# lines(c(150, 219)/60, c(0, 0), lwd = 2); text(180/60, -0.05, 'TCT')
# lines(c(300, 326)/60, c(0, 0), lwd = 2); text(330/60, -0.05, 'TCT')
# lines(c(450, 528)/60, c(0, 0), lwd = 2); text(480/60, -0.05, 'TCT')
points(c(51, 219, 326, 528)/60, c(0.301885, 0.389831, 0.5311326, 0.2459819),
       pch = 8, cex = 1.5, col = 'red')

camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'dataNeuro.csv'),
               col.names = colnames(read.csv(paste0(camino, 'dataNeuro.csv'), nrows=1)))
df <- df[df$ID == 2,]
# t <- (1:length(df[, 1]))/(250*60)
t <- 1:length(df[,1])
data <- df$Theta_C4
smoothing_span <- 3
smoothed_data <- smooth.spline(seq_along(data), data, spar = 1 - 1 / smoothing_span)
smoothed_values <- predict(smoothed_data)

plot(t/60, smoothed_values$y, type = 'l', xlab = 'Time (minutes)',
     # ylab = expression(paste(theta, ' C4 Power (', mu, 'V^2/Hz)')), ylim = c(-0.15, 0.7),
     ylab = expression(paste(theta, ' C4 Power (', mu, 'V^2/Hz)')), ylim = c(-0.15, 0.7),
     axes = FALSE, lwd = 2)
axis(side = 1)
axis(side = 2)
for (i in 1:4){abline(v = 150*i/60, lwd = 2, lty = 2, col = 'red')}
text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, 0.6,
     c('H2', 'H1', 'L2', 'L1'))
# text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, 0.7,
#      c('(Correct)', '(Correct)', '(Incorrect)', '(Correct)'))
points(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, rep(0.7, 4),
       pch = c(1, 1, 4, 1), cex = 1.5)
points(c(62, 204, 397, 531)/60, c(-0.01052066, 0.1134481, 0.5502092, 0.01497236),
       pch = 8, cex = 1.5, col = 'red')
# lines(c(150, 204)/60, c(0, 0), lwd = 2); text(180/60, -0.05, 'TRT')
dev.off()

# camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
# df <- read.csv(paste0(camino, 'dataNeuro.csv'),
#                col.names = colnames(read.csv(paste0(camino, 'dataNeuro.csv'), nrows=1)))
# df <- df[df$ID == 27,]
# # t <- (1:length(df[, 1]))/(250*60)
# t <- 1:length(df[,1])
# data <- df$Theta_C4
# smoothing_span <- 3
# smoothed_data <- smooth.spline(seq_along(data), data, spar = 1 - 1 / smoothing_span)
# smoothed_values <- predict(smoothed_data)
# 
# # png('thetaC4_subject1.png', height = 360)
# plot(t/60, smoothed_values$y, type = 'l', xlab = 'Time (minutes)',
#      ylab = '',
#      axes = FALSE, ylim = c(-0.6, -0.1), lwd = 2)
# axis(side = 1)
# axis(side = 2)
# for (i in 1:4){abline(v = 150*i/60, lwd = 2, lty = 2, col = 'red')}
# text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, -0.15,
#      c('E1', 'D1', 'E2', 'D2'))
# text(c(150*0+150/2, 150*1+150/2, 150*2+150/2, 150*3+150/2)/60, -0.12,
#      c('(Correct)', '(Incorrect)', '(Incorrect)', '(Incorrect)'))
# dev.off()