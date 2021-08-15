class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Uploads are served from public/, on the app's own origin, so anything
  # that is not a plain raster image (HTML, SVG with script) would be
  # stored XSS. The content type is sniffed from the bytes, not the name.
  def extension_allowlist
    %w[jpg jpeg png]
  end

  def content_type_allowlist
    %r{\Aimage/(jpeg|png)\z}
  end

  def size_range
    1.byte..10.megabytes
  end
end
