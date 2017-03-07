class PagePolicy < Struct.new(:user, :page)

  def admindashboard
    user && user.coordinator?
  end

end
