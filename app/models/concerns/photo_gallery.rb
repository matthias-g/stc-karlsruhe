module PhotoGallery extend ActiveSupport::Concern

  included do
    belongs_to :gallery, dependent: :destroy
    before_create :create_gallery!

    private

    def create_gallery!
      self.gallery = Gallery.create!
    end

  end

end