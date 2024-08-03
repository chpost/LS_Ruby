module TwentyOneDisplay
  def display_message(key, *data)
    message = self.class::MESSAGES[key.to_s]
    message = format(message, *data) unless data.empty?
    puts message
  end

  def clear_and_display_message(key, *data)
    clear_screen
    display_message key, *data
  end

  def clear_screen
    system 'clear'
    display_message :banner
  end

  def delay
    sleep 2
  end

  def pause
    display_message :continue
    $stdin.raw { |io| io.readpartial(5) }
  end
end
