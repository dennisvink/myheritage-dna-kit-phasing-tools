# MyHeritage DNA Kit Phasing Tools

Recently I came across the website "Borland Genetics". It has a set of tools, including a DNA Kit Phasing tool. When you have the raw DNA of both parents and child available, the website allows you to construct a new DNA kit with only the DNA of the respective parents.

What I wanted to achieve was being able to see which matches are my paternal matches and which matches are my maternal matches, on MyHeritage: the genealogy website I use the most.

Borland Genetics lets you download the generated kit, but its format is not supported by MyHeritage, alas. Thus I started to write some conversion scripts. You can't upload MyHeritage raw DNA files to MyHeritage (why not?), so initially I used a website that does the conversion for me (see the Borland Genetics instructions). Eventually I wrote my own little converter. That is the myheritage2ftdna.rb script (ftdna.rb also required).

- The first script converts the Borland Genetics Phased Kit to MyHeritage format.
- The second script is my shot at writing a kit phaser which you can use directly with MyHeritage raw DNA files.
- The third script converts MyHeritage raw DNA files to FTDNA format, which is supported by most genealogy websites.

For suggestions/comments/fanmail you can open an issue, or e-mail me at dennis < a t > drvink < d o t > com

## Borland Genetics Phased Kit to MyHeritage Converter

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
