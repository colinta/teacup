##
# Styling is based on the UIAppearance Protocol and friends.
# http://developer.apple.com/library/ios/#documentation/UIKit/Reference/UIAppearance_Protocol/Reference/Reference.html
#
# Styles should be small components which can be defined and reused outside the controller and view scope.
# Taking a non intrusive approach allows the styling to have the same benifits css has for html.
# It keeps implementation of Bussiness Logic and styling seperated.
#
# All methods and namings are up for debate
#

# Small style components
Teacup::Style.define :rounded do |s|
  s.borderRadius = 10
end

# Style componets are extendable
Teacup::Style.define :dark, :extends => :rounded do |s|
  s.backgroundColor = rgba(50, 50, 50, 0.5)
  s.textColor = rgb(255, 255, 255)
end

Teacup::Style.define :green_text do |s|
  s.textColor = "#0000FF"
end

# Styles can be applies globaly
UIView.adopt_style :dark
UIButton.adopt_style :rounded

# Styles can applied per instance
button = UIButton.alloc.init
button.adopt_style :dark, :green_text

# Styles can be refined
button.style do |s|
  s.backgroundColor = "#FF0099"
end

# Styles can be applied within a style scope
Teacup::Style.style_scope :dark do |s|
  # All view instances will have :dark style applied
  button = UIButton.alloc.init
  cell = UITableCell.alloc.init
end


# Styles can define nested styles.
# Nested will attempt to apply the nested styles a the getter with the corresponding name
Teacup::Style.define_style :my_cell_style do |s|
  s.backgroundColor = rgb(0, 0, 0)

  # apply styles the view in the #imageView
  s.style :imageView do |s|
    s.frame = [[10, 10], [50, 50]]
  end

  # styles can be adopted
  s.style :textLabel, :adopt => :green_text

  # styles can be adopted and overwritten
  s.style :detailTextLabel, :adopt => :dark do |s|
    s.textColor = UIColor.blueColor
  end
end

my_styled_cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"MyCell")
my_styled_cell.adopt_style :my_cell_style


# Style component setting costraints
# Constraints conform to CALayer constraints
# http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreAnimation_guide/Articles/Layout.html#//apple_ref/doc/uid/TP40006084-SW5
#
Teacup::Style.define_constraint :vertical_list do |c, rel|
  c.width rel
  c.minY  rel, :offset => -20
  c.maxY  rel, :offset => 20
end

super_button = UIButton.alloc.initWithFrame [[10, 10], [100, 30]]

button_a = UIButton.alloc.init
button_a.adopt_containt :vertical_list, super_button

button_b = UIButton.alloc.init
button_b.adopt_containt :vertical_list, button_a
