module Teacup

  module TableViewDelegate

    def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
      cell.restyle!
      cell.apply_constraints
    end

  end

end
