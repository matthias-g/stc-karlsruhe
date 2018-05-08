class PagePolicy < Struct.new(:user, :page)

  def admindashboard
    user&.in_orga_team?
  end

end
