

camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'peaks.csv'))
colnames(df) <- c('ID', 'Value')

df2 <- read.csv(paste0(camino, 'data\\descriptive_data3.csv'))
colnames(df2)[1] <- 'ID'
df <- merge(df, df2, by = 'ID')
create_elo_cat <- function(x){
     if (as.numeric(x) < 1200){return('Novice')} else {return('Expert')}}
df[,'ELO_Cat'] <- as.factor(sapply(df$ELO, create_elo_cat))
df[,'Condicion'] <- as.factor(df$Condicion)

pdf('eloaciertos.pdf', width = 4, height = 4)
plot(df$Aciertos ~ df$ELO, xlim = c(750, max(df$ELO)), ylim = c(-0.5, 4.5),
     xlab = 'ELO', ylab = 'Problems correctly solved', frame.plot = FALSE,
     axes = FALSE, pch = 16)
model <- lm(df$Aciertos ~ df$ELO)
abline(model, col = 2, lwd = 3)
axis(1, at = seq(800, 2000, 400))
axis(2)
legend('topleft', bty = 'n',
       legend = c(paste('R-sqr =', round(summary(model)$r.squared, 2)), 'p < 0.001'))
dev.off()

pdf('eloaciertos2.pdf', width = 5.5, height = 5)
plot(df[df$Condicion == 'Ambiental', 'Aciertos'] ~ df[df$Condicion == 'Ambiental', 'ELO'],
     xlim = c(750, max(df$ELO)), ylim = c(-0.5, 4.5), col = 1,
     xlab = 'ELO', ylab = 'Problems correctly solved', frame.plot = FALSE,
     axes = FALSE, pch = 16)
points(df[df$Condicion == 'Blanco', 'Aciertos'] ~ df[df$Condicion == 'Blanco', 'ELO'],
       pch = 16, col = 2)
model1 <- lm(df[df$Condicion == 'Ambiental', 'Aciertos'] ~ df[df$Condicion == 'Ambiental', 'ELO'])
model2 <- lm(df[df$Condicion == 'Blanco', 'Aciertos'] ~ df[df$Condicion == 'Blanco', 'ELO'])
abline(model1, col = 1, lwd = 3)
abline(model2, col = 2, lwd = 3)
axis(1, at = seq(800, 2000, 400))
axis(2)
legend('topleft', bty = 'n',
       legend = as.expression(c(
            bquote("Quiet; " ~ R^2 == .(round(summary(model1)$r.squared, 2)) * ", p < 0.001"),
            bquote("Noisy; " ~ R^2 == .(round(summary(model2)$r.squared, 2)) * ", p < 0.001")
       )),
       lty = 1, col = c(1, 2), pch = 16)
dev.off()

library(lattice)
xyplot(df$Value ~ df$ELO | df$Condicion)

df <- df[df$Condicion == 'Blanco',]
plot(df$Value ~ df$Aciertos)
model <- lm(df$Value ~ df$Aciertos)
lines(df$Aciertos, df$Aciertos * model$coef[2] + model$coef[1], lwd = 1, col = 'red')

plot(df$Value ~ df$ELO)
model <- lm(df$Value ~ df$ELO)
lines(df$ELO, df$ELO * model$coef[2] + model$coef[1], lwd = 1, col = 'red')

model <- lm(df$Aciertos ~ df$ELO)
lines(df$ELO, df$ELO * model$coef[2] + model$coef[1], lwd = 1, col = 'red')


t.test(df[df2$Condicion == 'Ambiental', 'Value'],
       df[df2$Condicion == 'Blanco', 'Value'], 'greater')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'], 'greater')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'], 'greater')$p.value

summary(with(df, aov(Value ~ Condicion + ELO_Cat)))

# Quiet Novice
t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'], 'two.sided')

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'], 'greater')

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'], 'two.sided')

# Noise Novice
t.test(df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'], 'two.sided')

t.test(df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'], 'two.sided')

# Quiet Expert
t.test(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'], 'greater')


boxplot(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
        df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'])

df_nov <- df[df$ELO < 1200, ]
df_exp <- df[df$ELO >= 1200, ]

df['ELO_Cat'] <- sapply(df$ELO, function(x){if(x < 1200){return('Novice')}else{return('Expert')}})
df['ELO_Cat'] <- factor(df$ELO_Cat, levels = c('Novice', 'Expert'))

pdf('tct_boxplot.pdf', width = 4, height = 5)
par(mar=c(4, 3.8, 4, 4), xpd=TRUE)
with(df, boxplot(Value ~ Condicion + ELO_Cat, col = 'white', ylim = c(45, 108), axes=FALSE,
                 ylab = 'Estimated TRT in seconds (s)', xlab = '', frame.plot = FALSE))
axis(1, at = c(1, 2), labels = c('Quiet', 'Noisy'))
axis(1, at = c(3, 4), labels = c('Quiet', 'Noisy'))
axis(2, at = c(50, 60, 70, 80, 90, 100))
# text(1.5, 40, 'Novice')
# text(3.5, 40, 'Expert')
stripchart(Value ~ Condicion + ELO_Cat, data = df, method = "jitter",
           vertical = TRUE, add = TRUE, pch = c(6, 6, 2, 2), col = c(2, 2, 3, 3))
segments(x0 = 1, x1 = 2, y0 = 107, y1 = 107, lwd = 1, col = 1)
text(1.5, 109, '**', cex=2)
segments(x0 = 1, x1 = 4, y0 = 104, y1 = 104, lwd = 1, col = 1)
text(2.5, 106, '**', cex=2)
segments(x0 = 3, x1 = 4, y0 = 100, y1 = 100, lwd = 1, col = 1)
text(3.5, 102, '*', cex=2)
legend(4.35, 82.5, legend = c('Novice', 'Expert'), pch = c(6, 2), col = c(2, 3), bty = 'n', title = 'Chess level')
legend(3.75, 113, legend = c('*', '**', '***'), bty = 'n')
legend(4.15, 114, legend = c('p < 0.05', 'p < 0.01', 'p < 0.001'), bty = 'n')
dev.off()

# # Aciertos # #

df['Aci_Cat'] <- sapply(df$Aciertos, function(x){if(x < 2){return('LP')}else{return('HP')}})
df['Aci_Cat'] <- factor(df$Aci_Cat, levels = c('LP', 'HP'))

# Quiet Novice
t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Value'], 'two.sided')

t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Value'],
       df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'HP'), 'Value'], 'two.sided')

t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'HP'), 'Value'], 'two.sided')

