# corr_matrix

## 使い方

### Pearson 積率相関係数

Iris の 4 変数(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)間の Pearson 積率相関係数を算出

#### 可視化

```
iris %>%
  draw_corr_matrix()
```

![Pearson](https://github.com/you1025/corr_matrix/blob/images/images/pearson_corr_matrix.png)

#### DataFrame の取得

```
iris %>%
  draw_corr_matrix(as.data.frame = T))
```

|val1         |val2         |       corr|
|:------------|:------------|----------:|
|Sepal.Length |Sepal.Length |  1.0000000|
|Sepal.Width  |Sepal.Length | -0.1175698|
|Petal.Length |Sepal.Length |  0.8717538|
|Petal.Width  |Sepal.Length |  0.8179411|
|Sepal.Length |Sepal.Width  | -0.1175698|


### その他の連関

#### MIC

[MIC - Detecting Novel Associations in Large Data Sets](http://lectures.molgen.mpg.de/algsysbio12/MINEPresentation.pdf)

```
iris %>%
  draw_corr_matrix(f.corr = function(df) { minerva::mine(df)$MIC })
```

![MIC](https://github.com/you1025/corr_matrix/blob/images/images/mic_corr_matrix.png)
