module StatisticsHelper

  def sortable_column(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    link_to sort: column, direction: direction do
      (title + " <i class='fa fa-sort'></i>").html_safe
    end
  end

end
