library("tidyverse")

# from Holford 1983, Table 2
deaths <- matrix(c(
    177, 271, 312, 382, 321, 305, 308,
    262, 350, 552, 620, 714, 649, 738,
    360, 479, 644, 949, 932, 1292, 1327,
    409, 544, 812, 1150, 1668, 1958, 2153,
    328, 509, 763, 1097, 1593, 2039, 2433,
    222, 359, 584, 845, 1192, 1638, 2068,
    108, 178, 285, 475, 742, 992, 1374), nrow = 7, byrow = TRUE)

population <- matrix(c(
    301, 317, 353, 395, 426, 473, 498,
    212, 248, 279, 301, 358, 411, 443,
    159, 194, 222, 222, 258, 304, 341,
    132, 144, 169, 210, 230, 264, 297,
    76, 94, 110, 125, 149, 180, 197,
    37, 47, 59, 71, 91, 108, 118,
    19, 22, 32, 39, 44, 56, 66), nrow = 7, byrow = TRUE)

colnames(deaths) <- colnames(population) <- c(1935, 1940, 1945, 1950, 1955, 1960, 1965)
rownames(deaths) <- rownames(population) <- c(50, 55, 60, 65, 70, 75, 80)

prostate <- inner_join(as_tibble(deaths, rownames = "age") %>%
    pivot_longer(-age, names_to = "period", values_to = "deaths"),
    as_tibble(population, rownames = "age") %>%
    pivot_longer(-age, names_to = "period", values_to = "population") %>%
    mutate(population = population * 1000)) %>%
    mutate(age = as.numeric(age), period = as.numeric(period),
        cohort = period - age) %>%
    select(age, period, cohort, deaths, population) %>%
    as.data.frame()

usethis::use_data(prostate, overwrite = TRUE)
