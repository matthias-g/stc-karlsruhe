module PhotoGallery extend ActiveSupport::Concern

  included do
    belongs_to :gallery, dependent: :destroy
    before_validation :create_gallery!, on: :create

    private

    def create_gallery!
      self.gallery = Gallery.create! if self.gallery == nil
    end

  end

end