# https://github.com/rails/sass-rails/issues/119
class Sass::Rails::Importer
  def sass_file?(filename)
    SASS_EXTENSIONS.keys.any? { |ext| filename.to_s.match(/#{ext}$/) }
  end
end
