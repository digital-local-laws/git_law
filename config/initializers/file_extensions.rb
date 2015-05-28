module FileExtensions
  # Returns true if file is binary (non-text data)
  # Otherwise false
  def binary?(filename)
    return false if File.zero? filename
    begin
      fm= FileMagic.new(FileMagic::MAGIC_MIME)
      !(fm.file(filename)=~ /^text\//)
    ensure
      fm.close
    end
  end
end

File.extend FileExtensions
