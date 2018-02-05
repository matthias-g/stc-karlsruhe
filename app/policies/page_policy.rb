class PagePolicy < Struct.new(:user, :page)

  def admindashboard
    user&.coordinator?
  end

end
