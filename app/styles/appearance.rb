class CustomAppearanceLabel < UILabel
end

class CustomAppearanceContainer < UIView
end

Teacup.handler UIView, :redHerring do |view, alpha|
  view.alpha = alpha
end

Teacup::Appearance.new do

  style CustomAppearanceLabel,
    redHerring: 0.75,
    numberOfLines: 3

  style CustomAppearanceContainer,
    backgroundColor: UIColor.whiteColor

  style CustomAppearanceLabel, when_contained_in: CustomAppearanceContainer,
    redHerring: 0.5,
    numberOfLines: 2

end
