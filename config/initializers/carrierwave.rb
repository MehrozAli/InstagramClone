# Keep files uploaded by the test suite out of public/uploads.
if Rails.env.test?
  CarrierWave.configure do |config|
    config.root = Rails.root.join('tmp/carrierwave')
  end
end
