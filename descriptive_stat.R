# ss


#camino <- 'D:/El HDD/Python/Repos/Neuro/'
camino <- 'C:/Users/Milton/PycharmProjects/Neuro/data/'

library(lattice)

df <- read.csv(paste0(camino, 'information_pruned.csv'))

bwplot(Aciertos ~ Horas, data = df, xlab = "Aciertos", ylab = "Correct answers")
bwplot(Aciertos ~ Horas | Nivel, data = df, xlab = "Aciertos", ylab = "Correct answers")

bwplot(Aciertos ~ Nivel, data = df, xlab = "Aciertos", ylab = "Correct answers")

boxplot(Aciertos ~ Frecuencia*Nivel, data = df, col = c("white", "grey"), frame = FALSE)

bwplot(Aciertos ~ Condicion | Nivel, data = df, col = "white", frame = FALSE,
        xlab = 'Sleep habits', ylab = 'Correct answers')


#png('imagen.png')
boxplot(Aciertos ~ Horas*Nivel, data = df, col = "white", frame = FALSE,
        xlab = 'Sleep habits', ylab = 'Correct answers', names.arg = c('< 8 h', '> 8 h'))
#dev.off()

summary(aov(Aciertos ~ Condicion + Frecuencia + Cafes + Horas + Ansiedad_Cat, data = df[df$Nivel == 'Proficient',]))
TukeyHSD(aov(Aciertos ~ Frecuencia*Nivel, data = df))

table(df$Condicion, df$Nivel)

bwplot(Aciertos ~ Condicion | Nivel, data = df, col = "white", frame = FALSE,
       xlab = 'Sleep habits', ylab = 'Correct answers')

pdf('boxplot.pdf', width = 3.5, height = 5)
boxplot(Aciertos ~ Condicion*Nivel, data = df, col = c('azure2', 'white'), frame = FALSE,
        ylab = 'Correct answers', names = c('AN', 'WN', 'AN', 'WN'),
        ylim = c(0, 4.5), xlab = '')
abline(v = 2.5, lty = 2)
text(1.5, 4.5, 'Novice')
text(3.5, 4.5, 'Proficent')
text(1.5, 3.5, '*', cex=1.5)
dev.off()

wilcox.test(df[(df$Nivel=='Novice') & (df$Condicion=='Ambiental'),'Aciertos'],
            df[(df$Nivel=='Novice') & (df$Condicion=='Blanco'), 'Aciertos'],
            alternative = 'greater')




