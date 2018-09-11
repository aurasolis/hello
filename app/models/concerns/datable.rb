module Datable
  extend ActiveSupport::Concern

  module ClassMethods
    def convert_date(params)
      d = Date.new params["birthday(1i)"].to_i, params["birthday(2i)"].to_i, params["birthday(3i)"].to_i
    end
  end
end
