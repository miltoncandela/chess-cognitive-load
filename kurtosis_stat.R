
camino <- "C:\\Users\\Milton\\PycharmProjects\\Neuro\\"
df <- read.csv(paste0(camino, 'peaks.csv'))
colnames(df) <- c('ID', 'Kurtosis')

df2 <- read.csv(paste0(camino, 'data\\descriptive_data.csv'))

df[,'Condicion'] <- df2[df2$ID %in% df$ID, 'Condicion']
df[,'ELO'] <- df2[df2$ID %in% df$ID, 'ELO']
# df[df$ID == '35','ELO'] <- df2[df2$ID %in% df$ID, 'ELO']
df[df$ID == '5','ELO'] <- 1100
df[df$ID == '34','ELO'] <- 1000
df[df$ID == '6','ELO'] <- 1580
df[df$ID == '21','ELO'] <- 1100

t.test(df[df2$Condicion == 'Ambiental', 'Kurtosis'],
       df[df2$Condicion == 'Blanco', 'Kurtosis'], 'greater')

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Kurtosis'],
       df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Kurtosis'], 'greater')

t.test(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Kurtosis'],
       df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Kurtosis'], 'greater')

boxplot(df[(df$Condicion == 'Ambiental') & (df$ELO < 1200), 'Kurtosis'],
        df[(df$Condicion == 'Blanco') & (df$ELO < 1200), 'Kurtosis'])

boxplot(df[(df$Condicion == 'Ambiental') & (df$ELO >= 1200), 'Kurtosis'],
        df[(df$Condicion == 'Blanco') & (df$ELO >= 1200), 'Kurtosis'])
