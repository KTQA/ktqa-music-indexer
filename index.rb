require 'rubygems'
require 'mp3info'
require 'csv'

# TODO: Test against a valid folder structure

artist = ''
title = ''
album = ''
length = ''
dir = ''
csv_string = ''

# This is the root folderPath we'll use to scan Album directories
# folderPath = "FOLDER_PATH_HERE"
folderPath = "F:/Temp"

# Generates a CSV file from a folder of music tracks
puts "\n\nGetting ID3 info..."

# Changes directory to the root folder path to run our iterations
Dir.chdir("#{folderPath}") do

  # Announces the folder we're in
  puts "\n\nThis folder: #{folderPath}\n\n"

  # This takes our CSV string and applies the headers for our CSV
  csv_string = CSV.generate do |csv|
    csv << ["Artist", "Title", "Album", "Length", "Folder"]
  end
  
  # Enumerates all the directories in our pwd and drops them in dirs
  dir_artists = Dir.glob("**/")

  # Iterate over each subdirectory
  dir_artists.each do |dir_artist|

    # Announces which album we're working on to console
    puts "* Starting artist #{dir_artist}..."

    # Gets a glob of our subdirectories under the artist - these are albums
    dir_albums = Dir.glob("./#{dir_artist}/*").select {|f| File.directory? f}

    dir_albums.each do |dir_album|

      dir = "#{dir_artist}/#{dir_album}"

      # Get each file within a subdirectory
      Dir.foreach("./#{dir}") do |filename|

        # Skip this iteration if it
        next if filename == '.' or filename == '..'

        # If it's a MP3 or a FLAC we pull the id3
        if File.extname(filename) == '.mp3' or File.extname(filename == '.flac') do

          # Use mp3info gem to pull out id3 info
          Mp3Info.open("./#{dir}/#{filename}") do |mp3|
            artist = mp3.tag.artist.to_s
            title = mp3.tag.title.to_s
            album = mp3.tag.album.to_s
            length = mp3.length.to_i
            seconds = length % 60
            minutes = (length / 60) % 60
            length = "#{minutes.to_s.rjust(2, "0")}:#{seconds.to_s.rjust(2, "0")}"
          end

          # add info to CSV string
          csv_string += CSV.generate do |csv|
            csv << [artist, title, album, length, dir]
          end
        end
      end
    end

    puts "... #{dir_artist} complete. *"
  end
  # Outputs our CSV to console
  # TODO: Save CSV file
  puts csv_string
end