  require File.expand_path('../config/application', __FILE__)
  require 'rake'

 # temp fix for NoMethodError: undefined method `last_comment'
 # remove when fixed in Rake 11.x
 module TempFixForRakeLastComment
   def last_comment
     last_description
   end 
 end
 Rake::Application.send :include, TempFixForRakeLastComment

Rails.application.load_tasks
