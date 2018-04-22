# frozen_string_literal: true

require 'digest/md5'

module UsersHelper
  def user_image(user)
    if user.image.present?
      user.image
    else
      gravatar_url(user.email)
    end
  end

  private

  def gravatar_url(email)
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
