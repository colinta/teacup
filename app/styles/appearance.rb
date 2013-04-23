class CustomAppearanceLabel < UILabel
end

class CustomAppearanceContainer < UIView
end

Teacup.handler UIView, :redHerring { |view, alpha|
  view.alpha = alpha
}

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
