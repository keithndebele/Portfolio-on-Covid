# COVID-19 Machine Learning Portfolio

**An end-to-end machine learning project exploring COVID-19 mortality, forecasting, outbreak detection, country similarity, and model deployment.**

This project applies machine learning to a dataset covering **239 countries and territories and 562,504 daily records**. It demonstrates regression, classification, time-series forecasting, anomaly detection, dimensionality reduction, similarity search, model evaluation, and deployment fundamentals.

This is **Part 3** of my COVID-19 analytics portfolio. It builds on the data preparation and merging workflow from Part 1 and the exploratory data analysis from Part 2.

## Project Objectives

The goal is to investigate how machine learning can help analyze historical COVID-19 patterns, forecast reported outcomes, identify unusual observations, and discover similarities between countries.

The project emphasizes not only model performance but also validation, reproducibility, interpretability, and responsible use of data.

## Technical Skills Demonstrated

- **Python:** pandas, NumPy, SciPy
- **Machine Learning:** scikit-learn, regression, classification, clustering-related dimensionality reduction, anomaly detection
- **Forecasting:** lag features, rolling averages, walk-forward validation, time-based train/test splits
- **Model Evaluation:** MAE, RMSE, R², ROC-AUC, PR-AUC, accuracy, precision, recall, and F1-score
- **Model Interpretation:** permutation importance, partial dependence, and error analysis
- **Data Processing:** missing-value handling, log transformations, feature engineering, and Parquet
- **Model Deployment Fundamentals:** scikit-learn pipelines, joblib, model cards, and reusable prediction functions
- **Visualization:** Matplotlib and Seaborn
- **Development:** Jupyter Notebook, Git, and GitHub
---

## The 9 Machine Learning Questions

| # | Research question | Technique | Validation approach |
|---|---|---|---|
| 1 | Can a country's recorded COVID-19 death burden be predicted from its pre-pandemic characteristics? | Regression | Repeated 5-fold cross-validation |
| 2 | Which characteristics contribute most to the model's predictions? | Model explainability | Permutation importance on held-out folds |
| 3 | Can countries be classified into high- and low-death-burden groups? | Classification | Repeated stratified 5-fold cross-validation |
| 4 | Can we forecast a country's COVID-19 cases 14 days ahead? | Time-series forecasting | Walk-forward validation with a 14-day gap |
| 5 | Can one model forecast deaths 14 days ahead across multiple countries? | Panel forecasting | Train on 2020–2021, test on 2022, and evaluate country-level generalization |
| 6 | Can we identify potential case surges 14 days in advance? | Early-warning classification | Time-ordered training, validation, and test periods |
| 7 | Can we identify unusual country-day observations in reported COVID-19 data? | Anomaly detection | Unsupervised detection followed by manual review |
| 8 | Which countries have pandemic profiles most similar to South Africa's? | Similarity search and PCA | Comparative profile analysis |
| 9 | Can the final model be packaged and reused reliably? | Pipelines and model persistence | Model reload and prediction consistency checks |

---

## Key Findings

The following findings are based on the experiments recorded in this project. They describe model results on the available historical data and should not be interpreted as causal or clinical conclusions.

### 1. Predicting COVID-19 Death Burden

The best reported regression model was a Support Vector Regressor (RBF kernel).

- Cross-validated R²: **0.51 ± 0.19**
- Baseline R²: **0.00**
- Typical prediction error: approximately **650 deaths per million**

The classification model achieved:

- ROC-AUC: **0.90**
- Accuracy: **82%**

Countries with some of the largest prediction errors included Peru, North Macedonia, and Bosnia and Herzegovina. The model substantially under-predicted their recorded death burden, suggesting that the selected structural features did not capture all relevant differences in mortality outcomes.

### 2. Understanding the Model's Predictions

Permutation importance identified the following leading predictors:

1. Median age
2. GDP per capita
3. Population density

Partial dependence analysis showed a positive relationship between median age and the model's predicted death burden.

This provides a useful interpretability check, but feature importance and partial dependence do not establish causation. The results may also reflect confounding factors and differences in reporting, healthcare access, and other unmeasured characteristics.

### 3. Forecasting COVID-19 Cases and Deaths

**Single-country case forecasting**

For Germany, Linear Regression reduced the reported 14-day-ahead MAE by approximately **43%** compared with the persistence baseline:

- Linear Regression MAE: 7,943 cases per day
- Persistence baseline MAE: 13,977 cases per day

**Cross-country death forecasting**

The Gradient Boosting model reduced the reported error by **9%** compared with persistence on the 2022 test period.

The project also reports an R² of **0.52** for the 14-day change when testing on countries excluded from model training. This result should be interpreted alongside the evaluation method, target definition, and country-level sample sizes.

