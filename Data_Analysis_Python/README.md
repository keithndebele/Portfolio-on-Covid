# COVID-19 Exploratory Data Analysis

An end-to-end analysis of the COVID-19 pandemic across 200+ countries, built from five relational tables (cases and deaths, location, hospitalization, vaccination, testing) and more than 560,000 daily records.

## Project goals

Answer practical questions about how countries experienced and responded to the pandemic:

- Which countries were hit hardest once adjusted for population?
- Did stricter government responses reduce transmission?
- How did vaccination rollouts relate to death rates and hospital pressure?
- Do socioeconomic factors such as GDP, median age and diabetes prevalence explain outcomes?

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
2. Save the five tables as sheets named `CovidDeaths`, `Location`, `Hospitalization`, `Vaccination` and `Testing` in one workbook.
3. Place it at `data/raw/Covid19_Data.xlsx`.
## Tools

Python, pandas, NumPy, Matplotlib, Seaborn, Jupyter, Parquet (PyArrow)

## Limitations

- Reporting standards differ by country, so case counts are not perfectly comparable.
- Testing and hospital data are sparse in many countries.
- Results show association, not causation.
