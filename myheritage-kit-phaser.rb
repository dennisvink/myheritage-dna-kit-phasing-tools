#!/usr/bin/env ruby

require "csv"

# MyHeritage Kit Phaser
# ---------------------
# This script produces two phased kits: a paternal and maternal kit
# It requires the raw MyHeritage DNA files of two parents and one child.
#
# Submitted to the public domain
# Written by: Dennis Vink <dennis@drvink.com>

father_kit = ARGV[0]
mother_kit = ARGV[1]
child_kit = ARGV[2]

begin
  raise "Father, mother and child kit are required." unless (father_kit && mother_kit && child_kit)
  raise "File not found `#{father_kit}`" unless File.file?(father_kit)
  raise "File not found `#{mother_kit}`" unless File.file?(mother_kit)
  raise "File not found `#{child_kit}`" unless File.file?(child_kit)
rescue => error
  puts "Error: #{error}"
  puts "Usage: ./myheritage-kit-phaser.rb father_kit.csv mother_kit.csv child_kit.csv"
  exit(255)
end

# Generate kit header
gen_time = Time.now.getutc
kit_header = [
  "##fileformat=MyHeritage",
  "##format=MHv1.0",
  "##chip=GSA",
  "##timestamp=#{gen_time}",
  "##reference=build37",
  "#",
  "# MyHeritage DNA raw data.",
  "# For each SNP, we provide the identifier, chromosome number, base pair position and genotype.",
  "# The genotype is reported on the forward (+) strand with respect to the human reference build 37.",
  "# THIS INFORMATION IS FOR YOUR PERSONAL USE AND IS INTENDED FOR GENEALOGICAL RESEARCH",
  "# ONLY. IT IS NOT INTENDED FOR MEDICAL OR HEALTH PURPOSES. PLEASE BE AWARE THAT THE",
  "# DOWNLOADED DATA WILL NO LONGER BE PROTECTED BY OUR SECURITY MEASURES.",
  "RSID,CHROMOSOME,POSITION,RESULT"
]

# Initialize paternal and maternal kits
paternal_kit = [] + kit_header
maternal_kit = [] + kit_header 

def get_alleles(child, father, mother)
  return[father, mother] if(child == father && child == mother)
  return[father, father] if(child == father && mother == "--" && "#{child}#{father}".split("").uniq.length == 1)
  return[mother, mother] if(child == mother && father == "--" && "#{child}#{mother}".split("").uniq.length == 1)
  return[father, mother] if(child == "--" && father == mother)
  return["--", "--"] if(child == "--")

  child = child.split("")
  father = father.split("")
  mother = mother.split("")


  father_allele = ""
  mother_allele = ""

  unique_mother = mother - father
  unique_father = father - mother

  if(unique_mother)
    # Check if mother passed on her unique allele
    unique_mother.each do |allele|
      if(child.include? allele)
        mother_allele = allele
      end
    end
  end

  if(unique_father)
    # Check if father passed on his unique allele
    unique_father.each do |allele|
      if(child.include? allele)
        father_allele = allele
      end
    end
  end

  if mother_allele.empty?
    unique_child = mother - child
    unique_child.each do |allele|
      next if allele == "-"
      if(mother.include? allele)
        mother.delete(allele)
      end
    end
    unique_mother.each do |allele|
      if(!child.include? allele)
        mother.delete(allele)
      end
    end
    mother_allele = mother.uniq.join("")
  end

  if father_allele.empty?
    unique_child = father - child
    unique_child.each do |allele|
      next if allele == "-"
      if(father.include? allele)
        father.delete(allele)
      end
    end
    unique_father.each do |allele|
      if(!child.include? allele)
        father.delete(allele)
      end
    end
    father_allele = father.uniq.join("")
  end

  mother_allele = "-" if mother_allele.empty?
  father_allele = "-" if father_allele.empty?
  ["#{father_allele}#{father_allele}", "#{mother_allele}#{mother_allele}"]
end

puts "Reading father kit..."
father_dna = { father: CSV.parse(File.open(father_kit).read) }
puts "Reading mother kit..."
mother_dna = { mother: CSV.parse(File.open(mother_kit).read) }
puts "Reading child kit..."
child_dna =  { child:  CSV.parse(File.open(child_kit).read)  }

reference_map = {}
[father_dna, mother_dna, child_dna].each do |dna|
  subject = dna.keys[0]
  puts "Processing DNA of #{subject}..."
  dna[subject].each do |item|
    next if item[0] =~ /^#/
    next if item[0] =~ /^RSID/
    rsid, chromosome, position, result = item 
    if(!reference_map[subject])
      reference_map[subject] = {}
    end
    reference_map[subject][rsid] = {
      chromosome: chromosome,
      position: position,
      result: result
    }
  end
end

puts "Computing phased kits..."

reference_map[:child].each do |item|
  rsid = item[0]
  chromosome = item[1][:chromosome]
  position = item[1][:position]
  child_result = item[1][:result]

  father_result = reference_map[:father][rsid][:result]
  mother_result = reference_map[:mother][rsid][:result]
  phased_result = get_alleles(child_result, father_result, mother_result)
  #puts "#{rsid} #{phased_result.inspect}"
  raise "Impossibru!" if phased_result[1].length > 2
  paternal_kit.push("\"#{rsid}\",\"#{chromosome}\",\"#{position}\",\"#{phased_result[0]}\"")
  maternal_kit.push("\"#{rsid}\",\"#{chromosome}\",\"#{position}\",\"#{phased_result[1]}\"")
end

paternal_filename = "monokit-#{File.basename(father_kit)}"
maternal_filename = "monokit-#{File.basename(mother_kit)}"

puts "Saving paternal kit to #{paternal_filename}"
File.open(paternal_filename, 'w') { |file| file.write("#{paternal_kit.join("\n")}\n") }

puts "Saving maternal kit to #{maternal_filename}"
File.open(maternal_filename, 'w') { |file| file.write("#{maternal_kit.join("\n")}\n") }

puts "All done!"
