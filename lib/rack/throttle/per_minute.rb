module Rack; module Throttle
  ##
  # This rate limiter strategy throttles the application by defining a
  # maximum number of allowed HTTP requests per minute (by default, 60
  # requests per minute, which works out to an average of 1 request per
  # second).
  #
  # Note that this strategy doesn't use a sliding time window, but rather
  # tracks requests per distinct minute. This means that the throttling
  # counter is reset every minute on the minute (according to the server's local
  # timezone).
  #
  # @example Allowing up to 3,600 requests per minute
  #   use Rack::Throttle::PerMinute
  #
  # @example Allowing up to 100 requests per minute
  #   use Rack::Throttle::PerMinute, :max => 100
  #
  class PerMinute < TimeWindow
    ##
    # @param  [#call]                  app
    # @param  [Hash{Symbol => Object}] options
    # @option options [Integer] :max   (3600)
    def initialize(app, options = {})
      super
    end

    def max_per_minute
      @max_per_minute ||= options[:max_per_minute] || options[:max] || 60
    end

    alias_method :max_per_window, :max_per_minute

    protected

    ##
    # @param  [Rack::Request] request
    # @return [String]
    def cache_key(request)
      [super, Time.now.strftime('%Y-%m-%dT%H%M')].join(':')
    end
  end
end; end
