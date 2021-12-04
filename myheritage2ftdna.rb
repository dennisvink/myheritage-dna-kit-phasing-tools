#!/usr/bin/env ruby

require "csv"

kit_file = ARGV[0]
converted = []

begin
  raise "Kit filename to convert required" unless kit_file
  raise "File not found `#{father_kit}`" unless File.file?(kit_file)
rescue => error
  puts "Error: #{error}"
  puts "Usage: ./myheritage2ftdna.rb kit_file.csv"
  exit(255)
end

puts "Loading MyHeritage kit..."

reference_map = {}
dna =  CSV.parse(File.open(kit_file).read)
dna.each do |item|
  next if item[0] =~ /^#/
  next if item[0] =~ /^RSID/
  rsid, chromosome, position, result = item
  reference_map[rsid] = {
    chromosome: chromosome,
    position: position,
    result: result
  }
end

puts "Loading FTDNA template... (takes a bit)"
require "./ftdna.rb"

puts "Converting to FTDNA format..."
@ftdna_map.each do |item|
  rsid = item[0].to_s
  chromosome = item[1][:chromosome]
  position = item[1][:position]
  result = item[1][:result]
  if(reference_map[rsid])
    result = reference_map[rsid][:result]
  end
  converted.push("#{rsid},#{chromosome},#{position},#{result}")
end

filename = "ftdna-#{File.basename(kit_file)}.txt"

puts "Saving converted kit to #{filename}"
File.open(filename, 'w') { |file| file.write("#{converted.join("\r\n")}\r\n") }
