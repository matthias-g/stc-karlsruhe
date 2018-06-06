class Project < Initiative

  mount_uploader :icon, ProjectIconUploader

  def finished?
    false
  end

end