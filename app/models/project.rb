class Project < Initiative

  mount_uploader :icon, ProjectIconUploader

  def finished?
    false
  end

  def status
    :empty
  end

end