class Flower
  def initialize(views, container_size)
    @views = views
    @container_size = container_size
  end

  def flow
    x = 0; y = 0
    max_height = 0
    @views.each do |view|
      size = view.bounds.size

      if view.position == :relative
        new_line = false
        if  (view.display == :block) ||
            (x + view.margin_left + size.width + 
             view.margin_right > @container_size.width)
          x = view.margin_left
          y += max_height + view.margin_top 
          max_height = 0
        else
            x += view.margin_left
        end
          
        view.frame = [[x,y], [size.width, size.height]]

        x += size.width + view.margin_right

        total_height = view.margin_top + size.height + view.margin_bottom
        max_height = total_height if total_height > max_height
      end
    end
  end
end
