Codebook created on 2024-02-22 at 2024-02-22 16:11:38
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 39 cases and 4 variables.

## Codebook

| name        | type      |   n | missing | unique | mean | median |  mode | mode_value |   sd |    v |    min |   max | range |  skew | skew_2se | kurt | kurt_2se |
|:------------|:----------|----:|--------:|-------:|-----:|-------:|------:|:-----------|-----:|-----:|-------:|------:|------:|------:|---------:|-----:|---------:|
| Subj        | factor    |  39 |       0 |     14 |      |        |  3.00 | 01         |      | 0.92 |        |       |       |       |          |      |          |
| Group       | character |  39 |       0 |      3 |      |        | 21.00 | unfam      |      | 0.50 |        |       |       |       |          |      |          |
| TestSpeaker | factor    |  39 |       0 |      4 |      |        | 13.00 | S1         |      | 0.67 |        |       |       |       |          |      |          |
| MMR         | numeric   |  39 |       0 |     39 | 1.96 |   1.84 |  1.84 |            | 6.86 |      | -22.58 | 21.27 | 43.85 | -0.53 |    -0.69 | 3.77 |     2.54 |

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
