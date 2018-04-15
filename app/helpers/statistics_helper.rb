module StatisticsHelper

  def sortable_column(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    css_class = (column == params[:sort]) ? "current #{params[:direction]}" : nil
    link_to sort: column, direction: direction do
      icon = "<i class='fas fa-sort' style='color: grey'></i>"
      if column == params[:sort]
        icon = "<i class='fas fa-sort-#{params[:direction]}'></i>"
      end
      (title + " #{icon}").html_safe
    end
  end

end
