module Nanoboy
  # This module acts as a hook to enable Nanoboy in the class that includes it
  module Hook

    # This is the main Nanoboy hook, that is fired in the usual class creation
    # class MyClass (< MyParent); end
    module InheritedHook
      def inherited_with_nanoboy(subclass)
        inherited_without_nanoboy(subclass)
        Nanoboy.load_extensions_for subclass
      end

      def self.included klass
        Hook.nanoboy_alias klass, :inherited
      end
    end

    # This module allows to also fire Nanoboy when defining new classes using
    # the Module#const_set method
    module ConstSetHook
      def const_set_with_nanoboy(name, klass)
        set_object = const_set_without_nanoboy(name, klass)
        if set_object.is_a? Class
          Nanoboy.load_extensions_for set_object
        end
        set_object
      end

      def self.included klass
        Hook.nanoboy_alias klass, :const_set
      end
    end

    # This is the module that allows the sugared syntax: :ClassToExtend.include!
    module SymbolHook
      def self.included(klass)
        klass.class_eval do
          Nanoboy.methods.each do |method|
            define_method "#{method}!" do |extension|
              Nanoboy.send("#{method}!", self, extension)
            end
          end
        end
      end
    end

    # You can include Nanoboy::Hook manually in your classes.
    # Useful if it's activated too late for you
    def self.included(klass)
      klass.singleton_class.instance_eval { include InheritedHook, ConstSetHook }
    end

    # Similar to ActiveSupport alias_method_chain, but ensuring the alias
    # is created only once
    def self.nanoboy_alias klass, name
      klass.class_eval do
        unless (instance_methods + private_methods).include? :"#{name}_without_nanoboy"
          alias_method "#{name}_without_nanoboy", name
          alias_method name, "#{name}_with_nanoboy"
        end
      end
    end

    # Performs the hooking into the system that will make Nanoboy work
    def self.activate
      # Modules do not have Class#inherited since it is only defined for classes
      Class.instance_eval  { include InheritedHook }
      Module.instance_eval { include ConstSetHook  }
      Symbol.instance_eval { include SymbolHook    }
    end
  end
end