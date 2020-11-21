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


## How to build a local docker
 
To execute the analysis in a docker container, you should also first make sure you have successfully download all files in `INFO550_project`. 

Then please make sure you have successfully set your current working directory using the following code:

``` bash
cd folder_name_where_you_save_all_files
```

Run the docker on your local computer first, and then you can run the following code to build the container.

``` bash
docker build -t info550_prj .
```

After building it, you can run the following code to run the container and mount the `Report/` directory to your local computer which contains the report generated in your Docker coontainer. 

``` bash
docker run -v /Your/local/path/to/Report:/project/Report -it info550_prj
```

If you want to mount the whole project folders to your local computer you can change the path correspondingly as below:

``` bash
docker run -v /Your/local/path/to/folder:/project -it info550_prj
```

You can also build a local docker by yourself using the following code:

``` bash
make build
```

## How to retrieve a built Docker image from DockerHub

You can also find one built Docker as the same as above on DockerHub. You can pull my built Docker image using the following code:

``` bash
docker pull yutongjin/info550_prj:1.0
```

Then you should create a `Report/` folder on your local computer to save the report, and then use the following code to run the container and mount the `Report/` directory to your local computer.

``` bash
docker run -v /Your/local/path/to/the/new/created/Report:/project/Report -it yutongjin/info550_prj:1.0
```


## Summary

This will create a file called `report_YJ.html` in your `Report/` directory. The report builds a table with descriptive statistics, makes a Kaplan-Meier plot stratified by PTSD and obesity status, and fits a Cox-PH regression model to investigate the effect of PTSD on time to occurrence of REM sleep and how is it modified by obesity status. 

