
### Cross tabs
```{r, eval=TRUE}
data(UCBAdmissions)
df <- as.data.frame(UCBAdmissions)
summary(df)
xtabs(Freq ~ Gender + Admit, data=df)
df$rand <- rnorm(nrow(df))
ftable(xtabs(Freq ~ ., data=df)
```




