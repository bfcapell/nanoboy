module Nanoboy
  def self.version
    VERSION::STRING
  end
  module VERSION #:nodoc:
    file    = File.join(File.dirname(__FILE__), "..", "..", "VERSION")
    version = File.read(file).strip.split(".")

    MAJOR, MINOR, *TINY = version

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