Recent hospital data and case trends were among the strongest predictors, including `hosp_now`, `cases_growth_7`, and `cases_growth_14`.

### 4. Early Warning for Case Surges

A surge was defined as reported cases at least **50% higher after 14 days**, according to the project's target definition.

On the 2022 test period:

- Surge prevalence: **17.9%**
- Best reported model: Gradient Boosting
- PR-AUC: **0.64**
- Random-guess PR-AUC baseline: **0.18**
- Simple rising-cases rule: **0.45 PR-AUC**

At the decision threshold selected using validation data, alerts achieved **63% precision** and detected **56% of actual surges**.

This highlights a practical trade-off: the model can identify potentially useful warning signals, but it still misses a substantial proportion of surges. It should not be treated as a validated public-health alert system.

### 5. Anomaly Detection and Country Similarity

The anomaly detector flagged **218 country-day observations**:

- 157 potential spikes
- 61 potential drops

The flagged observations included periods in early 2020 and during major variant waves. Reunion, Turkey, and China were among the countries with frequent flags.

These observations are candidates for further investigation, not confirmed reporting errors.

The similarity analysis identified Kosovo, Eswatini, and Djibouti among the countries with profiles most similar to South Africa under the selected features and methodology. Similarity depends on feature selection, scaling, missing-data handling, and the period represented.

### 6. Reusable Model Deployment

The final saved pipeline was reloaded and tested for prediction consistency.

The reported cross-validated performance was:

- R²: **0.51**
- MAE: approximately **650 deaths per million**

Example predictions for hypothetical country profiles were approximately 2,516 deaths per million for an older, higher-income profile and 55 for a younger, lower-income profile.

These are outputs from the fitted model, not forecasts of actual countries or reliable estimates of individual risk. They should be interpreted within the model's training data and limitations.

---

## Methodology and Design Decisions

### Preventing Data Leakage

Data leakage can make a model appear more accurate than it really is.

This project uses several safeguards:

- Imputation, scaling, and transformations are fitted within scikit-learn pipelines where applicable.
- Forecasting features use historical information available at prediction time.
- Time-ordered validation and appropriate gaps are used for forecasting tasks.
- Surge decision thresholds are selected on validation data, not the final test set.
- Country-level models use pre-pandemic characteristics to reduce the risk of using information derived from the outcomes being predicted.
- Baseline models provide a reference point for evaluating whether machine learning adds value.

### Forecasting Changes Rather Than Only Levels

For selected forecasting tasks, models predict the 14-day change in log cases or deaths rather than simply predicting the future level.

This approach helps the model learn changes in reported outcomes and provides a more informative comparison against persistence. Forecasting performance is evaluated using a held-out period rather than training performance alone.

### Handling Missing and Skewed Data

- Missing values are handled within model pipelines or by estimators that support missing values.
- Skewed variables, including GDP per capita, population density, and death-rate targets, may be log-transformed where appropriate.
- Model evaluation includes variability across validation folds where repeated cross-validation is used.

### Using Appropriate Evaluation Metrics

Different machine learning tasks require different metrics:

- **Regression:** MAE, RMSE, and R²
- **Classification:** precision, recall, F1-score, ROC-AUC, and PR-AUC
- **Forecasting:** comparison against persistence and other simple baselines
- **Anomaly detection:** inspection and validation of flagged observations
- **Deployment:** consistency checks after reloading the saved pipeline

## Limitations and Responsible Use

- **Limited country-level sample size:** country-level models have approximately 150 training observations, so cross-validation results may vary substantially between folds.
- **Under-reporting:** recorded cases and deaths do not necessarily represent the true burden of COVID-19 in every country.
- **Changing pandemic conditions:** models trained on 2020–2021 and tested on 2022 may perform differently during other periods, including waves associated with new variants.
- **Limited transferability:** surge rates, reporting practices, healthcare systems, and population characteristics differ across countries and time periods.
- **Correlation is not causation:** feature importance, coefficients, and partial dependence plots describe model relationships rather than causal effects.
- **Anomaly uncertainty:** flagged observations require review and may reflect genuine outbreaks, changes in reporting, or data quality issues.
- **Hypothetical profiles:** example predictions should not be treated as verified outcomes for real countries.
- **No clinical or policy use:** this is an educational portfolio project, not a validated tool for medical decisions, hospital operations, or public-health policy.

---

## Future Improvements

Potential extensions include:

- Compare the current models with XGBoost or LightGBM.
- Add SHAP explanations to investigate individual predictions.
- Develop forecast intervals using quantile regression.
- Add probability calibration and calibration curves for surge classification.
- Build a small Streamlit application for interactive model exploration.
- Automate model evaluation and regression tests.
- Document dataset sources, licensing, and data-refresh procedures.

---
