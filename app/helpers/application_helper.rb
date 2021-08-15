module ApplicationHelper
  ICONS = {
    search: '<circle cx="11" cy="11" r="6.5"/><path d="M16 16l4.5 4.5"/>',
    star: '<path d="M12 3.5l2.6 5.4 5.9.8-4.3 4.1 1 5.8L12 16.9l-5.2 2.7 1-5.8-4.3-4.1 5.9-.8z"/>',
    note: '<path d="M5 4.5h14v11H10l-5 4z"/>'
  }.freeze

  # Small inline SVG icons; decorative, so hidden from assistive tech.
  def icon(name)
    tag.svg(ICONS.fetch(name).html_safe, class: "icon icon-#{name}", viewBox: '0 0 24 24', 'aria-hidden': 'true',
                                         focusable: 'false')
  end
end
