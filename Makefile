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


.PHONY: help clean figures tables
## package install
install: 
	chmod +x R/pkg_install.R && R/pkg_install.R

report: Report/report_YJ.html

figures: Figures/figure1.png

tables: Tables/table1.csv Tables/table2.csv

dataclean: Dataset/clean_data.rda

help: Makefile
	@sed -n 's/^##//p' $<

clean:
	rm Figures/figure1.png Tables/table1.csv Tables/table2.csv Report/report_YJ.html

