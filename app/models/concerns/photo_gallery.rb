module PhotoGallery extend ActiveSupport::Concern

  included do
    belongs_to :gallery, dependent: :destroy, optional: true
    before_create :create_gallery!

    private

    def create_gallery!
      self.gallery = Gallery.create! if self.gallery == nil
    end

  end

end