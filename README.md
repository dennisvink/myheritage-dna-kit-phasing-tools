# Borland Genetics Phased Kit to MyHeritage Converter

This kit converter converts Borland Genetics phased kits to MyHeritage format for re-upload.
You will need:
- Your Phased kit from Borland Genetics
- Your MyHeritage kit (.csv)

Run the conversion as follows: ruby convert-kit.rb borland-kit-file.txt myheritage-kit-file.csv > new-kit.csv
Now... MyHeritage doesn't allow uploading of MyHeritage kits. It does support 23andme though.
I've used https://dnagenics.com/RawConverter/RawConverter to convert from MyHeritage to 23andme format.
You can upload the 23andme file to MyHeritage
