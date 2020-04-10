# frozen-string-literal: true

module Api
  class VersionValidator
    def initialize(version, default = false)
      @version = version
      @default = default
    end

    def matches?(request)
      @default ||
        request.headers[:Accept]&.include?(
          "application/vnd.railsactivejobs.v#{@version}"
        )
    end
  end
end
