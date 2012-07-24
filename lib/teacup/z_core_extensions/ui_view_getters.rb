# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $().find('stylename')
class UIView

  # get one stylesheet by stylename
  # my_view[:button] :button => #<UIButton..>
  def viewWithStylename name
    subviews.each do |view|
      if view.stylename == name
        return view
      end
    end
    subviews.each do |view|
      if v = view.viewWithStylename(name)
        return v
      end
    end
    nil  # couldn't find it
  end

  # get stylesheets by stylename
  # my_view.all :button => [#<UIButton..>, #<UIButton...>]
  def viewsWithStylename name
    r = []
    subviews.each do |view|
      if view.stylename == name
        r.push name
      end
      r += view.viewsWithStylename name
    end
    r
  end

end