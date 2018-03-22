# iceland-flora
Student project to parse web site with Icelandic Flora into Darwin Core Archive format

In 'scrape_rvest' run the Init.R file to create the three data files inside of 'data-raw'. 
In Init.R there are a few options:
  use_actual_website (if the program should download the data from the web or if the program should search for a localy downloaded
  version of the website in the same folder caled "floraisland.is"
 
  only_load_the_first_N_species (if you only want to load 10 species from every category so that the program can complete and    
  create the data files much faster than normal, used for testing)
  -1 tells the program to load all species
  
  all of the links to the 'sub'-pages on the website, should work if the website doesn't get an update.
  
  print_exceptions (if the program should print all the exceptions or non normalties with the website) (require some bug-fixing and 
  printing fixing)
  
  To test and debug the code run all of the code in Init.R except for the last line, then go to scrape.R and run the lines one by 
  one.
  
In main_function.R all of the code to download and save all of the data from a specific subsite.
In functions.R all of the functions to extract all images or the title in icelandic or latin and to extract the main text.
In cleanup_function.R all of the functions to cleanup a vector for example:
In scrape.R it uses main_function.R to extract all of the information and add it together, then it saved the files.
  
In DarwinCoreArchive there is a meta.xml file that contains the information of where the data is located.
Compress the three datafiles together with the meta.xml file to create the DwC-A.

TODO: Create an eml.xml file to compress into the DwC-A for a complete archive.
The eml.xml file is not required but helps with libraries that loads DwC-A:s and tries to load that file.
