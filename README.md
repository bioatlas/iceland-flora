# iceland-flora
Student project to parse web site with Icelandic Flora into Darwin Core Archive format

In 'scrape_rvest' run the Init.R file to create the three data files inside of 'data-raw'. 
In DarwinCoreArchive there is a meta.xml file that contains the information of where the data is located.
Compress the three datafiles together with the meta.xml file to create the DwC-A.

TODO: Create an eml.xml file to compress into the DwC-A for a complete archive.
The eml.xml file is not required but helps with libraries that loads DwC-A:s and tries to load that file.
