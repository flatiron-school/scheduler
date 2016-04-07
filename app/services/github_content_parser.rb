class GithubContentParser

  attr_accessor :content, :renderer, :labs_names

  def initialize(content)
    @content = content
    @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  def parse_content
    html_string = renderer.render(content)
    @labs_names = parse_labs(html_string)
    binding.pry
  end

  def parse_labs(html_string)
    labs_string = html_string.split("Labs").last
    doc = Nokogiri::HTML(labs_string)
    doc.search('a').collect { |a| a.text }
  end
end