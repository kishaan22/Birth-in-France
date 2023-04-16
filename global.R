
#  ------------------------------------------------------------------------
#
# Title : Tableau de bord naissances - GLOBAL
#    By : dreamRs
#  Date : 2022-01-26
#
#  ------------------------------------------------------------------------


# Packages -----------------------------------

library(shiny)
library(shinyWidgets)
library(dplyr)
library(apexcharter)
library(leaflet)
library(reactable)
library(bslib)
library(sf)


# Datas --------------------------------------------------------------------

# naissances_france <- readRDS(file = "datas/naissances_france.rds")

# Read in the RDS
births_france <- readRDS(file = "datas/births_france.rds")

write.csv(births_france, "first.csv", row.names=FALSE)
births_france <- read.csv("first.csv")
colnames(births_france)[2] <- "YEAR"
colnames(births_france)[3] <- "BIRTH_RATE"
colnames(births_france)[4] <- "AVERAGE_AGE_MOTHER"
colnames(births_france)[5] <- "NUMBER_BIRTH"
births_france

births_region <- readRDS(file = "datas/births_region.rds")
write.csv(births_region, "second.csv", row.names=FALSE)
births_region <- read.csv("second.csv")
colnames(births_region)[2] <- "YEAR"
colnames(births_region)[3] <- "BIRTH_RATE"
colnames(births_region)[4] <- "AVERAGE_AGE_MOTHER"
colnames(births_region)[5] <- "NUMBER_BIRTH"
births_region

births_department <- readRDS(file = "datas/births_department.rds")
write.csv(births_department, "Third.csv", row.names=FALSE)
births_department <- read.csv("Third.csv")
colnames(births_department)[2] <- "YEAR"
colnames(births_department)[3] <- "BIRTH_RATE"
colnames(births_department)[4] <- "AVERAGE_AGE_MOTHER"
colnames(births_department)[5] <- "NUMBER_BIRTH"
births_department

contour_regions <- readRDS(file = "datas/contour_regions.rds")
contour_departements <- readRDS(file = "datas/contour_departements.rds")
