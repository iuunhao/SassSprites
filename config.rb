#================================================================
#输出模式
#================================================================
output_style = :compact  
#output_style = :compressed
#================================================================

sass_dir = 'scss/'
css_dir = 'css/'
images_dir = 'images/'
#----------------------------------------------------------------

#================================================================
# 声明索引（建议开启）以下内容不做修改
http_path = '/'
enable_sourcemaps = true
#sass_options = {:sourcemap => true}
relative_assets = true
line_comments = false
##================================================================
# 防止sass sprit自动生成不同文件名字，造成SVN冲突.
# 这里做了一个 copy 而不是直接重命名；你可以用 FileUtils.mv 直接重命名
on_sprite_saved do |filename|
  if File.exists?(filename)
    FileUtils.cp filename, filename.gsub(%r{-s[a-z0-9]{10}\.png$}, '.png')
  end
end

# 除此之外，样式表里自动生成的声明也要修改一下
on_stylesheet_saved do |filename|
  if File.exists?(filename)
    css = File.read filename
    File.open(filename, 'w+') do |buffer|
      buffer << css.gsub(%r{-s[a-z0-9]{10}\.png}, '.png')
    end
  end
end
