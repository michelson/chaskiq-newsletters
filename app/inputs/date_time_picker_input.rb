## app/inputs/date_time_picker_input.rb
class DateTimePickerInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'form-group') do
      template.content_tag(:div, class: 'input-group date') do
        template.concat span_calendar
        template.concat @builder.text_field(attribute_name, input_html_options)
        #template.concat span_remove
        #template.concat span_table
      end
    end
  end

  def input_html_options
    {class: 'form-control', readonly: true}
  end

  def span_calendar
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_calendar
    end
  end

  def icon_calendar
    "<i class='fa fa fa-calendar'></i>".html_safe
  end

end