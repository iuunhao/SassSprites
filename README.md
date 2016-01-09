#[sass-sprite](https://github.com/iuunhao/sass-sprite.git)

本项目是一个简单的`sass-mixin`，我在日常的工作开发中，一直使用sass来编写css，因为这样可以提高我的效率。但让人为之头疼就是`css-sprite`，现在的web项目或多或少都会使用，当然如果你用的是 `iconfont`，那就另当别论了。

我自己使用的是sass和compassa，实际上`compass`的作用也就是一个输出路径与sprite重命名的作用，我们都知道sass合成的图片文件名字是`md5`的文件名，可以根据个人需求来确定到底使用什么样的文件名。

首先你需要一个compass的配置文件`config.rb`:

```
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
```

如果你需要`md5`的文件名，你只需要将`on_sprite_saved`与`on_stylesheet_saved`两个方法注释掉即可。

你也许知道`compass`里面也提供了`sprite`的方法，但在我开来，它并不好用，所以考虑用原生sass的API去重写它。当然，我的想法不一定符合你的想法。以下是实际的应用场景：

## DEMO
```
//如果ispc为true,那么图片合成不会缩2倍
$ispc: false;
//这里是icon的存放文件夹
$icon-url: sprite-map('icon/*.png');

//以下为方法
%r-sprite{ 
    background-image: sprite-url($icon-url);
    background-repeat: no-repeat;
    @if ($ispc){
        $double-width:ceil(image-width(sprite-path($icon-url)) / 2);
        $double-height:ceil(image-height(sprite-path($icon-url)) / 2);
    }@else{
        $double-width:ceil(image-width(sprite-path($icon-url)));
        $double-height:ceil(image-height(sprite-path($icon-url)));
    }
    background-size: $double-width $double-height;
}
@mixin r-sprite($name) {
    @if ($ispc){
        @extend %r-sprite;
        background-position: sprite-position($icon-url,$name);
        height:image-height(sprite-file($icon-url, $name));
        width: image-width(sprite-file($icon-url, $name));
    }@else{
         @extend %r-sprite;
         background-position: 0 round(nth(sprite-position($icon-url, $name), 2) / 2);
         height:round(image-height(sprite-file($icon-url, $name)) / 2);
         width: round(image-width(sprite-file($icon-url, $name)) / 2 );
    }
}

//你可以这样引用
.sicon01 {
    @include r-sprite(icon01);
    float: left;
}

.sicon02 {
    @include r-sprite(icon02);
    float: right;
}

.sicon03 {
    @include r-sprite(icon03);
    position: relative;
}

//输出

.sicon01, .sicon02, .sicon03 { background-image: url('../images/icon.png'); background-repeat: no-repeat; background-size: 17px 48px; }

.sicon01 { background-position: 0 0; height: 16px; width: 15px; float: left; }

.sicon02 { background-position: 0 -16px; height: 17px; width: 16px; float: right; }

.sicon03 { background-position: 0 -32px; height: 15px; width: 17px; position: relative; }

```

这里是输出图片的引用地址`background-image`以及图片的大小`background-size`：

```
.sicon01, .sicon02, .sicon03 { background-image: url('../images/icon.png'); background-repeat: no-repeat; background-size: 17px 48px; }
```

而你会在以下代码中看到3个属性，它们都是自动获取的:

```
.sicon01 { background-position: 0 0; height: 16px; width: 15px; }
```
分别是图标的`background-position`、`width`、`height`，他们是自动输出，他们也会受到顶部`$ispc`的影响，你需要告诉它，输出的是`正常大小的图标`还是`缩小后的图标`。

我们该如何使用：

```
Div{
    @include r-sprite(icon01); 
}

Span{
    display: inline-block;
    @include r-sprite(icon02); 
}
```

### 输出:

```
Div { background-position: 0 0; height: 16px; width: 15px; }

Span { display: inline-block; background-position: 0 -16px; height: 17px; width: 16px; }

```

`sass-sprite` 目前本人正在实践运用中（通俗说用得还挺爽）。如果你有需要，可以参考我的方法去尝试。欢迎你的`request`。

求Star，欢迎Fork！
