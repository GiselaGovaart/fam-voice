Codebook created on 2025-02-13 at 2025-02-13 17:00:59
================

A codebook contains documentation and metadata describing the contents,
structure, and layout of a data file.

## Dataset description

The data contains 200 cases and 18 variables.

## Codebook

| name              | type      |   n | missing | unique |    mean |  median |    mode | mode_value |     sd |    v |     min |     max |   range |  skew | skew_2se |  kurt | kurt_2se |
|:------------------|:----------|----:|--------:|-------:|--------:|--------:|--------:|:-----------|-------:|-----:|--------:|--------:|--------:|------:|---------:|------:|---------:|
| Subj              | factor    | 200 |    0.00 |     73 |         |         |    3.00 | 1          |        | 0.99 |         |         |         |       |          |       |          |
| MMR               | numeric   | 200 |    0.00 |    200 |    0.84 |    1.24 |    1.24 |            |   6.77 |      |  -24.02 |   17.70 |   41.72 | -0.35 |    -1.02 |  0.61 |     0.90 |
| Group             | factor    | 200 |    0.00 |      3 |         |         |  102.00 | fam        |        | 0.50 |         |         |         |       |          |       |          |
| TestSpeaker       | factor    | 200 |    0.00 |      4 |         |         |   69.00 | S4         |        | 0.67 |         |         |         |       |          |       |          |
| VoiceTrain        | character | 200 |    0.00 |      9 |         |         |   29.00 | 23_2       |        | 0.87 |         |         |         |       |          |       |          |
| TestOrder         | integer   | 200 |    0.00 |      4 | 1764.65 | 1413.00 | 1413.00 |            | 538.69 |      | 1143.00 | 2423.00 | 1280.00 |  0.10 |     0.28 | -1.82 |    -2.67 |
| age               | numeric   | 200 |    0.00 |     26 |    0.00 |    0.20 |    0.20 |            |   1.00 |      |   -2.25 |    1.47 |    3.72 | -0.51 |    -1.49 | -0.70 |    -1.03 |
| sex               | character | 200 |    0.00 |      3 |         |         |  108.00 | m          |        | 0.50 |         |         |         |       |          |       |          |
| nrSpeakersDaily   | numeric   | 200 |    0.00 |     26 |    0.00 |   -0.20 |   -0.20 |            |   1.00 |      |   -0.59 |    7.12 |    7.71 |  4.92 |    14.30 | 28.45 |    41.57 |
| sleepState        | factor    | 200 |    0.00 |      3 |         |         |  185.00 | awake      |        | 0.14 |         |         |         |       |          |       |          |
| BlocksAsleep      | character | 200 |    0.00 |      5 |         |         |  174.00 | 0          |        | 0.24 |         |         |         |       |          |       |          |
| Lab               | character | 200 |    0.00 |      4 |         |         |  163.00 | Charité    |        | 0.31 |         |         |         |       |          |       |          |
| daysVoicetraining | integer   | 197 |    0.01 |     14 |   20.42 |   20.00 |   20.00 |            |   2.59 |      |   15.00 |   28.00 |   13.00 |  0.52 |     1.49 |  0.31 |     0.45 |
| Anmerkungen       | character | 200 |    0.00 |     13 |         |         |  170.00 |            |        | 0.28 |         |         |         |       |          |       |          |
| CommentsProtokoll | character | 200 |    0.00 |     57 |         |         |   29.00 | 0          |        | 0.96 |         |         |         |       |          |       |          |
| mumDist           | numeric   | 200 |    0.00 |    198 |    0.00 |   -0.21 |   -0.21 |            |   1.00 |      |   -1.57 |    3.26 |    4.83 |  0.90 |     2.61 |  0.47 |     0.68 |
| TrialsStan        | numeric   | 200 |    0.00 |     53 |   46.73 |   50.00 |   50.00 |            |  12.53 |      |   13.00 |   70.00 |   57.00 | -0.60 |    -1.74 | -0.27 |    -0.40 |
| TrialsDev         | numeric   | 200 |    0.00 |     28 |   23.39 |   24.00 |   24.00 |            |   6.07 |      |   10.00 |   39.00 |   29.00 | -0.29 |    -0.84 | -0.48 |    -0.70 |

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
