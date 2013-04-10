# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $(el).find('stylename')
class UIView

  # get one subview by stylename or class.  If the receiver matches, it will be
  # returned
  # my_view.viewWithStylename :button => #<UIButton..>
  # my_view.viewWithStylename UIButton => #<UIButton..>
  def viewWithStylename name_or_class
    return self if self._teacup_check_stylename(name_or_class)

    view = subviews.find { |view| view._teacup_check_stylename(name_or_class) }
    return view if view

    # found_subview will get assigned to the view we want, but the subview is
    # what is returned.
    found_subview = nil
    view = subviews.find { |subview| found_subview = subview.viewWithStylename(name_or_class) }
    return found_subview if view

    nil  # couldn't find it
  end

  # get all subviews by stylename or class
  # my_view.viewsWithStylename :button => [#<UIButton..>, #<UIButton...>]
  # my_view.viewsWithStylename UIButton => [#<UIButton..>, #<UIButton...>]
  def viewsWithStylename name_or_class
    r = []
    r << self if self._teacup_check_stylename(name_or_class)

    subviews.each do |view|
      r << view if view._teacup_check_stylename(name_or_class)
      r.concat view.viewsWithStylename name_or_class
    end
    r
  end

  def _teacup_check_stylename(name_or_class)
    if name_or_class.is_a? Class
      return self.is_a?(name_or_class)
    elsif stylename == name_or_class
      return true
    elsif stylesheet.is_a?(Teacup::Stylesheet)
      return stylesheet.extends_style?(self.stylename, name_or_class)
    end
    return false
  end

end