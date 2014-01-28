require File.expand_path(File.dirname(__FILE__))+'/../test_helper'

class LikerTest < Test::Unit::TestCase
  context "Liker" do
    setup do
      @liker = ImALiker.new
      @likeable = ImALikeable.create
    end

    context "#is_liker?" do
      should "return true" do
        assert_true @liker.is_liker?
      end
    end

    context "#liker?" do
      should "return true" do
        assert_true @liker.liker?
      end
    end

    context "#like!" do
      should "not accept non-likeables" do
        assert_raise(Socialization::ArgumentError) { @liker.like!(:foo, :like_type) }
      end

      should "call $Like.like!" do
        $Like.expects(:like!).with(@liker, @likeable, :like_type).once
        @liker.like!(@likeable, :like_type)
      end
    end

    context "#unlike!" do
      should "not accept non-likeables" do
        assert_raise(Socialization::ArgumentError) { @liker.unlike!(:foo, :like_type) }
      end

      should "call $Like.like!" do
        $Like.expects(:unlike!).with(@liker, @likeable, :like_type).once
        @liker.unlike!(@likeable, :like_type)
      end
    end

    context "#toggle_like!" do
      should "not accept non-likeables" do
        assert_raise(Socialization::ArgumentError) { @liker.unlike!(:foo, :like_type) }
      end

      should "unlike when likeing" do
        @liker.expects(:likes?).with(@likeable, :like_type).once.returns(true)
        @liker.expects(:unlike!).with(@likeable, :like_type).once
        @liker.toggle_like!(@likeable, :like_type)
      end

      should "like when not likeing" do
        @liker.expects(:likes?).with(@likeable, :like_type).once.returns(false)
        @liker.expects(:like!).with(@likeable, :like_type).once
        @liker.toggle_like!(@likeable, :like_type)
      end
    end

    context "#likes?" do
      should "not accept non-likeables" do
        assert_raise(Socialization::ArgumentError) { @liker.unlike!(:foo, :like_type) }
      end

      should "call $Like.likes?" do
        $Like.expects(:likes?).with(@liker, @likeable, :like_type).once
        @liker.likes?(@likeable, :like_type)
      end
    end

    context "#likeables" do
      should "call $Like.likeables" do
        $Like.expects(:likeables).with(@liker, @likeable.class, :like_type, { :foo => :bar })
        @liker.likeables(@likeable.class, :like_type, { :foo => :bar })
      end
    end

    context "#likees" do
      should "call $Like.likeables" do
        $Like.expects(:likeables).with(@liker, @likeable.class, :like_type, { :foo => :bar })
        @liker.likees(@likeable.class, :like_type, { :foo => :bar })
      end
    end

    context "#likeables_relation" do
      should "call $Follow.likeables_relation" do
        $Like.expects(:likeables_relation).with(@liker, @likeable.class, :like_type, { :foo => :bar })
        @liker.likeables_relation(@likeable.class, :like_type, { :foo => :bar })
      end
    end

    context "#likees_relation" do
      should "call $Follow.likeables_relation" do
        $Like.expects(:likeables_relation).with(@liker, @likeable.class, :like_type, { :foo => :bar })
        @liker.likees_relation(@likeable.class, :like_type, { :foo => :bar })
      end
    end

    should "remove like relationships" do
      Socialization.like_model.expects(:remove_likeables).with(@liker)
      @liker.destroy
    end
  end
end