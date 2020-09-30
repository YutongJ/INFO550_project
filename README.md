## This is a respository corresponding to HW4 of INFO 550

The sample project data and Rmarkdown code together with compiled version can be found here.

The original compiled version of homework file is "hw4.pdf". You can check your locally compiled pdf file with this version.


## My project

For my project, I will analyze the data from a collaboration work. The study recruited 82 veteran twin pairs (a total of 164 veterans).

To analyze the data you will need to install some `R` packages. The required packages can be installed using `R` commands.

``` r
installed_pkgs <- row.names(installed.packages())
pkgs <- c("table1", "arsenal", "survival", "survMisc", "KMsurv", "MASS")
for(p in pkgs){
	if(!(p %in% install_pkgs)){
		install.packages(p)
	}
}
```

## Execute the analysis

To execute the analysis, you should make sure you have successfully download the dataset `Dataset_PTSD.csv` and the Rmarkdown file `HW4_YJ.Rmd`. 

You should then make sure you have successfully set your current working directory using the folloing code:

``` bash
cd /Users/username/folder_name_where_you_save_data_and_Rmd
```


From the project folder you can run 

``` bash
Rscript -e "rmarkdown::render('HW4_YJ.Rmd')"
```

This will create a file called `HW4_YJ.pdf` output in your directory. The report build a table with descriptive statistics, make a Kaplan-Meier plot stratified by PTSD and obesity status, and fit a Cox-PH regression model to investigate the effect of PTSD on time to occurrence of REM sleep and how is it modified by obesity status. 

