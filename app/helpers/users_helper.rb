module UsersHelper
  # def gravatar_for(user, options: {size: 80})
  #   size = options[:size] // If typo a key, it silently defaults to nil. Hard to debug.
  # // while Ruby immediately throws an error when typo a key with Keyword Arguments.
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
