# Borland Genetics Phased Kit to MyHeritage Converter

This kit converter converts Borland Genetics phased kits to MyHeritage format for re-upload.
You will need:
- Your Phased kit from Borland Genetics
- Your MyHeritage kit (.csv)

Run the conversion as follows: ruby convert-kit.rb [paternal|maternal] borland-kit-file.txt myheritage-kit-file.csv > new-kit.csv
For example:

`./convert-kit.rb paternal borland-phased-paternal.txt MyHeritage_raw_dna_data.csv > paternal-mh.csv`

Now... MyHeritage doesn't allow uploading of MyHeritage kits. It does support FTDNA though. I've used https://dnagenics.com/RawConverter/RawConverter to convert from MyHeritage to FTDNA format. You can upload the FTDNA file to MyHeritage. UPDATE: I've included a MyHeritage to FTDNA conversion script. See below :)

## MyHeritage Kit Phaser

The second script in this repository, `myheritage-kit-phaser.rb`, aims to do what the Borland Genetics service does. It produces a paternal and maternal kit, using two parents and a child as input. You will still need to convert it to a format MyHeritage accepts if you want to separate your matches on MyHeritage.

## MyHeritage to FTDNA converter

The script `myheritage2ftdna.rb` converts a MyHeritage raw DNA file (csv) to FTDNA format. Simply specify the MyHeritage DNA kit as an argument and it will output a FTDNA file you can upload to other genealogy websites, including MyHeritage. 
