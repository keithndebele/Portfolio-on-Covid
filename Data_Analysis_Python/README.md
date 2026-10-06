# COVID-19 Data Analysis Using Python

![Python](https://img.shields.io/badge/Python-3.11-blue) ![pandas](https://img.shields.io/badge/pandas-3.x-150458) ![Jupyter](https://img.shields.io/badge/Jupyter-notebook-orange)

An end-to-end analysis of the COVID-19 pandemic across **239 countries and territories** and **562,504 daily records**, built from five relational tables (cases and deaths, location, hospitalization, vaccination, testing). Data runs from January 2020 to July 2026.

## Project goals

Answer practical questions about how countries experienced and responded to the pandemic:

- Which countries carried the heaviest burden, and how did the waves unfold?
- Did stricter government responses change the course of cases?
- How did vaccination rollouts relate to death rates?
- How much pressure did hospitals face, and how far did deaths trail admissions?
- Did testing capacity shape what the case numbers show?
- Which socioeconomic factors line up with outcomes, and can countries be grouped by pandemic profile?

## Key findings

**1. Burden: cases were concentrated in a few countries, and one wave dominated the global curve**
- The **United States (103.4M cases)**, **China (99.4M)** and **India (45.1M)** recorded the most cases by July 2026. Within Africa, **South Africa (4.07M)** had over 3 times the cases of the next country, **Morocco (1.28M)**.
- The global case curve peaked in **December 2022 at about 6.4M cases per day** (7-day average). Asia alone accounted for roughly 6.1M of that peak, consistent with China's end of zero-COVID restrictions.
- The Omicron wave hit almost everywhere within weeks of each other: **Africa, Oceania, North America, South America and Europe all peaked between 10 January and 1 February 2022**.
- Omicron brought about **5 times more daily cases than the January 2021 peak but fewer daily deaths** (roughly 10,500 vs. 15,000), a sign that the link between infections and deaths weakened.
- The highest reported case fatality ratios were in war conflict-affected, low-testing countries: **Yemen (18.1%)**, **Sudan (7.9%)**, **Syria (5.5%)** and **Somalia (5.0%)**. These rates likely reflect undercounted cases rather than deadlier disease.

**2. Policy: stricter rules did not show a consistent short-term effect on cases**
- Across all countries the median correlation between a stringency change and the change in cases was just **0.06 at the same time and 0.00 by 3 to 4 weeks later**, so there is no consistent signal.
- Governments mostly reacted to rising cases with South Africa shows a positive correlation of **0.25** when rules and cases rise together, then turns negative (**-0.11 to -0.12**) 3 to 4 weeks later as cases fall. Brazil shows a delayed dip of **-0.15 to -0.16** at 1 to 2 weeks.
- Lockdown timing is confounded with waves, seasons and variants, so this analysis cannot isolate the policy effect.

**3. Vaccination rollouts lowered death rates, but new virus variants made it tricky to measure the exact impact on their own**
- **134 of 239 countries** reached 50% fully vaccinated, taking a **median of 232 days** from their first dose. The fastest, such as **Israel (92 days), Mongolia (115) and Uruguay (124)**, got there in about four months.
- In the 90 days after a country reached 50% fully vaccinated, the **average case fatality ratio fell 29%, from 1.39% to 0.99%** (96 countries, paired t-test p = 0.026, Wilcoxon p = 0.045). At the 30% milestone the fall was **24%, from 1.77% to 1.34%** (126 countries, p = 0.020).
- Omicron was milder and testing practices changed over the same period, so this is an **association, not proof of vaccine effect**.
- **China (1.32B)** and **India (1.03B)** reported the most people vaccinated, followed by the United States (270M).

**4. Hospitals: deaths trailed admissions by about two weeks, and hospitalizations per case roughly halved**
- Weekly hospital admissions led deaths by a **median of 12 days** (the pooled correlation peaks at **13 days, r ≈ 0.85**), across the 20 countries with enough data. Admissions are a useful early warning for deaths.
- **Hospitalizations per 100 cases fell from 8.6 in the original/Alpha period to 4.4 during Delta and 5.2 during Omicron** (median across countries). Under-detection of cases and home testing in later waves mean the true decline is uncertain.
- Peak ICU occupancy was highest in the **United States (28,891 patients)**, then **Argentina (7,969)**, **France (7,019)**, **Germany (5,761)** and **Spain (4,894)**. These are raw counts, and only a few dozen countries report ICU data.

**5. Testing: positive rates exposed under-testing that case counts hid**
- **54 of 135 countries (40%) averaged a positive rate above 10%**, double the level that signals clear under-testing. The WHO benchmark for adequate testing is 5%.
- **Brazil averaged a 46.9% positive rate** at just 0.53 tests per 1,000 people per day, followed by **Mexico (30.5%)** and **Ecuador (28.4%)**. Raw case counts for these countries understate true infections.At the other end, **Cyprus, Austria and the UAE** ran more than 16 to 22 cumulative tests per person.

**6. Socioeconomic drivers: wealthier, with older populations countries had the highest recorded death rates despite the highest vaccination**
- **GDP per capita correlates moderately with vaccination coverage (r = 0.49)**, **population density only weakly with cases per 100,000 (r = 0.16)**, and **diabetes prevalence essentially not at all with the case fatality ratio (r = -0.08)**.
- K-Means clustering (k = 3, chosen by silhouette score) splits the 150 countries with 1M+ people into three profiles:

| Cluster | Countries | Median age | GDP per capita | Vaccinated | Deaths per million |
|---------|-----------|-----------|----------------|-----------|--------------------|
| Young, lower income | 50 | 19 | $5,244 | 31% | 116 |
| Middle | 43 | 28 | $15,189 | 56% | 1,452 |
| Older, wealthy | 57 | 39 | $50,784 | 72% | 2,358 |

- Recorded deaths per million rose with age and income even as vaccination rose. Population age structure and better death recording are likely drivers, so **recorded deaths in low-income countries are probably undercounted**.

## Data

Five tables, linked by country `code` and `date`:

| Table | Contents | Key columns |
|-------|----------|-------------|
| `CovidDeaths` | Cases, deaths, stringency index, reproduction rate | `total_cases`, `new_deaths_smoothed`, `stringency_index` |
| `Location` | Country attributes | `continent`, `population`, `median_age`, `gdp_per_capita` |
| `Hospitalization` | Hospital and ICU load | `hosp_patients`, `icu_patients` |
| `Vaccination` | Vaccine rollout | `people_fully_vaccinated`, `total_boosters` |
| `Testing` | Testing volume and positivity | `new_tests_smoothed`, `positive_rate` |

**Source:** [Our World in Data COVID-19 dataset](https://github.com/owid/covid-19-data) (CC BY 4.0).

### Getting the data

The raw workbook is too large for GitHub, so it is not included in this repo.

1. Download the dataset from the source above.
2. Save the five tables as sheets named `CovidDeaths`, `Location`, `Hospitalization`, `Vaccination` and `Testing` in one workbook named `Covid19_Data.xlsx`.
3. Run the data preparation notebook, which creates `covid_merged.parquet`.

## Approach

**1. Data preparation** (`COVID19_Exploratory_Analysis.ipynb`)
- Load five Excel sheets, standardize column names and the `code` and `date` join keys.
- Profile data types, missing values and duplicates.
- Check all tables share identical `(code, date)` keys, then left-join onto the deaths table with `validate="one_to_one"` and a row-count assertion so no rows are silently lost or duplicated.
- Save the merged 35-column dataset to Parquet.

**2. Analysis** (`Data_Analysis_On_Python.ipynb`)

| Theme | What it covers |
|-------|----------------|
| **A. Overview** | Global waves, top countries by cases (global, Africa, Europe, Asia), case fatality ratio, continent peak waves |
| **B. Government response** | Stringency vs. cases (lag correlation), reproduction rate over time |
| **C. Vaccination** | Rollout speed, global and per-country vaccination, death rate before vs. after milestones (paired t-test) |
| **D. Hospital pressure** | ICU burden, admissions-to-deaths lag, share of cases hospitalized |
| **E. Testing** | Tests per case, tests per capita, positive rate vs. testing intensity |
| **F. Socioeconomic** | GDP, density and diabetes associations, K-Means country clusters |

### Decisions worth noting

- **Missing values are kept as `NaN`, not filled.** Many countries never reported hospital or testing data, and imputing would invent numbers.
- **Per-capita metrics are used for comparisons** because raw counts favour large countries.
- **Short-window comparisons use a 90-day window** before and after each milestone, with a minimum of 1,000 cases in both windows.
- **Lag analysis uses 14-day changes**, not raw levels, so shared long-run trends do not inflate correlations.

## Tools

Python, pandas, NumPy, Matplotlib, Seaborn, SciPy, scikit-learn, Plotly, Jupyter, Parquet (PyArrow)

## Limitations

- Reporting standards, testing capacity and case definitions differ by country, so cross-country comparisons are imperfect.
- Many countries stopped reporting after 2022, so late-period global totals understate reality.
- Hospital, ICU and testing data are available for only a subset of countries.
- Before/after comparisons and correlations show **association, not causation**. Variants, seasonality and policy changes overlap in time.
- The dataset includes territories (for example Hong Kong, Reunion and Gibraltar) alongside sovereign countries.

