#!/usr/bin/env ruby

# This kit converter converts Borland Genetics phased kits to MyHeritage format for re-upload.
# You will need:
# - Your Phased kit from Borland Genetics (standard download)
# - Your MyHeritage kit (.csv)
# Run the conversion as follows: ruby convert_kit.rb <maternal|paternal> <borland_kit_file> <myheritage_kit_file> > new_kit.csv
# I've used https://dnagenics.com/RawConverter/RawConverter to convert from MyHeritage to FTDNA format.
# You can upload the FTDNA file to MyHeritage

require "csv"

kit_gender = ARGV[0]
borland_kit = ARGV[1]
myheritage_kit = ARGV[2]

begin
  raise "Either `paternal` or `maternal` is required for Borland kit" unless %w(paternal maternal).include?(kit_gender)
  raise "Borland kit filename required" unless borland_kit
  raise "MyHeritage kit filename required" unless myheritage_kit
  raise "File not found `#{borland_kit}`" unless File.file?(borland_kit)
  raise "File not found `#{myheritage_kit}`" unless File.file?(myheritage_kit)
rescue => error
  puts "Error: #{error}"
  puts "Usage: ./convert_kit.rb <paternal|maternal> <borland_kit.txt> <myheritage_kit.csv>"
  exit(255)
end

reference_map = {}

myheritage = CSV.parse(File.open(myheritage_kit).read)
myheritage.each do |item|
  next if item[0] =~ /^#/
  next if item[0] =~ /^RSID/
  rsid, chromosome, position, result = item 
  reference_map[rsid] = {
    chromosome: chromosome,
    position: position,
    result: result
  }
end

gen_time = Time.now.getutc
print <<-EOB
##fileformat=MyHeritage
##format=MHv1.0
##chip=GSA
##timestamp=#{gen_time}
##reference=build37
#
# MyHeritage DNA raw data.
# For each SNP, we provide the identifier, chromosome number, base pair position and genotype.
# The genotype is reported on the forward (+) strand with respect to the human reference build 37.
# THIS INFORMATION IS FOR YOUR PERSONAL USE AND IS INTENDED FOR GENEALOGICAL RESEARCH
# ONLY. IT IS NOT INTENDED FOR MEDICAL OR HEALTH PURPOSES. PLEASE BE AWARE THAT THE
# DOWNLOADED DATA WILL NO LONGER BE PROTECTED BY OUR SECURITY MEASURES.
RSID,CHROMOSOME,POSITION,RESULT
EOB

borland_reference_map = {}

File.open(borland_kit).read.each_line do |line|
  next if line =~ /^\#/
  next if line =~ /allele/
  line.strip!
  rsid, chromosome, position, a1, a2 = line.split("\t")
  borland_reference_map[rsid] = {
    chromosome: chromosome,
    position: position,
    result: "#{a1}#{a2}"
  }
end

myheritage.each do |item|
  next if item[0] =~ /^#/
  next if item[0] =~ /^RSID/
  rsid, chromosome, position, result = item
  if(!borland_reference_map[rsid])
    kit_chromo = kit_gender == "maternal" ? "X" : "Y" 
    if(reference_map[rsid][:chromosome] == kit_chromo)
      puts "\"#{rsid}\",\"#{chromosome}\",\"#{position}\",\"#{reference_map[rsid][:result]}\""
    else
      puts "\"#{rsid}\",\"#{chromosome}\",\"#{position}\",\"--\""
    end
  else
    borland_rsid = borland_reference_map[rsid]
    chromosome = borland_rsid[:chromosome]
    position = borland_rsid[:position]
    result = borland_rsid[:result]
    if(reference_map[rsid][:chromosome] == "X" || reference_map[rsid][:chromosome] == "Y")
      chromosome = reference_map[rsid][:chromosome]
    end
    puts "\"#{rsid}\",\"#{chromosome}\",\"#{position}\",\"#{result}\""
  end
end

