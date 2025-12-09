Codebook created on 2025-02-13 at 2025-02-13 17:00:57
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 134 cases and 18 variables.

## Codebook

| name              | type      |   n | missing | unique |    mean |  median |    mode | mode_value |     sd |    v |     min |     max |   range |  skew | skew_2se |  kurt | kurt_2se |
|:------------------|:----------|----:|--------:|-------:|--------:|--------:|--------:|:-----------|-------:|-----:|--------:|--------:|--------:|------:|---------:|------:|---------:|
| Subj              | factor    | 134 |    0.00 |     72 |         |         |    2.00 | 1          |        | 0.99 |         |         |         |       |          |       |          |
| MMR               | numeric   | 134 |    0.00 |    134 |    0.73 |    1.20 |    1.20 |            |   6.19 |      |  -19.64 |   14.68 |   34.32 | -0.25 |    -0.59 |  0.32 |     0.38 |
| Group             | factor    | 134 |    0.00 |      3 |         |         |   69.00 | fam        |        | 0.50 |         |         |         |       |          |       |          |
| TestSpeaker       | factor    | 134 |    0.00 |      3 |         |         |   69.00 | S4         |        | 0.50 |         |         |         |       |          |       |          |
| VoiceTrain        | character | 134 |    0.00 |      9 |         |         |   20.00 | 23_2       |        | 0.87 |         |         |         |       |          |       |          |
| TestOrder         | integer   | 134 |    0.00 |      4 | 1769.49 | 1413.00 | 1413.00 |            | 540.34 |      | 1143.00 | 2423.00 | 1280.00 |  0.09 |     0.21 | -1.83 |    -2.20 |
| age               | numeric   | 134 |    0.00 |     26 |    0.00 |    0.19 |    0.19 |            |   1.00 |      |   -2.25 |    1.48 |    3.73 | -0.52 |    -1.23 | -0.68 |    -0.82 |
| sex               | character | 134 |    0.00 |      3 |         |         |   72.00 | m          |        | 0.50 |         |         |         |       |          |       |          |
| nrSpeakersDaily   | numeric   | 134 |    0.00 |     26 |    0.00 |   -0.21 |   -0.21 |            |   1.00 |      |   -0.56 |    6.33 |    6.89 |  4.67 |    11.16 | 24.45 |    29.41 |
| sleepState        | factor    | 134 |    0.00 |      3 |         |         |  127.00 | awake      |        | 0.10 |         |         |         |       |          |       |          |
| BlocksAsleep      | character | 134 |    0.00 |      5 |         |         |  117.00 | 0          |        | 0.23 |         |         |         |       |          |       |          |
| Lab               | character | 134 |    0.00 |      4 |         |         |  109.00 | Charité    |        | 0.31 |         |         |         |       |          |       |          |
| daysVoicetraining | integer   | 132 |    0.01 |     14 |   20.37 |   20.00 |   20.00 |            |   2.58 |      |   15.00 |   28.00 |   13.00 |  0.54 |     1.28 |  0.34 |     0.40 |
| Anmerkungen       | character | 134 |    0.00 |     13 |         |         |  113.00 |            |        | 0.29 |         |         |         |       |          |       |          |
| CommentsProtokoll | character | 134 |    0.00 |     56 |         |         |   19.00 | 0          |        | 0.96 |         |         |         |       |          |       |          |
| mumDist           | numeric   | 134 |    0.00 |    133 |    0.00 |   -0.34 |   -0.34 |            |   1.00 |      |   -1.41 |    3.27 |    4.68 |  1.02 |     2.44 |  0.48 |     0.58 |
| TrialsStan        | numeric   | 134 |    0.00 |     47 |   47.11 |   50.00 |   50.00 |            |  12.12 |      |   16.00 |   70.00 |   54.00 | -0.43 |    -1.03 | -0.53 |    -0.64 |
| TrialsDev         | numeric   | 134 |    0.00 |     26 |   23.56 |   24.50 |   24.50 |            |   6.04 |      |   11.00 |   39.00 |   28.00 | -0.18 |    -0.44 | -0.69 |    -0.83 |

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
