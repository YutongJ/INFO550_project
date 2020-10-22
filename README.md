## This is a respository corresponding to HW5 of INFO 550

The sample project data and Rmarkdown code together with compiled version can be found here.

The compiled version of this report is "report_YJ.html" in folder `Report/`. You can check your locally compiled .html file with this version.


## My project

For my project, I will analyze the data from a collaboration work. The study recruited 82 veteran twin pairs (a total of 164 veterans).

To analyze the data you will need to install some `R` packages. The required packages can be installed using `R` commands as below:

``` r
installed_pkgs <- row.names(installed.packages())
pkgs <- c("table1", "arsenal", "survival", "survMisc", "KMsurv", "MASS", "bookdown")
for(p in pkgs){
	if(!(p %in% installed_pkgs)){
		install.packages(p)
	}
}
```

Or you can install all `R` packages using the following code:

``` bash
make install
```

## Execute the analysis

To execute the analysis, please make sure you have successfully download all files in `INFO550_project`. 

Then please make sure you have successfully set your current working directory using the following code:

``` bash
cd folder_name_where_you_save_all_files
```


Now you can run the following code to generate the report.

``` bash
make report
```

You can also check for other useful options with:

``` bash
make help
```


This will create a file called `report_YJ.pdf` in your `Report/` directory. The report builds a table with descriptive statistics, makes a Kaplan-Meier plot stratified by PTSD and obesity status, and fits a Cox-PH regression model to investigate the effect of PTSD on time to occurrence of REM sleep and how is it modified by obesity status. 

