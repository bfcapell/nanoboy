# Nanoboy

nanoboy is a little ruby gem that allows you to extend classes and/or modules with your own modules with several advantages:

 * lazy extension  -- the extended class is not loaded if it's not already loaded. The extension will be applied once the class is loaded. 
 * persistent on class reloading -- if you are developing in Rails, where classes are reloaded on each request, use this and forget of callbacks and hacks

Due to the lazy extension feature, this gem is specially useful when you have loading order problems. For example, if you are extending a lib that is extending another lib. Yes, these things happen.


Syntax
------

There are two possible syntaxes:

* Explicit

```ruby
Nanoboy.include! :ClassToExtend, MyAwesomeModule


* Sugared

```ruby
:ClassToExtend.include! MyAwesomeModule

About the name
--------------

As @jondeandres said, if there is a well-known gem called FactoryGirl, what's the problem with Nanoboy?
