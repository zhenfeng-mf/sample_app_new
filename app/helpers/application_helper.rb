module ApplicationHelper
  # return full page title
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # 4.3.2演習
  def yeller(array)
    array.join.upcase
  end

  def string_shuffle(s)
    s.split('').shuffle.join
  end
end