# Noise Novice
t.test(df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Value'],
       df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'HP'), 'Value'], 'two.sided')

t.test(df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'HP'), 'Value'], 'two.sided')

# Quiet Expert
t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'HP'), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'HP'), 'Value'], 'greater')


boxplot(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Value'],
        df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Value'])

pdf('tctperf.pdf', width = 4, height = 5)
par(mar=c(4, 3.8, 4, 4), xpd=TRUE)
with(df, boxplot(Value ~ Condicion + Aci_Cat, col = 'white', ylim = c(45, 108), axes=FALSE,
                 ylab = 'Estimated TCT in seconds (s)', xlab = '', frame.plot = FALSE))
stripchart(Value ~ Condicion + Aci_Cat, data = df, method = "jitter", pch = c(6, 6, 2, 2),
           col = c(2, 2, 3, 3), vertical = TRUE, add = TRUE)
axis(1, at = c(1, 2), labels = c('Quiet', 'Noisy'))
axis(1, at = c(3, 4), labels = c('Quiet', 'Noisy'))
axis(2, at = c(50, 60, 70, 80, 90, 100))
segments(x0 = 1, x1 = 2, y0 = 107, y1 = 107, lwd = 1, col = 1)
text(1.5, 109, '***', cex=2)
segments(x0 = 1, x1 = 3, y0 = 104, y1 = 104, lwd = 1, col = 1)
text(2, 106, '*', cex=2)
segments(x0 = 1, x1 = 4, y0 = 100, y1 = 100, lwd = 1, col = 1)
text(2.5, 102, '*', cex=2)
legend(4.35, 82.5, legend = c('Low', 'High'),
       pch = c(6, 2), col = c(2, 3), bty = 'n', title = 'Performance')
legend(3.75, 110, legend = c('*', '**', '***'), bty = 'n')
legend(4.15, 111, legend = c('p < 0.05', 'p < 0.01', 'p < 0.001'), bty = 'n')
dev.off()

# # Performance with ELO # #


pdf('aci_barplot.pdf', width = 4, height = 5)
bp <- barplot(tapply(df$Aciertos, list(df$Condicion, df$ELO_Cat), mean)[,c('Novice', 'Expert')], beside = TRUE,
        ylab = 'Problems correctly solved', col = c('grey80', 'grey40'), ylim = c(0, 4))
legend(fill = c('grey80', 'grey40'), legend = c('Quiet', 'Noisy'), 'topleft', bty = 'n')

mmean <- tapply(df$Aciertos, list(df$Condicion, df$ELO_Cat), mean)[,c('Novice', 'Expert')]
msd <- tapply(df$Aciertos, list(df$Condicion, df$ELO_Cat), sd)[,c('Novice', 'Expert')] / sqrt(7)
arrows(bp, mmean - msd, bp, mmean + msd, code = 3, angle = 90, length = 0.15)
text(bp, mmean + 0.75, labels = round(mmean, 3))
dev.off()

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO_Cat == 'Novice'), 'Aciertos'],
        df[(df$Condicion == 'Blanco') & (df$ELO_Cat == 'Novice'), 'Aciertos'], 'greater')

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO_Cat == 'Expert'), 'Aciertos'],
        df[(df$Condicion == 'Blanco') & (df$ELO_Cat == 'Expert'), 'Aciertos'], 'less')


t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Aciertos'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Aciertos'], 'greater')

t.test(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'HP'), 'Aciertos'],
       df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'HP'), 'Aciertos'], 'greater')


boxplot(df[(df$Condicion == 'Ambiental') & (df$Aci_Cat == 'LP'), 'Value'],
        df[(df$Condicion == 'Blanco') & (df$Aci_Cat == 'LP'), 'Value'])

segments(x0 = 1, x1 = 2, y0 = 106, y1 = 106, lwd = 1, col = 1)
text(1.5, 107.5, '**', cex=2)
segments(x0 = 1, x1 = 4, y0 = 103, y1 = 103, lwd = 1, col = 1)
text(2.5, 104.5, '**', cex=2)
segments(x0 = 3, x1 = 4, y0 = 100, y1 = 100, lwd = 1, col = 1)
text(3.5, 101.5, '*', cex=2)
legend(4.35, 82.5, legend = c('Novice', 'Expert'), pch = c(6, 2), col = c(2, 3), bty = 'n', title = 'Chess level')
dev.off()


camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'kurto.csv'))
colnames(df) <- c('ID', 'Value')
df <- merge(df, df2, by = 'ID')
create_elo_cat <- function(x){
     if (as.numeric(x) < 1200){return('Novice')} else {return('Expert')}}
df[,'ELO_Cat'] <- sapply(df$ELO, create_elo_cat)

t.test(df[df2$Condicion == 'Ambiental', 'Value'],
       df[df2$Condicion == 'Blanco', 'Value'], 'greater')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'], 'greater')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'], 'greater')$p.value

boxplot(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Value'],
        df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Value'])

boxplot(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Value'],
        df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Value'])

