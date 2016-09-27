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

# Assert that we are running Microsoft R Client 3.2.5

if (!"RevoScaleR" %in% rownames(installed.packages())) {
    print("You need to install Microsoft R Client from http://aka.ms/rclient/download")
}