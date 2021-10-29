class Order < ApplicationRecord
  belongs_to :product

  has_many_attached :videos
  has_many_attached :photos
  has_many_attached :fonts
  has_many_attached :locutions
  has_many :ideas
  has_many :phrases

  alias_attribute :CUSTOMEREMAIL, :customer_email # TODO: Remove this

  validate :videos_mime_types
  validate :videos_dimensions, if: -> { errors.where(:videos, :invalid_format).empty? }
  validate :videos_file_sizes, if: -> { errors.where(:videos, :invalid_format).empty? }
  validate :videos_durations, if: -> { errors.where(:videos, :invalid_format).empty? }

  validate :photos_mime_types
  validate :photos_dimensions, if: -> { errors.where(:photos, :invalid_format).empty? }
  validate :photos_file_sizes, if: -> { errors.where(:photos, :invalid_format).empty? }

  validate :fonts_mime_types
  validate :fonts_file_sizes, if: -> { errors.where(:fonts, :invalid_format).empty? }

  validate :locutions_mime_types

  private

  def videos_mime_types
    return unless videos.attached?

    valid, invalid = videos.partition { |asset| ['video/mp4'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:videos, :invalid_format, message: "#{asset.filename} debe estar en formato MP4")
    end
  end

  def videos_dimensions
    return unless videos.attached?

    valid, invalid = videos.partition { |asset| asset.metadata.values_at(:width, :height) == [1920, 1080] }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:videos, "#{asset.filename} debe tener dimensiones de 1920x1080")
    end
  end

  def videos_file_sizes
    return unless videos.attached?

    valid, invalid = videos.partition { |asset| asset.blob.byte_size <= 50.megabytes }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:videos, "#{asset.filename} debe pesar como máximo 50 MB")
    end
  end

  def videos_durations
    return unless videos.attached?

    valid, invalid = videos.partition { |asset| asset.metadata["duration"] <= 11.seconds }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:videos, "#{asset.filename} debe durar 10 segundos como máximo")
    end
  end

  def photos_mime_types
    return unless photos.attached?

    valid, invalid = photos.partition { |asset| ['image/jpeg', 'image/png'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:photos, :invalid_format, message: "#{asset.filename} debe estar en formato JPEG o PNG")
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
      errors.add(:fonts, :invalid_format, message: "#{asset.filename} debe estar en formato ZIP")
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

  def locutions_mime_types
    return unless locutions.attached?

    valid, invalid = locutions.partition { |asset| ['audio/mpeg'].include?(asset.blob.content_type) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:locutions, "#{asset.filename} debe estar en formato MP3")
    end
  end
end
