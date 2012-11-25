class Ability
  include CanCan::Ability

  def initialize(user)

       user ||= User.new

       cannot :read, UsersController

        if user.has_role? :admin
         can :manage, [Post,Topic,Forum]


       else
         can :read, :all

         if user.has_role? :user
           can :create, [Topic, Post]
           can [:update, :destroy], [Topic, Post] do |smth|
             smth.try(:user) == user
           end
         end

         if user.has_role? :moderator
           can :manage, [Post, Topic]
           cannot :destroy, Topic
         end
       end

  end
end
