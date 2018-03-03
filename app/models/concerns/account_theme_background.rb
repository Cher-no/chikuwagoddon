# frozen_string_literal: true

module AccountThemeBackground
  extend ActiveSupport::Concern

  IMAGE_MIME_TYPES = ['image/jpeg', 'image/png', 'image/gif'].freeze

  class_methods do
    def theme_background_styles(file)
      styles = { original: '3840x2160#' }
      styles[:static] = { format: 'png', convert_options: '-coalesce' } if file.content_type == 'image/gif'
      styles
    end

    private :theme_background_styles
  end

  included do
    # Theme background upload
    has_attached_file :theme_background, styles: ->(f) { theme_background_styles(f) }, convert_options: { all: '-quality 80 -strip' }
    validates_attachment_content_type :theme_background, content_type: IMAGE_MIME_TYPES
    validates_attachment_size :theme_background, less_than: 2.megabytes
  end

  def theme_background_original_url
    theme_background.url(:original)
  end

  def theme_background_static_url
    theme_background_content_type == 'image/gif' ? theme_background.url(:static) : theme_background_original_url
  end
end
