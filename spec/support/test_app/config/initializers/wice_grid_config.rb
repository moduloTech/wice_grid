# encoding: utf-8
if defined?(Wice::Defaults)

  # Default number of rows to show per page.
  Wice::Defaults::PER_PAGE = 20

  # Default order direction
  Wice::Defaults::ORDER_DIRECTION = 'asc'

  # Default name for a grid. A grid name is the basis for a lot of
  # names including parameter names, DOM IDs, etc
  # The shorter the name is the shorter the request URI will be.
  Wice::Defaults::GRID_NAME = 'grid'

  # If REUSE_LAST_COLUMN_FOR_FILTER_ICONS is true and the last column doesn't have any filter and column name, it will be used
  # for filter related icons (filter icon, reset icon, show/hide icon), otherwise an additional table column is added.
  Wice::Defaults::REUSE_LAST_COLUMN_FOR_FILTER_ICONS = true

  # The label of the first option of a custom dropdown list meaning 'All items'
  Wice::Defaults::CUSTOM_FILTER_ALL_LABEL = '--'

  # A list of classes for the table tag of the grid
  Wice::Defaults::DEFAULT_TABLE_CLASSES = ['table', 'table-bordered', 'table-striped']

  # Allow switching between a single and multiple selection modes in custom filters (dropdown boxes)
  Wice::Defaults::ALLOW_MULTIPLE_SELECTION = true

  # Show the upper pagination panel by default or not
  Wice::Defaults::SHOW_UPPER_PAGINATION_PANEL = false

  # Disabling XLSX export by default
  Wice::Defaults::ENABLE_EXPORT_TO_XLSX = false

  # The strategy when to show the filter.
  # * <tt>:when_filtered</tt> - when the table is the result of filtering
  # * <tt>:always</tt>        - show the filter always
  # * <tt>:no</tt>            - never show the filter
  Wice::Defaults::SHOW_FILTER = :always

  # A boolean value specifying if a change in a filter triggers reloading of the grid.
  Wice::Defaults::AUTO_RELOAD = false

  # SQL operator used for matching strings in string filters.
  Wice::Defaults::STRING_MATCHING_OPERATOR = 'LIKE'
  # STRING_MATCHING_OPERATOR = 'ILIKE' # Use this for Postgresql case-insensitive matching.

  # Defining one string matching operator globally for the whole application turns is not enough
  # when you connect to two databases one of which is MySQL and the other is Postgresql.
  # If the key for an adapter is missing it will fall back to Wice::Defaults::STRING_MATCHING_OPERATOR
  Wice::Defaults::STRING_MATCHING_OPERATORS = {
    'ActiveRecord::ConnectionAdapters::MysqlAdapter' => 'LIKE',
    'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter' => 'ILIKE'
  }

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #                              Advanced Filters                             #

  # Switch of the negation checkbox in all text filters
  Wice::Defaults::NEGATION_IN_STRING_FILTERS = false

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #                              Showing All Records                          #

  # Enable or disable showing all records (non-paginated table)
  Wice::Defaults::ALLOW_SHOWING_ALL_RECORDS = true

  # If number of all queries is more than this value, the user will be given a warning message
  Wice::Defaults::START_SHOWING_WARNING_FROM = 100

  # Hide the "show all" link if the number of all records is more than...
  # Force-resets back to pagination starting from this value.
  # Set to nil to always show it
  Wice::Defaults::SHOW_ALL_ALLOWED_UP_TO = nil

  #
  # set to nil to skip the check
  Wice::Defaults::SWITCH_BACK_TO_PAGINATION_FROM = nil

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #                               Saving Queries                              #

  # ActiveRecord model to store queries. Read the documentation for details
  # QUERY_STORE_MODEL = 'WiceGridSerializedQuery'
  Wice::Defaults::QUERY_STORE_MODEL = 'WiceGridSerializedQuery'

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #            Here go settings related to the date/datetime filters          #

  # Default column filters
  # Possible values:
  # * <tt>:jquery_datepicker</tt> - Jquery datepicker (works for datetime, too)
  # * <tt>:bootstrap_datepicker</tt> - Bootstrap datepicker (works for datetime, too)
  # * <tt>:rails_date_helper</tt> - standard Rails date helper
  # * <tt>:rails_datetime_helper</tt> - standard Rails datetime helper

  Wice::Defaults::DEFAULT_FILTER_FOR_DATE     = :jquery_datepicker
  Wice::Defaults::DEFAULT_FILTER_FOR_DATETIME = :jquery_datepicker

  # Format of the datetime displayed.
  # If you change the format, make sure to check if +DATETIME_PARSER+ can still parse this string.
  Wice::Defaults::DATETIME_FORMAT = '%Y-%m-%d %H:%M'

  # Format of the date displayed.
  # If you change the format, make sure to check if +DATE_PARSER+ can still parse this string.
  Wice::Defaults::DATE_FORMAT     =  '%Y-%m-%d'

  # Format of the date displayed in jQuery's Datepicker
  # If you change the format, make sure to check if +DATE_PARSER+ can still parse this string.
  Wice::Defaults::DATE_FORMAT_JQUERY     =  'yy-mm-dd'

  # Format of the date displayed in Bootstrap's Datepicker
  # If you change the format, make sure to check if +DATE_PARSER+ can still parse this string.
  Wice::Defaults::DATE_FORMAT_BOOTSTRAP     =  'yyyy-mm-dd'

  # With Calendar helpers enabled the parameter sent is the string displayed. This lambda will be given a date string in the
  # format defined by +DATETIME_FORMAT+ and must generate a DateTime object.
  # In many cases <tt>Time.zone.parse</tt> is enough, for instance,  <tt>%Y-%m-%d</tt>. If you change the format, make sure to check this code
  # and modify it if needed.
  Wice::Defaults::DATETIME_PARSER = lambda do|datetime_string|
    if datetime_string.blank?
      nil
    elsif Time.zone
      Time.zone.parse(datetime_string)
    else
      Time.parse(datetime_string)
    end
  end

  # The range of years to display in jQuery Datepicker.
  # It can always be changed dynamically with the following javascript:
  #  $( ".hasDatepicker" ).datepicker( "option", "yearRange", "2000:2042" );
  Wice::Defaults::DATEPICKER_YEAR_RANGE = (from = Date.current.year - 10).to_s + ':' + (from + 15).to_s

  # With Calendar helpers enabled the parameter sent is the string displayed. This lambda will be given a date string in the
  # format defined by +DATETIME+ and must generate a Date object.
  # In many cases <tt>Date.parse</tt> is enough, for instance,  <tt>%Y-%m-%d</tt>. If you change the format, make sure to check this code
  # and modify it if needed.
  Wice::Defaults::DATE_PARSER = lambda do|date_string|
    if date_string.blank?
      nil
    else
      Date.parse(date_string)
    end
  end

  # The name of the page method (should correspond to Kaminari.config.page_method_name)
  Wice::Defaults::PAGE_METHOD_NAME = :page

  # The name of the theme to use for the pagination with Kaminari
  Wice::Defaults::PAGINATION_THEME = :wice_grid

  # by default Wice-Grid always use unscoped,set to true to force use of default_scope by default instead
  Wice::Defaults::USE_DEFAULT_SCOPE = false


end
