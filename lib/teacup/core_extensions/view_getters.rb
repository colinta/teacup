# Methods to retrieve a subview using the stylename as a key
# Kinda similar to jQuery-style $(el).find('stylename')
module Teacup
  module View

    # get one subview by stylename or class.  If the receiver matches, it will be
    # returned
    # my_view.viewWithStylename :button => #<UIButton..>
    # my_view.viewWithStylename UIButton => #<UIButton..>
    def viewWithStylename name_or_class
      return self if self._teacup_check_stylename(name_or_class)

      view = self.teacup_subviews.find { |view| view._teacup_check_stylename(name_or_class) }
      return view if view

      # found_subview will get assigned to the view we want, but the subview is
      # what is returned.
      found_subview = nil
      view = self.teacup_subviews.find { |subview| found_subview = subview.viewWithStylename(name_or_class) }
      return found_subview if view

      return nil  # couldn't find it
    end

    # get all subviews by stylename or class
    # my_view.viewsWithStylename :button => [#<UIButton..>, #<UIButton...>]
    # my_view.viewsWithStylename UIButton => [#<UIButton..>, #<UIButton...>]
    def viewsWithStylename name_or_class
      retval = []
      retval << self if self._teacup_check_stylename(name_or_class)

      search_views = [].concat(self.subviews)
      # ewww, a traditional for loop! the search_views array is modified in place,
      # and `each` and other methods don't like that.
      index = 0
      while index < search_views.length
        view = search_views[index]
        if view._teacup_check_stylename(name_or_class)
          retval << view
        end
        search_views.concat(view.subviews)
        index += 1
      end

      return retval
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

end
