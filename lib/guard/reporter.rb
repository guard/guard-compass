module Guard
  # Send a report to the Guard UI
  # The Reporter is a wrapper arround guard UI because
  # it is currently subject to change.
  class Reporter
    def success(message)
      Guard::Compat::UI.info(message)
    end
    def failure(message)
      Guard::Compat::UI.error(message)
    end
    def unstable(message)
      Guard::Compat::UI.info(message)
    end
    def announce(message)
      Guard::Compat::UI.info(message)
    end
  end
end
