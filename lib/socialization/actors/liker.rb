module ActiveRecord
  class Base
    def is_liker?
      false
    end
    alias liker? is_liker?
  end
end

module Socialization
  module Liker
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.like_model.remove_likeables(self) }

      # Specifies if self can like {Likeable} objects.
      #
      # @return [Boolean]
      def is_liker?
        true
      end
      alias liker? is_liker?

      # Create a new {Like like} relationship.
      #
      # @param [Likeable] likeable the object to be liked.
      # @return [Boolean]
      def like!(likeable, like_type)
        raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Socialization.like_model.like!(self, likeable, like_type)
      end

      # Delete a {Like like} relationship.
      #
      # @param [Likeable] likeable the object to unlike.
      # @return [Boolean]
      def unlike!(likeable, like_type)
        raise Socialization::ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Socialization.like_model.unlike!(self, likeable, like_type)
      end

      # Toggles a {Like like} relationship.
      #
      # @param [Likeable] likeable the object to like/unlike.
      # @return [Boolean]
      def toggle_like!(likeable, like_type)
        raise Socialization::ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        if likes?(likeable, like_type)
          unlike!(likeable, like_type)
          false
        else
          like!(likeable, like_type)
          true
        end
      end

      # Specifies if self likes a {Likeable} object.
      #
      # @param [Likeable] likeable the {Likeable} object to test against.
      # @return [Boolean]
      def likes?(likeable, like_type)
        raise Socialization::ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Socialization.like_model.likes?(self, likeable, like_type)
      end

      # Returns all the likeables of a certain type that are liked by self
      #
      # @params [Likeable] klass the type of {Likeable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<Likeable, Numeric>] An array of Likeable objects or IDs
      def likeables(klass, like_type, opts = {})
        Socialization.like_model.likeables(self, klass, like_type, opts)
      end
      alias :likees :likeables

      # Returns a relation for all the likeables of a certain type that are liked by self
      #
      # @params [Likeable] klass the type of {Likeable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def likeables_relation(klass, like_type, opts = {})
        Socialization.like_model.likeables_relation(self, klass, like_type, opts)
      end
      alias :likees_relation :likeables_relation
    end
  end
end