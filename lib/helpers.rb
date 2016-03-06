class FileHelper
  @hh = {
    :javascript => 'js',
    :bash => 'sh'
  }

  @cnt = 0

  def self.get_extension(language)
    return 'txt' if language.empty?

    if @hh.has_key?(language)
      return @hh[language]
    end

    language
  end

  def self.get_filename(language)
    @cnt = @cnt + 1 # violation of CQRS principle, but I don't care, cos it's draft
    "#{@cnt}.#{self.get_extension(language)}"
  end
end

class GistHelper

  def self.is_gist_configured?
    File.exists?(File.join(Dir.home, ".gist"))
  end

  def self.save_gist(filename, contents)
    t = Tempfile.new("temp_gist")
    t << contents
    t.flush
    output = `gist -f #{filename} < #{t.path}`
    t.close

    arr = output.split(/\//)
    arr[3].chomp
  end
end
