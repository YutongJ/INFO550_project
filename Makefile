## rule for making report  
Report/report_YJ.html: Dataset/clean_data.rda R/report_YJ.Rmd figures tables
	cd R/ && Rscript -e "rmarkdown::render('report_YJ.Rmd', quiet = TRUE, output_file = '../Report/report_YJ.html')"

## rule for making figures
Figures/figure1.png: R/figure1.R Dataset/clean_data.rda
	chmod +x R/figure1.R && R/figure1.R

## rule for making tables
Tables/table1.csv: R/table1.R Dataset/clean_data.rda
	chmod +x R/table1.R && R/table1.R

Tables/table2.csv: R/table2.R Dataset/clean_data.rda
	chmod +x R/table2.R && R/table2.R

## rule for cleaning data (quality control)
Dataset/clean_data.rda: R/Data_clean.R Dataset/Dataset_PTSD.csv
	chmod +x R/Data_clean.R && R/Data_clean.R

## phony options:
.PHONY: help clean figures tables
## 	make install: install required packages
install: 
	chmod +x R/pkg_install.R && R/pkg_install.R

## 	make report: generate final html report
report: Report/report_YJ.html

## 	make figures: generate all figures in the report
figures: Figures/figure1.png

## 	make tables: generate all tables in the report
tables: Tables/table1.csv Tables/table2.csv

## 	make dataclean: create cleaned dataset
dataclean: Dataset/clean_data.rda

# 	make help: check help
help: Makefile
	@sed -n 's/^##//p' $<

## 	make cleanall: clean all output files
cleanall:
	rm Dataset/clean_data.rda Figures/figure1.png Tables/table1.csv Tables/table2.csv Report/report_YJ.html

