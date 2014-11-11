module Codeclub
  module Server
    module Helpers
      def json_body
        request.body.rewind
        JSON.parse(request.body.read)
      rescue JSON::ParseError
        nil
      end
    end
  end
end

