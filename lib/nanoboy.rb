require 'nanoboy/hook'

module Nanoboy
  class << self
    attr_accessor :extensions, :methods
  end

  self.extensions ||= {}
  self.methods = %w{include extend helper}

  # Returns true if the +sym+ class has scheduled extensions to be included
  def self.has_extensions?(sym)
    extensions[sym.to_s]
  end

  # Returns a Module that, when included, will provide all the scheduled funcionality for +sym+
  def self.extensions_for(sym)
    Module.new{
      block = ::Proc.new{|recipient|
        Nanoboy.methods.each do |method|
          Array(Nanoboy.extensions[sym.to_s][method]).each do |k|
            recipient.send(method, k)
          end
        end
      }
      define_method :included, block
      module_function :included
    }
  end

  def self.load_extensions_for klass, recipient = klass
    if has_extensions?(klass.name)
      recipient.send :include, extensions_for(klass.name)
    end
  end

  methods.each do |method|

    self.class_eval <<-EOS
      # Schedules the inclusion of +klass+ inside +recipient+
      # Use this instead of sending direct includes, extends or helpers
      def self.#{method}!(recipient, klass)                  # def self.append_include('ClassToExtend', MyModule)
        extensions[recipient.to_s] ||= {}                    #   extensions['ClassToExtend'.to_s] ||= {}
        extensions[recipient.to_s]["#{method}"] ||= []       #   extensions['ClassToExtend'.to_s]["include"] ||= []
        extensions[recipient.to_s]["#{method}"] << klass     #   extensions['ClassToExtend'.to_s]["include"] << klass
        # use class_eval to avoid evaluation of recipient    #   # use class_eval to avoid evaluation of ClassToExtend
        class_eval <<-EOCONSTANTIZE                          #   class_eval <<-EOCONSTANTIZE
          if defined?(\#{recipient})                         #     if defined?(ClassToExtend)
            \#{recipient}.send("#{method}", klass)           #       ClassToExtend.send("include", MyModule)
          end                                                #     end
        EOCONSTANTIZE
      end                                                    # end
    EOS
  end

  def self.enable
    Nanoboy::Hook.activate
  end

end

# Go!
Nanoboy.enable