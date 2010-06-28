# MongoID adapter for Pickle
require 'mongoid'

module Mongoid #:nodoc:
  module Document
    module PickleAdapter
      include Pickle::Adapter::Base

      # Do not consider these to be part of the class list
      def self.except_classes
        @@except_classes ||= []
      end

      # Gets a list of the available models for this adapter
      def self.model_classes
        @@model_classes ||=
        Dir[Rails.root.to_s + '/app/models/**/*.rb'].map do |model_path|
          model_name = File.basename(model_path).gsub(/\.rb$/, '')
          klass = model_name.classify.constantize
        end.reject { |klass| !klass.respond_to?('collection') }
      end

      # get a list of column names for a given class
      def self.column_names(klass)
        #klass.column_names
        klass.fields.keys
      end

      # Get an instance by id of the model
      def self.get_model(klass, id)
        klass.find(id)
      end

      # Find the first instance matching conditions
      def self.find_first_model(klass, conditions)
        klass.find(:first, :conditions => conditions)
      end

      # Find all models matching conditions
      def self.find_all_models(klass, conditions)
        klass.find(:all, :conditions => conditions)
      end
    end
  end
end
