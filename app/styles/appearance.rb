class CustomAppearanceLabel < UILabel
end

class CustomAppearanceContainer < UIView
end

Teacup::Appearance.new do

  style CustomAppearanceLabel,
    numberOfLines: 1

  style CustomAppearanceContainer,
    backgroundColor: UIColor.whiteColor

  style CustomAppearanceLabel, when_contained_in: CustomAppearanceContainer,
    numberOfLines: 2

end
