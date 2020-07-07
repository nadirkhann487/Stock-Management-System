module OrderHelper

  def status_label status
    case status
    when 'open'
      content_tag(:span, status.titleize, class: 'badge badge-pill badge-primary')
    when 'Picked'
      content_tag(:span, status.titleize, class: 'badge badge-pill badge-warning')
    when 'Dispatched'
      content_tag(:span, status.titleize, class: 'badge badge-pill badge-success')
    end
  end

end
