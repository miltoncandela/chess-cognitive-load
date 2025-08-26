
df <- read.csv('C:/Users/Milton/PycharmProjects/Neuro/dataNeuroM.csv')

t.test(df[df$Condicion == 'Ambiental', 'Theta_C4'],
       df[df$Condicion == 'Blanco', 'Theta_C4'], 'less')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO_Cat == 'Bueno'), 'Theta_C4'],
       df[(df$Condicion == 'Blanco') & (df$ELO_Cat == 'Bueno'), 'Theta_C4'], 'less')$p.value

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO_Cat == 'Malo'), 'Theta_C4'],
       df[(df$Condicion == 'Blanco') & (df$ELO_Cat == 'Malo'), 'Theta_C4'], 'less')$p.value

boxplot(Theta_C4 ~ Condicion + ELO_Cat, data = df)

png('bueno.png', width = 240)
boxplot(Theta_C4 ~ Condicion, data = df[df$ELO_Cat == 'Bueno',], main = 'Good',
        xlab = 'Noise type', names.arg = c('Ambiental', 'White'),
        ylab = expression(paste('Theta C4 (', mu, V^2, '/ Hz)')))
dev.off()

png('malo.png', width = 240)
boxplot(Theta_C4 ~ Condicion, data = df[df$ELO_Cat == 'Malo',], main = 'Bad',
        xlab = 'Noise type', names.arg = c('Ambiental', 'White'),
        ylab = expression(paste('Theta C4 (', mu, V^2, '/ Hz)')))
text(1.5, 1, '*', cex = 3)
dev.off()

print(df)



library(lattice)

bwplot(Theta_C4 ~ Condicion | ELO_Cat, data=df)
bwplot(Theta_C4 ~ Condicion, data=df)
xyplot(Theta_C4 ~ Gamma_C4 | Condicion + ELO_Cat, data = df, xlim = c(-0.2, 0.6), ylim = c(-0.2, 0.6))
xyplot(Theta_C4 ~ Gamma_C4 | Condicion, data = df)

t.test(df[df$Condicion == 'Ambiental', 'Theta_C4'], df[df$Condicion == 'Blanco', 'Theta_C4'])

