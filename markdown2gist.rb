require 'tempfile'
require './lib/helpers.rb'

if !GistHelper.is_gist_configured?
  puts "Please init your gist with 'gist --login' command first."
  exit(1)
end

if ARGV.size != 1
  puts "Usage: ruby markdown2gist.rb markdown_file.txt"
  exit(2)
end

infile = ARGV[0]

#puts "OK, processing from '#{infile}' to #{outfile}...'"

code_mode = false
code = []
language = ''

File.readlines(infile).each do |line|
  # markdown block marker found?
  if line =~ /^\`\`\`(.*)$/
    language = $1.to_sym if !code_mode
    code_mode = !code_mode and next
  end

  # add line
  code << line if code_mode

  # flush code ?
  if !code_mode && code.size > 0
    filename = FileHelper.get_filename(language)
    #puts "flush code of #{code.size} lines, language: #{language}, filename: #{filename}"
    gist_id = GistHelper.save_gist(filename, code.join)
    puts "{% gist #{gist_id} %}"
    code = []
    next
  end

  # output all non-code lines
  if !code_mode && code.size == 0
    puts line
  end
end
