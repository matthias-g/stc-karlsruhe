module NewsEntriesHelper

  # Returns a list of latest news entries of the given categories
  def list_news(categories, limit = 0)
    news = @news_entries if @news_entries
    unless news
      if categories.nil?
        news = policy_scope(NewsEntry)
      else
        news = policy_scope(NewsEntry).where(category: categories.map{|c| NewsEntry.categories[c]})
      end
    end
    news = news.order(created_at: :desc)
    news = news.limit(limit) if limit > 0
    news
  end

end
