class Order < ApplicationRecord
  belongs_to :product

  has_many_attached :assets
  has_many_attached :photos
  has_many_attached :fonts

  alias_attribute :CUSTOMEREMAIL, :customer_email

  validate :videos_mime_types
  validate :videos_dimensions
  validate :videos_file_sizes
  validate :videos_durations
  validate :photos_mime_types
  validate :photos_dimensions
  validate :photos_file_sizes
  validate :fonts_mime_types
  validate :fonts_file_sizes

  private

  def videos_mime_types
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| ['video/mp4'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe estar en formato mp4")
    end
  end

  def videos_dimensions
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.metadata.values_at(:width, :height) == [1920, 1080] }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe tener dimensiones de 1920x1080")
    end
  end

  def videos_file_sizes
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.blob.byte_size <= 50.megabytes }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe pesar como máximo 50 MB")
    end
  end

  def videos_durations
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.metadata["duration"] <= 10.seconds }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe durar 10 segundos como máximo")
    end
  end

  def photos_mime_types
    return unless photos.attached?

    valid, invalid = photos.partition { |asset| ['image/jpeg', 'image/png'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:photos, "#{asset.filename} debe estar en formato JPEG o PNG")
    end
  end

  def photos_dimensions
    return unless photos.attached?

    valid, invalid = photos.partition { |asset| asset.metadata[:width] >= 1920 && asset.metadata[:height] >= 1080 }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:photos, "#{asset.filename} debe tener dimensiones de 1920x1080 como mínimo")
    end
  end

  def photos_file_sizes
    return unless photos.attached?

    valid, invalid = photos.partition { |asset| asset.blob.byte_size <= 10.megabytes }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:photos, "#{asset.filename} debe pesar como máximo 10 MB")
    end
  end

  def fonts_mime_types
    return unless fonts.attached?

    valid, invalid = fonts.partition { |asset| ['application/zip'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:fonts, "#{asset.filename} debe estar en formato ZIP.")
    end
  end

  def fonts_file_sizes
    return unless fonts.attached?

    valid, invalid = fonts.partition { |asset| asset.blob.byte_size <= 10.megabytes }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:fonts, "#{asset.filename} debe pesar como máximo 10 MB")
    end
  end
end
