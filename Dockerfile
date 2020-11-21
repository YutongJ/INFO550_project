FROM rocker/rstudio

# install R packages like this
# put as close to top of script as possible to make best 
# use of caching and speed up builds
RUN Rscript -e "install.packages(c('table1', 'arsenal', 'survival', 'survMisc', 'KMsurv', 'MASS', 'rmarkdown'))"

# make a project directory in the container
# we will mount our local project directory to this directory
RUN mkdir /project

# copy contents of local folder to project folder in container
COPY ./ /project/

# make R scripts executable
RUN chmod +x /project/R/*.R

# # set an environment variable
# ENV which_fig="gears_vs_cylinders"

# make container entry point bash
CMD make -C project report