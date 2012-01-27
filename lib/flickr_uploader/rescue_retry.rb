module FlickrUploader
  module RescueRetry

    DEFAULTS = { times: 5, sleep: 0 }

    def rescue_retry(options = {})
      options = DEFAULTS.merge(options)
      tries = 0
      begin
        yield
      rescue
        if (tries += 1) < options[:times]
          sleep(options[:sleep]) if options[:sleep] > 0
          retry
        end
        raise
      end
    end

  end
end
