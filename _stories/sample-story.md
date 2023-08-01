---
title: Story Sample
date: 2023-05-29
description: Amet amet maxime sit neque cumque Maxime explicabo maxime est accusamus exercitationem ad Dolor nulla ipsum rem nemo ab deserunt eligendi quas hic Quo impedit vel perspiciatis quam.
image: stories/story-placeholder.webp
featured: true
featuredOrder: 1
type: test
categories:
  - flamingos
  - zebras
  - antelopes
author:
  - id: mr
  - id: jd
  - id: jc
citation: 
  container-title: Journal of Psychoceramics
  volume: 1
  issue: 1
  doi: 10.5555/12345678
links:
  - header: Data
    links:
    - text: Test
      href: #
      icon: download
  - header: Customs
    links:
    - text: View Data
      href: #
      icon: download
---

Testing out the stories collection.

Cras mattis consectetur purus sit amet fermentum. Maecenas sed diam eget
risus varius blandit sit amet non magna. Donec ullamcorper nulla non
metus auctor fringilla. Aenean eu leo quam. Pellentesque ornare sem
lacinia quam venenatis vestibulum. Cum sociis natoque penatibus et
magnis dis parturient montes, nascetur ridiculus mus.

### Data Visualization

Quarto works well with `library(urbnthemes)` – the Urban Institute’s R
data visualization theme.

Consider an examples using the `cars` dataset, which contains `speed`
and `dist` for 50. **?@fig-histogram** shows two histograms displaying
the distributions of `speed` and `dist` individually.

``` r
ggplot(cars, aes(x = speed)) +
  geom_histogram(bins = 15) +
  labs(title = "Histogram of speeds")

ggplot(cars, aes(x = dist)) +
  geom_histogram(bins = 15) +
  labs(title = "Histogram of distances")
```

<img
src="../../_stories/sample-story_files/figure-commonmark/fig-histogram-1.svg"
id="fig-histogram-1" alt="Figure 1: Histogram of speeds" />

<img
src="../../_stories/sample-story_files/figure-commonmark/fig-histogram-2.svg"
id="fig-histogram-2" alt="Figure 2: Histogram of dists" />

Histograms of individual variables

### Data Tables

The default for df-print is kable. This is the only type of table that
works with the table references. kable works well until there is tons of
data, where paged thrives.

