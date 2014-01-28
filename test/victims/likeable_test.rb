require File.expand_path(File.dirname(__FILE__))+'/../test_helper'

class LikeableTest < Test::Unit::TestCase
  context "Likeable" do
    setup do
      @liker = ImALiker.new
      @likeable = ImALikeable.create
    end

    context "#is_likeable?" do
      should "return true" do
        assert_true @likeable.is_likeable?
      end
    end

    context "#likeable?" do
      should "return true" do
        assert_true @likeable.likeable?
      end
    end

    context "#liked_by?" do
      should "not accept non-likers" do
        assert_raise(Socialization::ArgumentError) { @likeable.liked_by?(:foo, :like_type) }
      end

      should "call $Like.likes?" do
        $Like.expects(:likes?).with(@liker, @likeable, :like_type).once
        @likeable.liked_by?(@liker, :like_type)
      end
    end

    context "#likers" do
      should "call $Like.likers" do
        $Like.expects(:likers).with(@likeable, @liker.class, :like_type, { :foo => :bar })
        @likeable.likers(@liker.class, :like_type, { :foo => :bar })
      end
    end

    context "#likers_relation" do
      should "call $Like.likers_relation" do
        $Like.expects(:likers_relation).with(@likeable, @liker.class, :like_type, { :foo => :bar })
        @likeable.likers_relation(@liker.class, :like_type, { :foo => :bar })
      end
    end

    context "deleting a likeable" do
      setup do
        @liker = ImALiker.create
        @liker.like!(@likeable, :like_type)
      end

      should "remove like relationships" do
        Socialization.like_model.expects(:remove_likers).with(@likeable)
        @likeable.destroy
      end
    end

  end
end