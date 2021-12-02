# Borland Genetics Phased Kit to MyHeritage Converter

This kit converter converts Borland Genetics phased kits to MyHeritage format for re-upload.
You will need:
- Your Phased kit from Borland Genetics
- Your MyHeritage kit (.csv)

Run the conversion as follows: ruby convert-kit.rb borland-kit-file.txt myheritage-kit-file.csv > new-kit.csv

Now... MyHeritage doesn't allow uploading of MyHeritage kits. It does support other formats though. You may
be able to use https://dnagenics.com/RawConverter/RawConverter to convert from MyHeritage to another format.
I'll update the README.md once I've figured out which format MyHeritage will take.

Note: I am unsure whether the method I use to "fill in the blanks" (it's a mono kit after all" are appropiate. I might need to keep missing alleles blank.
