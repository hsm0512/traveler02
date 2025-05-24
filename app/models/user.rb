class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # follower：自分がフォローしている関係の集まり
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # followed:自分がフォローされている関係の集まり
  has_many :following_user, through: :follower, source: :followed # following_user:実際に自分がフォローしているユーザー一覧
  has_many :follower_user, through: :followed, source: :follower # follower_user:実際に自分をフォローしているユーザー一覧

  attachment :profile_image

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

end
