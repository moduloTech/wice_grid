# encoding: utf-8
class XlsxExportController < ApplicationController
  def index
    @tasks_grid = initialize_grid(Task,
      include: [:priority, :status, :project, :assigned_users],
      order: 'statuses.name',
      custom_order: {
        'tasks.priority_id' => 'priorities.name',
        'tasks.status_id' => 'statuses.position',
        'tasks.project_id' => 'projects.name'
      },
      name: 'g1',
      enable_export_to_xlxs: true,
      xlsx_file_name: 'tasks'
    )

    @projects_grid = initialize_grid(Project,
      name: 'g2',
      enable_export_to_xlxs: true,
      xlsx_file_name: 'tasks'
    )

    export_grid_if_requested('g1' => 'tasks_grid', 'g2' => 'projects_grid') do
      # usual render or redirect code executed if the request is not a XLSX export request
    end
  end
end
