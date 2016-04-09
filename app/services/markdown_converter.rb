class MarkdownConverter

  def self.convert(html_string)
    schedule_template_content = html_string.split("<h1>").second.prepend("<h1>").split("</body>").first
    ReverseMarkdown.convert(schedule_template_content)
  end
end