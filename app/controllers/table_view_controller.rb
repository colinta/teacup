class TableViewController < UITableViewController
  include Teacup::TableViewDelegate

  stylesheet :table

  def viewDidLoad
    self.view.registerClass(CustomCell, forCellReuseIdentifier:'cell id')
  end

  def numberOfSectionsInTableView(table_view)
    1
  end

  def tableView(table_view, numberOfRowsInSection:section)
    10
  end

  def tableView(tableView, heightForRowAtIndexPath:index_path)
    100
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell = table_view.dequeueReusableCellWithIdentifier('cell id')

    # for testing cell reuse
    if cell.is_reused.nil?
      cell.is_reused = false
    else
      cell.is_reused = true
    end

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton

    cell.backgroundView = layout(UIView, :bg)

    layout(cell.contentView, :root) do
      cell.padding = subview(UIView, :padding) do
        cell.title_label = subview(UILabel, :cell_title_label, :text => "title #{index_path.row}")
        cell.details_label = subview(UILabel, :cell_details_label, :text => "details #{index_path.row}")
        cell.other_label = subview(UILabel, :cell_other_label, :text => "other #{index_path.row}")
      end
    end

    return cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    table_view.deselectRowAtIndexPath(index_path, animated:true)
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    super
    # one more change, to prove that this method can be overridden
    cell.title_label.textColor = UIColor.blueColor
  end

end


class CustomCell < UITableViewCell
  attr_accessor :padding, :title_label, :details_label, :other_label, :is_reused
end


Teacup::Stylesheet.new :table do
  style :bg,
    backgroundColor: UIColor.colorWithRed(247.0 / 256.0, green:221.0 / 256.0, blue:186.0 / 256.0, alpha:1)

  style :padding,
   backgroundColor: UIColor.greenColor,
   constraints: [
     constrain(:width).equals(:superview, :width).times(0.96),
     constrain(:height).equals(:superview, :height).times(0.96),
     constrain(:center_x).equals(:superview, :center_x),
     constrain(:center_y).equals(:superview, :center_y)
   ]

  style :cell_title_label,
      layer: {
        borderWidth: 1,
        borderColor: UIColor.redColor.CGColor,
      },
    font: UIFont.boldSystemFontOfSize(17),
    constraints: [
      constrain_height(20),
      constrain(:top).equals(:superview, :top),
      constrain(:width).equals(:superview, :width),
      constrain(:center_x).equals(:superview, :center_x)
    ]

  style :cell_details_label,
      layer: {
        borderWidth: 1,
        borderColor: UIColor.redColor.CGColor,
      },
      font: UIFont.systemFontOfSize(14),
      color: UIColor.grayColor,
      constraints: [
        constrain_height(17),
        constrain_below(:cell_title_label, 5),
        constrain(:width).equals(:superview, :width),
        constrain(:center_x).equals(:superview, :center_x)
      ]

  style :cell_other_label,
      layer: {
        borderWidth: 1,
        borderColor: UIColor.redColor.CGColor,
      },
      font: UIFont.systemFontOfSize(14),
      color: UIColor.grayColor,
      constraints: [
        constrain_height(17),
        constrain_below(:cell_details_label, 5),
        constrain(:width).equals(:superview, :width),
        constrain(:center_x).equals(:superview, :center_x)
      ]
end
