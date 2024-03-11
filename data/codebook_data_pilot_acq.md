Codebook created on 2024-03-11 at 2024-03-11 18:40:37
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 39 cases and 4 variables.

## Codebook

| name        | type      |   n | missing | unique | mean | median |  mode | mode_value |   sd |    v |    min |   max | range | skew | skew_2se | kurt | kurt_2se |
|:------------|:----------|----:|--------:|-------:|-----:|-------:|------:|:-----------|-----:|-----:|-------:|------:|------:|-----:|---------:|-----:|---------:|
| Subj        | factor    |  39 |       0 |     14 |      |        |  3.00 | 01         |      | 0.92 |        |       |       |      |          |      |          |
| Group       | character |  39 |       0 |      3 |      |        | 21.00 | unfam      |      | 0.50 |        |       |       |      |          |      |          |
| TestSpeaker | factor    |  39 |       0 |      4 |      |        | 13.00 | S1         |      | 0.67 |        |       |       |      |          |      |          |
| MMR         | numeric   |  39 |       0 |     39 | 3.55 |   2.33 |  2.33 |            | 16.4 |      | -44.45 | 47.64 |  92.1 | 0.16 |     0.21 | 1.54 |     1.04 |

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
