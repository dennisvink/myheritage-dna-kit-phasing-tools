# Borland Genetics Phased Kit to MyHeritage Converter

This kit converter converts Borland Genetics phased kits to MyHeritage format for re-upload.
You will need:
- Your Phased kit from Borland Genetics
- Your MyHeritage kit (.csv)

Run the conversion as follows: ruby convert-kit.rb [paternal|maternal] borland-kit-file.txt myheritage-kit-file.csv > new-kit.csv
For example:

`./convert-kit.rb paternal borland-phased-paternal.txt MyHeritage_raw_dna_data.csv > paternal-mh.csv`

Now... MyHeritage doesn't allow uploading of MyHeritage kits. It does support FTDNA though. I've used https://dnagenics.com/RawConverter/RawConverter to convert from MyHeritage to FTDNA format. You can upload the FTDNA file to MyHeritage
