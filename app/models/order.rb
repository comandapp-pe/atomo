class Order < ApplicationRecord
  belongs_to :product

  has_many_attached :assets

  alias_attribute :CUSTOMEREMAIL, :customer_email

  validate :assets_mime_types
  validate :assets_file_sizes
  validate :assets_dimensions
  validate :assets_lengths

  private

  def assets_mime_types
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.blob.content_type == 'video/mp4' }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe estar en formato mp4")
    end
  end

  def assets_file_sizes
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.blob.byte_size.between?(10.megabytes, 50.megabytes) }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe pesar entre 10 MB a 50 MB")
    end
  end

  def assets_dimensions
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.metadata.values_at(:width, :height) == [1920, 1080] }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe tener dimensiones de 1920x1080")
    end
  end

  def assets_lengths
    return unless assets.attached?

    valid, invalid = assets.partition { |asset| asset.metadata["duration"] <= 10.seconds }

    return if invalid.empty?

    invalid.each do |asset|
      errors.add(:assets, "#{asset.filename} debe durar 10 segundos como máximo")
    end
  end
end
