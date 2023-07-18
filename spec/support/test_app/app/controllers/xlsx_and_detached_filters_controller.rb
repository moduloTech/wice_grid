# encoding: utf-8
class XlsxAndDetachedFiltersController < ApplicationController
  def index
    @tasks_grid = initialize_grid(Task,
      name: 'grid',
      enable_export_to_xlsx: true,
      xlsx_file_name: 'tasks'
    )

    export_grid_if_requested('grid' => 'grid')
  end
end
