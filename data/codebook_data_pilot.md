Codebook created on 2023-03-23 at 2023-03-23 14:36:51
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 78 cases and 4 variables.

## Codebook

| name      | type      |   n | missing | unique | mean | median |  mode | mode_value |   sd |    v |    min |   max | range |  skew | skew_2se |  kurt | kurt_2se |
|:----------|:----------|----:|--------:|-------:|-----:|-------:|------:|-----------:|-----:|-----:|-------:|------:|------:|------:|---------:|------:|---------:|
| subj      | factor    |  78 |       0 |     14 |      |        |  6.00 |          1 |      | 0.92 |        |       |       |       |          |       |          |
| condition | character |  78 |       0 |      3 |      |        | 39.00 |         10 |      | 0.50 |        |       |       |       |          |       |          |
| speaker   | character |  78 |       0 |      4 |      |        | 26.00 |          1 |      | 0.67 |        |       |       |       |          |       |          |
| amplitude | numeric   |  78 |       0 |     78 | 1.97 |   3.18 |  3.18 |            | 8.45 |      | -21.08 | 19.26 | 40.34 | -0.54 |    -0.99 | -0.07 |    -0.07 |

### Legend

- **Name**: Variable name
- **type**: Data type of the variable
- **missing**: Proportion of missing values for this variable
- **unique**: Number of unique values
- **mean**: Mean value
- **median**: Median value
- **mode**: Most common value (for categorical variables, this shows the
  frequency of the most common category)
- **mode_value**: For categorical variables, the value of the most
  common category
- **sd**: Standard deviation (measure of dispersion for numerical
  variables
- **v**: Agresti’s V (measure of dispersion for categorical variables)
- **min**: Minimum value
- **max**: Maximum value
- **range**: Range between minimum and maximum value
- **skew**: Skewness of the variable
- **skew_2se**: Skewness of the variable divided by 2\*SE of the
  skewness. If this is greater than abs(1), skewness is significant
- **kurt**: Kurtosis (peakedness) of the variable
- **kurt_2se**: Kurtosis of the variable divided by 2\*SE of the
  kurtosis. If this is greater than abs(1), kurtosis is significant.

This codebook was generated using the [Workflow for Open Reproducible
Code in Science (WORCS)](https://osf.io/zcvbs/)
