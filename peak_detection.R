detect_peaks <- function(data, threshold = 0) {
     # Compute the first derivative
     derivative <- diff(data)
     
     # Find sign changes in the derivative (peaks)
     peak_indices <- which(diff(sign(derivative)) < 0)
     
     # Filter peaks by threshold
     peak_indices <- peak_indices[derivative[peak_indices] > threshold]
     
     return(peak_indices)
}

camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'dataNeuro.csv'),
               col.names = colnames(read.csv(paste0(camino, 'dataNeuro.csv'), nrows=1)))
df <- df[df$ID == 2,]
# t <- (1:length(df[, 1]))/(250*60)
t <- 1:length(df[,1])
# data <- (df$Theta_C3 + df$Theta_C4)/2
data <- df$Theta_C4
# data <- (df$Theta_Fz + df$Theta_C3 + df$Theta_Cz + df$Theta_C4)/4
# data <- df$Theta_C4/df$Alpha_C4
# data <- df$Alpha_Pz/df$Theta_C4
# data <- (df$Theta_Fz/df$Alpha_Pz)
smoothing_span <- 3
smoothed_data <- smooth.spline(seq_along(data), data, spar = 1 - 1 / smoothing_span)
smoothed_values <- predict(smoothed_data)$y
# moothed_values <- (smoothed_values - mean(smoothed_values))/sd(smoothed_values)

for (i in 1:4){
#     smoothed_values[((i-1)*150+1):(i*150)] <- mean(smoothed_values[((i-1)*150+1):(i*150)])*-1 + smoothed_values[((i-1)*150+1):(i*150)]
     print( mean(smoothed_values[((i-1)*150+1):(i*150)]))
}
# smoothed_values[smoothed_values < 0] <- 0

# Set a threshold (optional)
threshold <- 0

# Detect peaks
peaks <- detect_peaks(smoothed_values, threshold)
peaks

# png('thetaC4_subject1.png', height = 360)
plot(t, smoothed_values, type = 'l', xlab = 'Time (seconds)',
     ylab = expression(paste(theta, ' C4 (', mu, 'V)')),
     axes = FALSE)
axis(side = 1)
axis(side = 2)
for (i in 1:4){abline(v = 150*i, lwd = 2, lty = 2, col = 'red')}
# dev.off()
