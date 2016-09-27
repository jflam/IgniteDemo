
# This is a modified dependencies file for code that requires 
# a more recent version of R than is supplied by Microsoft R 
# Client. 

install_if_not_present <- function(name) {
    if (!(name %in% rownames(installed.packages()))) {
        install.packages(name)
    }
}

# These are the mandatory dependencies in this project

install_if_not_present("RODBC")
install_if_not_present("RUnit")
install_if_not_present("DT")
install_if_not_present("RODBCDBI")

# Assert that we are running R >= 3.3.1

if (!(version$major == 3 || version$minor == 3.1)) {
    print("You need to install Microsoft R Client from http://aka.ms/rclient/download")
}