require 'rubygems'
require 'test/unit'
require 'nanoboy'
require 'mocha'

class NanoboyTest < Test::Unit::TestCase

  # Mock classes, with namespace to test the general case
  class Test::MyClass; end
  class Test::OtherClass; end
  module Test::MyModule
    def my_method; end
  end

  def test_load_methods_should_trigger_include_when_defined
    Nanoboy.methods.each do |method|
      Test::MyClass.expects(method).with(Test::MyModule)
      Nanoboy.send("#{method}!", 'Test::MyClass', Test::MyModule)
    end
  end

  def test_load_methods_should_trigger_include_with_sugared_syntax
    Nanoboy.methods.each do |method|
      Test::MyClass.expects(method).with(Test::MyModule)
      :'Test::MyClass'.send("#{method}!", Test::MyModule)
    end
  end

  def test_load_methods_should_schedule_automatic_inclusion_when_defined_after_with_const_set
    Test.send('remove_const', 'MyClass')
    Nanoboy.include!('Test::MyClass', Test::MyModule)
    Test.const_set('MyClass', Class.new)
    assert Test::MyClass.instance_methods.map(&:to_sym).include?(:my_method)
  end

  def test_load_methods_should_schedule_automatic_inclusion_when_defined_after_with_normal_def
    Test.send('remove_const', 'MyClass')
    Nanoboy.include!('Test::MyClass', Test::MyModule)
    Test.class_eval "class MyClass; end"
    assert Test::MyClass.instance_methods.map(&:to_sym).include?(:my_method)
  end

  def test_load_methods_should_allow_inclusion_in_other_classes
    Nanoboy.include!('Test::MyClass', Test::MyModule)
    Test::OtherClass.class_eval do
      Nanoboy.load_extensions_for Test::MyClass, self
    end
    assert Test::OtherClass.instance_methods.map(&:to_sym).include?(:my_method)
  end

end
