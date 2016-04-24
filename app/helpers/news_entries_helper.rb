module NewsEntriesHelper

  def list_news(categories, limit = 0)
    news = if categories.nil?
      NewsEntry.all
    else
      NewsEntry.where(category: categories.map{|c| NewsEntry.categories[c]})
    end
    news = news.order(:created_at)
    news = news.limit(limit) if limit > 0
    news
  end

end
