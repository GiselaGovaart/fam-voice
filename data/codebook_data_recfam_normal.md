Codebook created on 2025-02-13 at 2025-02-13 17:01:01
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 102 cases and 18 variables.

## Codebook

| name              | type      |   n | missing | unique |    mean |  median |    mode | mode_value |     sd |    v |     min |     max |   range |  skew | skew_2se |  kurt | kurt_2se |
|:------------------|:----------|----:|--------:|-------:|--------:|--------:|--------:|:-----------|-------:|-----:|--------:|--------:|--------:|------:|---------:|------:|---------:|
| Subj              | factor    | 102 |       0 |     38 |         |         |    3.00 | 1          |        | 0.97 |         |         |         |       |          |       |          |
| MMR               | numeric   | 102 |       0 |    102 |    1.08 |    1.43 |    1.43 |            |   6.89 |      |  -24.60 |   14.50 |   39.10 | -0.41 |    -0.87 |  0.88 |     0.93 |
| Group             | factor    | 102 |       0 |      2 |         |         |  102.00 | fam        |        | 0.00 |         |         |         |       |          |       |          |
| TestSpeaker       | factor    | 102 |       0 |      4 |         |         |   35.00 | S4         |        | 0.67 |         |         |         |       |          |       |          |
| VoiceTrain        | character | 102 |       0 |      9 |         |         |   18.00 | 13_1       |        | 0.87 |         |         |         |       |          |       |          |
| TestOrder         | integer   | 102 |       0 |      4 | 1803.98 | 1413.00 | 1413.00 |            | 540.85 |      | 1143.00 | 2423.00 | 1280.00 | -0.02 |    -0.03 | -1.85 |    -1.95 |
| age               | numeric   | 102 |       0 |     17 |    0.00 |    0.19 |    0.19 |            |   1.00 |      |   -1.92 |    1.42 |    3.34 | -0.46 |    -0.96 | -0.91 |    -0.96 |
| sex               | character | 102 |       0 |      3 |         |         |   58.00 | m          |        | 0.49 |         |         |         |       |          |       |          |
| nrSpeakersDaily   | numeric   | 102 |       0 |     17 |    0.00 |   -0.20 |   -0.20 |            |   1.00 |      |   -0.56 |    6.67 |    7.23 |  5.80 |    12.13 | 35.85 |    37.83 |
| sleepState        | factor    | 102 |       0 |      3 |         |         |   92.00 | awake      |        | 0.18 |         |         |         |       |          |       |          |
| BlocksAsleep      | character | 102 |       0 |      5 |         |         |   84.00 | 0          |        | 0.31 |         |         |         |       |          |       |          |
| Lab               | character | 102 |       0 |      4 |         |         |   87.00 | Charité    |        | 0.26 |         |         |         |       |          |       |          |
| daysVoicetraining | integer   | 102 |       0 |     11 |   20.11 |   20.00 |   20.00 |            |   2.58 |      |   16.00 |   28.00 |   12.00 |  1.08 |     2.26 |  1.12 |     1.18 |
| Anmerkungen       | character | 102 |       0 |      8 |         |         |   88.00 |            |        | 0.25 |         |         |         |       |          |       |          |
| CommentsProtokoll | character | 102 |       0 |     31 |         |         |   18.00 | 0          |        | 0.94 |         |         |         |       |          |       |          |
| mumDist           | numeric   | 102 |       0 |    102 |    0.00 |   -0.21 |   -0.21 |            |   1.00 |      |   -1.59 |    3.26 |    4.85 |  0.90 |     1.87 |  0.56 |     0.59 |
| TrialsStan        | numeric   | 102 |       0 |     48 |   45.74 |   50.00 |   50.00 |            |  13.20 |      |   13.00 |   70.00 |   57.00 | -0.57 |    -1.20 | -0.49 |    -0.51 |
| TrialsDev         | numeric   | 102 |       0 |     27 |   23.29 |   24.00 |   24.00 |            |   6.68 |      |   10.00 |   39.00 |   29.00 | -0.25 |    -0.52 | -0.66 |    -0.70 |

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
