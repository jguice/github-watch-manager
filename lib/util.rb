require 'logger'

# General utility functions
module Util
  LOG = Logger.new(STDOUT)

  # creates grammatical list from list-like object
  # see accompanying rspec tests for examples
  def listify(list)
    return nil if list.nil?

    begin
      list = list.to_a
    rescue NoMethodError
      LOG.warn("can't make an Array from a #{list.class}!")
      raise ArgumentError
    end

    return list.join(' and ') if list.size == 2

    list = list.join(', ') # add commas
    list.gsub!(/(.*)(, )(.*)/, '\1, and \3')

    list
  end
end
