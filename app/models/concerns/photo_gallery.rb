module PhotoGallery extend ActiveSupport::Concern

  included do

    has_one :gallery, as: :owner, dependent: :destroy


    before_validation :create_gallery!, on: :create
    validates_presence_of :gallery

    private

    def create_gallery!
      self.gallery = Gallery.create! if self.gallery == nil
    end

  end

end