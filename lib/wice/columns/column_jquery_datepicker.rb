# encoding: utf-8
module Wice
  module Columns #:nodoc:
    class ViewColumnJqueryDatepicker < ViewColumn #:nodoc:

      include Wice::JsCalendarHelpers
      include Wice::Columns::CommonDateDatetimeMixin
      include Wice::Columns::CommonJsDateDatetimeMixin

      def do_render(params) #:nodoc:
        calendar_data_from = prepare_data_for_calendar(
          initial_date: params[:fr],
          title:        NlMessage['date_selector_tooltip_from'],
          name:         @name1,
          fire_event:   auto_reload,
          grid_name:    self.grid.name
        )

        calendar_data_to = prepare_data_for_calendar(
          initial_date: params[:to],
          title:        NlMessage['date_selector_tooltip_to'],
          name:         @name2,
          fire_event:   auto_reload,
          grid_name:    self.grid.name
        )

        calendar_data_from.the_other_datepicker_id_to   = calendar_data_to.dom_id
        calendar_data_to.the_other_datepicker_id_from   = calendar_data_from.dom_id

        html1 = date_calendar_jquery calendar_data_from

        html2 = date_calendar_jquery calendar_data_to

        %(<div class="date-filter wg-jquery-datepicker">#{html1}<br/>#{html2}</div>)
      end

      def has_auto_reloading_calendar? #:nodoc:
        auto_reload
      end

    end

    class ConditionsGeneratorColumnJqueryDatepicker < ConditionsGeneratorColumn  #:nodoc:
      def generate_conditions(table_alias, opts)   #:nodoc:
        conditions = [[]]
        if opts[:fr]
          conditions[0] << " #{@column_wrapper.alias_or_table_name(table_alias)}.#{@column_wrapper.name} >= ? "
          conditions << opts[:fr].to_date
        end

        if opts[:to]
          conditions[0] << " #{@column_wrapper.alias_or_table_name(table_alias)}.#{@column_wrapper.name} <= ? "
          conditions << (opts[:to].to_date + 1)
        end

        return false if conditions.size == 1

        conditions[0] = conditions[0].join(' and ')
        conditions
      end
    end
  end
end