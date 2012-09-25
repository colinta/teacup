# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $().find('stylename')
class UIView

  # get one subview by stylename or class
  # my_view.viewWithStylename :button => #<UIButton..>
  # my_view.viewWithStylename UIButton => #<UIButton..>
  def viewWithStylename name_or_class
    if name_or_class.is_a? Class
      view = subviews.find { |view| view.is_a? name_or_class }
    else
      view = subviews.find { |view| view.stylename == name_or_class }
    end
    return view if view

    # found_subview will get assigned to the view we want, but the subview is
    # what is returned.
    found_subview = nil
    view = subviews.find {|subview| found_subview = subview.viewWithStylename(name_or_class) }
    return found_subview if view

    nil  # couldn't find it
  end

  # get all subviews by stylename or class
  # my_view.viewsWithStylename :button => [#<UIButton..>, #<UIButton...>]
  # my_view.viewsWithStylename UIButton => [#<UIButton..>, #<UIButton...>]
  def viewsWithStylename name_or_class
    r = []
    subviews.each do |view|
      if name_or_class.is_a? Class
        if view.is_a? name_or_class
          r << view
        end
      else view.stylename == name_or_class
        r << view
      end
      r += view.viewsWithStylename name_or_class
    end
    r
  end

end