[Table 1](#tbl-stats-kable) displays basic summary statistics for these
two variables.

``` r
cars %>%
  summarise(
    `Median speed` = median(speed),
    `IQR speed` = IQR(speed),
    `Median dist` = median(dist),
    `IQR dist` = IQR(dist),
    `Correlation, r` = cor(speed, dist)
  ) %>%
  kable(digits = c(0, 0, 0, 0, 2))
```

<div id="tbl-stats-kable">

| Median speed | IQR speed | Median dist | IQR dist | Correlation, r |
|-------------:|----------:|------------:|---------:|---------------:|
|           15 |         7 |          36 |       30 |           0.81 |

Table 1: Summary statistics for speed and dist (kable)

</div>

### Diagrams

Quarto has access to Mermaid and Graphviz for creating diagrams. Here is
a simple example from the [Quarto
documentation](https://quarto.org/docs/authoring/diagrams.html):

``` mermaid
flowchart LR
  A[Hard edge] --&gt; B(Round edge)
  B --&gt; C{Decision}
  C --&gt; D[Result one]
  C --&gt; E[Result two]
```

Graphviz

<div>

<div>

<img
src="../../_stories/sample-story_files/figure-commonmark/dot-figure-1.png"
style="width:7in;height:5in" />

</div>

</div>

### Equations

#### First Model

We can fit a simple linear regression model of the form shown in
[Equation 1](#eq-slr).

<span id="eq-slr">

![dist = \hat{\beta}\_0 + \hat{\beta}\_1 \times speed + \epsilon
 \qquad(1)](https://latex.codecogs.com/svg.latex?dist%20%3D%20%5Chat%7B%5Cbeta%7D_0%20%2B%20%5Chat%7B%5Cbeta%7D_1%20%5Ctimes%20speed%20%2B%20%5Cepsilon%0A%20%5Cqquad%281%29 "dist = \hat{\beta}_0 + \hat{\beta}_1 \times speed + \epsilon
 \qquad(1)")

</span>

[Table 2](#tbl-lm) shows the regression output for this model.

``` r
dist_fit <- lm(dist ~ speed, data = cars)
  
dist_fit %>%
  tidy() %>%
  kable(digits = c(0, 0, 2, 2, 2))
```

<div id="tbl-lm">

| term        | estimate | std.error | statistic | p.value |
|:------------|---------:|----------:|----------:|--------:|
| (Intercept) |      -18 |      6.76 |     -2.60 |    0.01 |
| speed       |        4 |      0.42 |      9.46 |    0.00 |

Table 2: Linear regression model for predicting price from area

</div>

#### Second Model

Let’s fit a more complicated multiple linear regression model of the
form shown in [Equation 2](#eq-mlr).

<span id="eq-mlr">

![dist = \hat{\beta}\_0 + \hat{\beta}\_1 \times speed + \hat{\beta}\_2 \times speed ^ 2 + \epsilon
 \qquad(2)](https://latex.codecogs.com/svg.latex?dist%20%3D%20%5Chat%7B%5Cbeta%7D_0%20%2B%20%5Chat%7B%5Cbeta%7D_1%20%5Ctimes%20speed%20%2B%20%5Chat%7B%5Cbeta%7D_2%20%5Ctimes%20speed%20%5E%202%20%2B%20%5Cepsilon%0A%20%5Cqquad%282%29 "dist = \hat{\beta}_0 + \hat{\beta}_1 \times speed + \hat{\beta}_2 \times speed ^ 2 + \epsilon
 \qquad(2)")

</span>

[Table 3](#tbl-lm2) shows the regression output for this model.

``` r
dist_fit2 <- lm(dist ~ poly(speed, degree = 2, raw = TRUE), data = cars)
  
dist_fit2 %>%
  tidy() %>%
  kable(digits = c(0, 0, 2, 2, 2))
```

<div id="tbl-lm2">

| term                                 | estimate | std.error | statistic | p.value |
|:-------------------------------------|---------:|----------:|----------:|--------:|
| (Intercept)                          |        2 |     14.82 |      0.17 |    0.87 |
| poly(speed, degree = 2, raw = TRUE)1 |        1 |      2.03 |      0.45 |    0.66 |
| poly(speed, degree = 2, raw = TRUE)2 |        0 |      0.07 |      1.52 |    0.14 |

Table 3: Second linear regression model for predicting price from area

</div>

<div class="column-body-outset">

Outset content…

</div>

``` r
knitr::kable(
  mtcars[1:6, 1:10]
)
```

|                   |  mpg | cyl | disp |  hp | drat |    wt |  qsec |  vs |  am | gear |
|:------------------|-----:|----:|-----:|----:|-----:|------:|------:|----:|----:|-----:|
| Mazda RX4         | 21.0 |   6 |  160 | 110 | 3.90 | 2.620 | 16.46 |   0 |   1 |    4 |
| Mazda RX4 Wag     | 21.0 |   6 |  160 | 110 | 3.90 | 2.875 | 17.02 |   0 |   1 |    4 |
| Datsun 710        | 22.8 |   4 |  108 |  93 | 3.85 | 2.320 | 18.61 |   1 |   1 |    4 |
| Hornet 4 Drive    | 21.4 |   6 |  258 | 110 | 3.08 | 3.215 | 19.44 |   1 |   0 |    3 |
| Hornet Sportabout | 18.7 |   8 |  360 | 175 | 3.15 | 3.440 | 17.02 |   0 |   0 |    3 |
| Valiant           | 18.1 |   6 |  225 | 105 | 2.76 | 3.460 | 20.22 |   1 |   0 |    3 |
