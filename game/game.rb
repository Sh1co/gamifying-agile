module Game
  def self.media_path(file)
    File.join(File.dirname(File.dirname(
      __FILE__)), 'media', file)
  end

  def self.any_button_down?(*buttons, window)
    buttons.each do |b|
      return true if window.button_down?(b)
    end
    false
  end
end

