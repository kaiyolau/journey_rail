# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    if user.is_admin?
      can :manage, :all # manage means they can do everything (not just CRUD)
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    alias_action :create, :read, :update, :delete, to: :crud

    can :crud, Journey do |journey|
      user == journey.user
    end
    # can :crud, Journey, user_id: user.id
    can :crud, Comment do |comment|
      user == comment.user
    end

    # can :crud, JobPost do |job_post|
    #   user == job_post.user
    # end

    can(:like, Journey) do |journey|
      user.persisted?
    end

    can(:destroy, Like) do |like|
      like.user == user
    end

    # IMPORTANT - defining a rule here does not enforce it yet
    # You will have to enforce the rules yourself in the views and controllers where applicable
  end
end
