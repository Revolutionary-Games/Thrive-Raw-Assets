#!/usr/bin/env ruby
# This script uses ImageMagick (only Linux version for now) to make scaled images of the
# backgrounds for use as skyboxes. This is done because compression doesn't work on the
# skyboxes, and they are not visible and only contribute indirect light
require 'json'

targetSize=256

backgrounds = [
  "Thrive_abyss0.png",
  "Thrive_bathy0.png",
  "Thrive_cave0.png",
  "Thrive_estuary0.png",
  "Thrive_iceshelf0.png",
  "Thrive_meso0.png",
  "Thrive_ocean0.png",
  "Thrive_seafloor0.png",
  "Thrive_shallow0.png",
  "Thrive_tidepool0.png",
  "Thrive_vent0.png",
]

def import(bg, target)
  {
    # This is the same name as the image so unneeded currently
    # baseFile: bg,
    target: "textures/background/" + target,
    pixelFormat: "RG11B10F",
    cubemap:
      {
        type: "single"
      }
  }
end

backgrounds.each{|bg|
  ext = File.extname(bg)
  target = File.basename(bg, ext) + "_skybox" + ext
  
  puts "Resizing #{bg} -> #{target}"
  
  system "convert", bg, "-resize", "#{targetSize}x#{targetSize}", target
  if $?.exitstatus != 0
    puts "conversion failed"
    exit 1
  end

  importTarget = File.basename(File.basename(bg, ext), "0") + "_skybox"

  importerFile = target + ".options.json"
  
  puts "Writing importer file: #{importerFile}"
  # Importer file
  File.open(importerFile, 'w') { |file|
    file.write(JSON.pretty_generate(import target, importTarget))
  }
}
